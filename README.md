# listen_flow

A Flutter project showcasing a clean architecture approach for building an interactive media player application. This English listening practice tool serves as an example of using modern Flutter techniques.

✨ Core Functionality:
*   Audio playback synchronized with transcript highlighting.
*   Sentence-level seeking via transcript interaction.
*   Playback speed control.

🏗️ Architecture & Tech Highlights:
*   **State Management:** Riverpod (with Hooks) using StateNotifierProvider and FutureProvider.
*   **Immutability:** Freezed for generating immutable models and state classes.
*   **Navigation:** Declarative routing managed by GoRouter.
*   **Feature-First Structure:** Code organized by application features.
*   **Audio Integration:** Utilizes the `audioplayers` package.
*   **UI Synchronization:** Leverages `scrollable_positioned_list` for transcript auto-scrolling.


