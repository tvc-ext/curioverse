# Euphoriks Quizzie rebrand

This branch prepares the public-facing rebrand from **CurioVerse** to **Euphoriks Quizzie** without changing the Android application/package identity used by the existing Google Play closed test.

## Brand architecture

- Master brand: **Euphoriks**
- Product: **Quizzie**
- Full store/app name: **Euphoriks Quizzie**
- Suggested lockup: **QUIZZIE · by EUPHORIKS**
- Positioning line: **Explore · Play · Learn**

## Release strategy

1. Keep the existing Google Play closed test and package/application ID intact.
2. Prepare branding, documentation, website, privacy/support copy and store assets on this feature branch.
3. Do not merge until the new brand and all generated assets are reviewed.
4. Before production, upload a new signed AAB containing the new display branding and update the Play Store listing.

## Store listing asset requirements

- App icon: 512 × 512 PNG, Play Store compliant.
- Feature graphic: 1024 × 500 PNG/JPEG.
- Phone screenshots: use actual current app UI; do not advertise unimplemented functionality.
- Promo video: optional and can remain blank for initial production release.

## Store listing draft

### App name

Euphoriks Quizzie

### Short description

Explore, play and learn through fun educational worlds made for curious kids.

### Full description

Euphoriks Quizzie is a colourful learning adventure designed to help children explore the world through play, discovery and curiosity.

Children can journey through exciting learning worlds covering topics such as space, animals, amazing places, history, science and more. Interactive quizzes, activities and challenges make learning engaging and rewarding.

**Explore Learning Worlds**
Discover fascinating facts and educational content across a growing collection of kid-friendly topics.

**Play and Learn**
Test knowledge with quizzes, puzzles and interactive activities designed to make learning enjoyable.

**Discover with Images**
Quizzie includes experiences that let children explore and learn about images using on-device technology.

**Built with Children in Mind**
Euphoriks Quizzie is designed as a child-friendly learning experience. It does not contain advertising and does not require children to create a Euphoriks cloud account.

**Learning Beyond the Classroom**
Quizzie encourages curiosity, exploration and independent learning, turning screen time into discovery time.

Explore · Play · Learn.

## Safety and privacy invariants

The rebrand must not alter the current privacy model merely for branding:

- no ads;
- nickname/generated-alias identity rather than child real names;
- local profile/progress storage;
- no public/free-form child-to-child chat;
- camera/gallery only for the existing scanner experience;
- on-device ML image labeling from application code;
- external/public educational content may be retrieved over the network;
- privacy and Data Safety statements must describe actual implementation rather than marketing intent.

## Naming note

This document is an engineering/branding plan, not legal trademark clearance. Similar-name and trademark review should be completed before public production launch.
