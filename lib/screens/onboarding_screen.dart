import 'package:flutter/material.dart';

import '../models/child_profile.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({required this.onComplete, super.key});

  final Future<void> Function(ChildProfile profile) onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  AgeBand? selectedAgeBand;
  AvatarChoice? selectedAvatar;
  bool isSaving = false;

  bool get canContinue =>
      selectedAgeBand != null && selectedAvatar != null && !isSaving;

  Future<void> complete() async {
    if (!canContinue) return;
    setState(() => isSaving = true);
    await widget.onComplete(
      ChildProfile(
        ageBand: selectedAgeBand!,
        avatarId: selectedAvatar!.id,
      ),
    );
    if (mounted) setState(() => isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
          children: [
            const Text('✨', style: TextStyle(fontSize: 42)),
            const SizedBox(height: 12),
            Text(
              'Welcome to CurioVerse!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose a learning level and a fun explorer identity. '
              'We never need your real name or exact age.',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 28),
            const _StepTitle(number: 1, title: 'Choose your age group'),
            const SizedBox(height: 12),
            ...AgeBand.values.map(
              (band) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _AgeBandCard(
                  band: band,
                  selected: selectedAgeBand == band,
                  onTap: () => setState(() => selectedAgeBand = band),
                ),
              ),
            ),
            const SizedBox(height: 22),
            const _StepTitle(number: 2, title: 'Choose your explorer'),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: avatarChoices
                  .map(
                    (avatar) => _AvatarCard(
                      avatar: avatar,
                      selected: selectedAvatar?.id == avatar.id,
                      onTap: () => setState(() => selectedAvatar = avatar),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: canContinue ? complete : null,
              icon: isSaving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.rocket_launch_rounded),
              label: Text(isSaving ? 'Preparing...' : 'Enter CurioVerse'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline_rounded, size: 17),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Your explorer profile stays on this device.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepTitle extends StatelessWidget {
  const _StepTitle({required this.number, required this.title});

  final int number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          child: Text('$number', style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
        const SizedBox(width: 10),
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

class _AgeBandCard extends StatelessWidget {
  const _AgeBandCard({
    required this.band,
    required this.selected,
    required this.onTap,
  });

  final AgeBand band;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selected
          ? Theme.of(context).colorScheme.primaryContainer
          : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: selected
                    ? Theme.of(context).colorScheme.primary
                    : const Color(0xFFEDEAFF),
                foregroundColor: selected ? Colors.white : const Color(0xFF4936A7),
                child: Text(band.label),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  band.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarCard extends StatelessWidget {
  const _AvatarCard({
    required this.avatar,
    required this.selected,
    required this.onTap,
  });

  final AvatarChoice avatar;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selected
          ? Theme.of(context).colorScheme.secondaryContainer
          : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(avatar.emoji, style: const TextStyle(fontSize: 44)),
                  const SizedBox(height: 8),
                  Text(
                    avatar.alias,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            if (selected)
              const Positioned(
                top: 10,
                right: 10,
                child: Icon(Icons.check_circle_rounded),
              ),
          ],
        ),
      ),
    );
  }
}
