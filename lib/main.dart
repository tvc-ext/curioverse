import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/profile_store.dart';
import 'models/child_profile.dart';
import 'screens/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final store = SharedPreferencesProfileStore(preferences);
  runApp(
    CurioVerseApp(
      profileStore: store,
      initialProfile: await store.load(),
    ),
  );
}

class CurioVerseApp extends StatefulWidget {
  const CurioVerseApp({
    required this.profileStore,
    this.initialProfile,
    super.key,
  });

  final ProfileStore profileStore;
  final ChildProfile? initialProfile;

  @override
  State<CurioVerseApp> createState() => _CurioVerseAppState();
}

class _CurioVerseAppState extends State<CurioVerseApp> {
  late ChildProfile? profile = widget.initialProfile;

  Future<void> completeOnboarding(ChildProfile newProfile) async {
    await widget.profileStore.save(newProfile);
    setState(() => profile = newProfile);
  }

  Future<void> resetProfile() async {
    await widget.profileStore.clear();
    setState(() => profile = null);
  }

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF6750E8);
    return MaterialApp(
      title: 'CurioVerse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F7FF),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
      ),
      home: profile == null
          ? OnboardingScreen(onComplete: completeOnboarding)
          : UniverseShell(profile: profile!, onResetProfile: resetProfile),
    );
  }
}

class UniverseShell extends StatefulWidget {
  const UniverseShell({
    required this.profile,
    required this.onResetProfile,
    super.key,
  });

  final ChildProfile profile;
  final Future<void> Function() onResetProfile;

  @override
  State<UniverseShell> createState() => _UniverseShellState();
}

class _UniverseShellState extends State<UniverseShell> {
  int currentIndex = 0;

  static const destinations = [
    NavigationDestination(
      icon: Icon(Icons.auto_awesome_outlined),
      selectedIcon: Icon(Icons.auto_awesome),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.explore_outlined),
      selectedIcon: Icon(Icons.explore),
      label: 'Explore',
    ),
    NavigationDestination(
      icon: Icon(Icons.sports_esports_outlined),
      selectedIcon: Icon(Icons.sports_esports),
      label: 'Games',
    ),
    NavigationDestination(
      icon: Icon(Icons.group_outlined),
      selectedIcon: Icon(Icons.group),
      label: 'Friends',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeUniverse(profile: widget.profile),
      const PlaceholderPage(
        icon: Icons.rocket_launch,
        title: 'Explore worlds',
        message: 'Science, nature, space, inventions and more are coming.',
      ),
      const PlaceholderPage(
        icon: Icons.extension,
        title: 'Brain games',
        message: 'Pattern, memory and logic missions will live here.',
      ),
      const PlaceholderPage(
        icon: Icons.shield_outlined,
        title: 'Friends clubhouse',
        message: 'Only parent-approved aliases and invite codes—never real names.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CurioVerse',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Explorer profile',
            onSelected: (value) {
              if (value == 'reset') widget.onResetProfile();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Text(
                  '${widget.profile.avatar.emoji} ${widget.profile.avatar.alias} · ${widget.profile.ageBand.label}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const PopupMenuItem(
                value: 'reset',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.switch_account_outlined),
                  title: Text('Change explorer'),
                ),
              ),
            ],
            child: CircleAvatar(
              backgroundColor: const Color(0xFFEDEAFF),
              child: Text(
                widget.profile.avatar.emoji,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Semantics(
            label: 'Curiosity energy: 120',
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Chip(
                avatar: Icon(Icons.bolt, color: Color(0xFFFF8A00)),
                label: Text('120'),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(child: pages[currentIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        destinations: destinations,
        onDestinationSelected: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}

class HomeUniverse extends StatelessWidget {
  const HomeUniverse({required this.profile, super.key});

  final ChildProfile profile;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Text(
          'Hello, ${profile.avatar.alias}!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'What will you discover today?',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        const MissionCard(),
        const SizedBox(height: 24),
        const SectionTitle(title: 'Pick a world', action: 'See all'),
        const SizedBox(height: 12),
        const Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            WorldCard(
              emoji: '🚀',
              title: 'Space',
              color: Color(0xFFE3DFFF),
            ),
            WorldCard(
              emoji: '🦖',
              title: 'Dinosaurs',
              color: Color(0xFFD9F7E7),
            ),
            WorldCard(
              emoji: '🤖',
              title: 'AI Lab',
              color: Color(0xFFFFE3D8),
            ),
            WorldCard(
              emoji: '🌊',
              title: 'Oceans',
              color: Color(0xFFD9F2FF),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const SectionTitle(title: 'Quick challenge', action: '2 min'),
        const SizedBox(height: 12),
        Card(
          color: Colors.white,
          child: ListTile(
            contentPadding: const EdgeInsets.all(18),
            leading: const CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xFFFFEDB8),
              child: Text('🧠', style: TextStyle(fontSize: 28)),
            ),
            title: const Text(
              'Can you crack the pattern?',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text('A tiny logic mission worth 20 energy'),
            ),
            trailing: const Icon(Icons.arrow_forward_rounded),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class MissionCard extends StatelessWidget {
  const MissionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2D2475),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('TODAY’S MISSION',
                style: TextStyle(
                  color: Color(0xFFFFCB67),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                )),
            const SizedBox(height: 10),
            const Text(
              'Why does the Moon change shape?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Explore a visual story and answer 3 questions.',
              style: TextStyle(color: Color(0xFFDCD8FF), fontSize: 16),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFFCB67),
                foregroundColor: const Color(0xFF2D2475),
              ),
              onPressed: () {},
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start mission'),
            ),
          ],
        ),
      ),
    );
  }
}

class WorldCard extends StatelessWidget {
  const WorldCard({
    required this.emoji,
    required this.title,
    required this.color,
    super.key,
  });

  final String emoji;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.sizeOf(context).width - 52) / 2;
    return SizedBox(
      width: width,
      child: Card(
        color: color,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 36)),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({required this.title, required this.action, super.key});

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
        ),
        Text(action, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 10),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
