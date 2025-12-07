# WordScramble

A modern SwiftUI take on the classic word game. Make as many valid words as you can from a randomly chosen root word — with smooth animations, helpful validation, and a clean architecture under the hood.

## Features

- SwiftUI-first interface with smooth animations and system effects
- Score tracking and guessed word list
- Live validation with friendly error messages
- New Game flow with loading state overlay
- Haptic/sensory feedback on success and errors
- Clean architecture with Use Cases and Repository pattern

## Screenshots

> Replace these placeholders with your own images or GIFs.

- Gameplay
  - ![Gameplay](docs/images/gameplay.png)
- Validation
  - ![Validation](docs/images/validation.png)

## Architecture Overview

The app follows a lightweight clean architecture:

- Views (SwiftUI): Render UI and forward user intents
- ViewModel: Exposes state (root word, used words, score, errors, loading) and orchestrates use cases
- Use Cases:
  - StartNewGameUseCase — loads a new root word from a repository
  - SubmitWordUseCase — validates and scores a guess via a validator
- Repository: LocalWordListRepository provides root words
- Validation: NativeLanguageWordValidator validates words for a given language

This separation keeps UI simple, business logic testable, and dependencies clear.

## Notable UI Details

- List with `.insetGrouped` style
- ProgressView overlay with `.ultraThinMaterial` while loading
- `sensoryFeedback(.success)` when a valid word is accepted
- `sensoryFeedback(.error)` when input is invalid
- Focus handling using `@FocusState` for fast, repeated submissions

## Requirements

- Xcode 15+ (recommended: latest Xcode)
- iOS 17+
- Swift 5.9+

## Getting Started

1. Clone the repository
   ```bash
   git clone https://github.com/your-username/WordScramble.git
   cd WordScramble
