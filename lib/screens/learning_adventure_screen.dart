import 'package:flutter/material.dart';

import '../data/open_knowledge_service.dart';
import '../models/child_profile.dart';
import '../models/learning_topic.dart';
import 'animal_scanner_screen.dart';

class LearningAdventureScreen extends StatefulWidget {
  const LearningAdventureScreen({
    required this.ageBand,
    required this.knowledgeSource,
    required this.completedTopicIds,
    required this.onTopicCompleted,
    this.initialTopicId,
    super.key,
  });

  final AgeBand ageBand;
  final OpenKnowledgeSource knowledgeSource;
  final Set<String> completedTopicIds;
  final Future<void> Function(String topicId, int reward) onTopicCompleted;
  final String? initialTopicId;

  @override
  State<LearningAdventureScreen> createState() =>
      _LearningAdventureScreenState();
}

enum _AdventureView { catalog, story, quiz, result }

class _LearningAdventureScreenState extends State<LearningAdventureScreen> {
  _AdventureView view = _AdventureView.catalog;
  LearningTopic topic = moonTopic;

  @override
  void initState() {
    super.initState();
    final requestedId = widget.initialTopicId;
    if (requestedId == null) return;
    final matches =
        learningTopics.where((candidate) => candidate.id == requestedId);
    if (matches.isNotEmpty && matches.first.storyPages.isNotEmpty) {
      topic = matches.first;
      view = _AdventureView.story;
    }
  }
  int storyPage = 0;
  int questionIndex = 0;
  int? selectedAnswer;
  int score = 0;
  bool savingReward = false;

  List<LearningTopic> get availableTopics => learningTopics
      .where((candidate) => candidate.supports(widget.ageBand))
      .toList();

  void openTopic(LearningTopic selected) {
    if (selected.storyPages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${selected.title} is coming in the next pack!')),
      );
      return;
    }
    setState(() {
      topic = selected;
      storyPage = 0;
      view = _AdventureView.story;
    });
  }

  void startQuiz() {
    setState(() {
      view = _AdventureView.quiz;
      questionIndex = 0;
      selectedAnswer = null;
      score = 0;
    });
  }

  void chooseAnswer(int index) {
    if (selectedAnswer != null) return;
    setState(() {
      selectedAnswer = index;
      if (index == topic.questions[questionIndex].correctIndex) score++;
    });
  }

  Future<void> nextQuestion() async {
    if (questionIndex < topic.questions.length - 1) {
      setState(() {
        questionIndex++;
        selectedAnswer = null;
      });
      return;
    }

    setState(() {
      view = _AdventureView.result;
      savingReward = true;
    });
    await widget.onTopicCompleted(topic.id, 30);
    if (mounted) setState(() => savingReward = false);
  }

  @override
  Widget build(BuildContext context) {
    final child = switch (view) {
      _AdventureView.catalog => _buildCatalog(context),
      _AdventureView.story => _buildStory(context),
      _AdventureView.quiz => _buildQuiz(context),
      _AdventureView.result => _buildResult(context),
    };
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.97, end: 1).animate(animation),
          child: child,
        ),
      ),
      child: child,
    );
  }

  Widget _buildCatalog(BuildContext context) {
    return ListView(
      key: const ValueKey('learning-catalog'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      children: [
        Text(
          'Explore your universe',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Picked for ${widget.ageBand.title} · ages ${widget.ageBand.label}',
        ),
        const SizedBox(height: 18),
        ...availableTopics.map(
          (candidate) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _TopicCard(
              topic: candidate,
              completed: widget.completedTopicIds.contains(candidate.id),
              onTap: () => openTopic(candidate),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          color: const Color(0xFFDDF6D8),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const AnimalScannerScreen(),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(18),
              child: Row(
                children: [
                  Text('📷', style: TextStyle(fontSize: 44)),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scan an animal picture',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('Private on-device AI identification'),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_rounded),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const _SectionHeading(
          icon: Icons.public_rounded,
          title: 'Open Knowledge Stream',
        ),
        const SizedBox(height: 6),
        const Text(
          'Fresh facts from public knowledge APIs. Only approved topics are requested; your profile is never sent.',
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<OpenKnowledgeItem>>(
          future: widget.knowledgeSource.load(widget.ageBand),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final items = snapshot.data ?? const [];
            if (items.isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    'You are offline. Your built-in adventures still work!',
                  ),
                ),
              );
            }
            return SizedBox(
              height: 230,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) =>
                    _KnowledgeCard(item: items[index]),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStory(BuildContext context) {
    final page = topic.storyPages[storyPage];
    final progress = (storyPage + 1) / topic.storyPages.length;

    return ListView(
      key: const ValueKey('visual-story'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => setState(() => view = _AdventureView.catalog),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('All adventures'),
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: progress, minHeight: 8),
        const SizedBox(height: 22),
        Container(
          height: 230,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF17113F), Color(0xFF5144A8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            children: [
              const Positioned(
                top: 24,
                left: 30,
                child: Text('✨', style: TextStyle(fontSize: 34)),
              ),
              const Positioned(
                bottom: 34,
                right: 34,
                child: Text('🌍', style: TextStyle(fontSize: 58)),
              ),
              Center(
                child: Text(topic.emoji, style: const TextStyle(fontSize: 100)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          topic.storyTitle,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 12),
        Text(page, style: const TextStyle(fontSize: 18, height: 1.55)),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: storyPage < topic.storyPages.length - 1
              ? () => setState(() => storyPage++)
              : startQuiz,
          icon: Icon(
            storyPage < topic.storyPages.length - 1
                ? Icons.arrow_forward_rounded
                : Icons.psychology_rounded,
          ),
          label: Text(
            storyPage < topic.storyPages.length - 1
                ? 'Next discovery'
                : 'Take the 3-question challenge',
          ),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(54),
          ),
        ),
      ],
    );
  }

  Widget _buildQuiz(BuildContext context) {
    final question = topic.questions[questionIndex];
    return ListView(
      key: const ValueKey('topic-quiz'),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
      children: [
        Text(
          'Question ${questionIndex + 1} of ${topic.questions.length}',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (questionIndex + 1) / topic.questions.length,
          minHeight: 8,
        ),
        const SizedBox(height: 28),
        const Text('🧠', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 12),
        Text(
          question.prompt,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 18),
        ...List.generate(question.options.length, (index) {
          final isSelected = selectedAnswer == index;
          final isCorrect = index == question.correctIndex;
          Color? color;
          if (selectedAnswer != null && isCorrect) {
            color = const Color(0xFFD8F5E5);
          } else if (isSelected) {
            color = const Color(0xFFFFDFDF);
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              color: color ?? Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => chooseAnswer(index),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          question.options[index],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (selectedAnswer != null && isCorrect)
                        const Icon(Icons.check_circle, color: Colors.green)
                      else if (isSelected)
                        const Icon(Icons.cancel, color: Colors.red),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        if (selectedAnswer != null) ...[
          const SizedBox(height: 10),
          Card(
            color: const Color(0xFFFFF1C7),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                question.explanation,
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: nextQuestion,
            child: Text(
              questionIndex < topic.questions.length - 1
                  ? 'Next question'
                  : 'See my result',
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildResult(BuildContext context) {
    final alreadyCompleted = widget.completedTopicIds.contains(topic.id);
    return Center(
      key: const ValueKey('quiz-result'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 84)),
            const SizedBox(height: 16),
            Text(
              'Mission complete!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'You solved $score of ${topic.questions.length} questions.',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 14),
            Chip(
              avatar: const Icon(Icons.bolt, color: Color(0xFFFF8A00)),
              label: Text(
                alreadyCompleted ? 'Adventure replayed' : '+30 curiosity energy',
              ),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: savingReward
                  ? null
                  : () => setState(() => view = _AdventureView.catalog),
              icon: const Icon(Icons.explore_rounded),
              label: const Text('Explore another world'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({
    required this.topic,
    required this.completed,
    required this.onTap,
  });

  final LearningTopic topic;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(topic.colorValue),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Text(topic.emoji, style: const TextStyle(fontSize: 46)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(topic.subtitle),
                  ],
                ),
              ),
              Icon(
                completed
                    ? Icons.check_circle_rounded
                    : Icons.arrow_forward_rounded,
                color: completed ? Colors.green : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KnowledgeCard extends StatelessWidget {
  const _KnowledgeCard({required this.item});

  final OpenKnowledgeItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.imageUrl != null)
              Image.network(
                item.imageUrl!,
                height: 105,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  height: 105,
                  child: Center(
                    child: Text('🌐', style: TextStyle(fontSize: 42)),
                  ),
                ),
              )
            else
              const SizedBox(
                height: 105,
                child: Center(
                  child: Text('🌐', style: TextStyle(fontSize: 42)),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Text(
                item.summary,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                item.credit,
                style: const TextStyle(fontSize: 10, color: Colors.blueGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
        ),
      ],
    );
  }
}
