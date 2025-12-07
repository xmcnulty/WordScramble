// WordScrambleScreen.swift

import SwiftUI

struct WordScrambleScreen: View {
    @StateObject private var viewModel = WordScrambleViewModel()
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationStack {
            List {
                ScoreHeaderView(score: viewModel.score, wordCount: viewModel.usedWords.count)
                WordInputSection(
                    currentGuess: $viewModel.currentGuess,
                    onSubmit: submitWord
                )
                GuessedWordsView(words: viewModel.usedWords)
            }
            .listStyle(.insetGrouped)
            .navigationTitle(viewModel.rootWord ?? "Word Scramble")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("New Game") {
                        startNewGame()
                    }
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.ultraThinMaterial)
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .alert(item: $viewModel.invalidInputError) { error in
                Alert(
                    title: Text("Invalid Word"),
                    message: Text(error.localizedDescription),
                    dismissButton: .default(Text("OK")) {
                        viewModel.invalidInputError = nil
                    }
                )
            }
            .onAppear {
                startNewGame()
            }
            .onChange(of: viewModel.invalidInputError) { error in
                if error != nil {
                    sensoryFeedback(.error)
                }
            }
            .onChange(of: viewModel.usedWords) { _ in
                sensoryFeedback(.success)
            }
            .focused($isInputFocused)
        }
    }

    private func startNewGame() {
        Task {
            await viewModel.startNewGame()
            isInputFocused = true
        }
    }

    private func submitWord() {
        Task {
            await viewModel.submitCurrentGuess()
            isInputFocused = true
        }
    }
}

// MARK: - Subviews

struct ScoreHeaderView: View {
    let score: Int
    let wordCount: Int

    var body: some View {
        HStack {
            Label("Score: \(score)", systemImage: "star.fill")
                .foregroundColor(.yellow)
                .font(.headline)
            Spacer()
            Label("Words: \(wordCount)", systemImage: "list.bullet")
                .font(.headline)
        }
        .padding(.vertical, 8)
    }
}

struct WordInputSection: View {
    @Binding var currentGuess: String
    var onSubmit: () -> Void

    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        Section {
            HStack {
                TextField("Enter word", text: $currentGuess)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.done)
                    .focused($isTextFieldFocused)
                    .onSubmit {
                        onSubmit()
                        currentGuess = ""
                    }
                Button("Submit") {
                    onSubmit()
                    currentGuess = ""
                    isTextFieldFocused = true
                }
                .buttonStyle(.borderedProminent)
                .disabled(currentGuess.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.vertical, 8)
        }
    }
}

struct GuessedWordsView: View {
    let words: [String]

    var body: some View {
        Section("Guessed Words") {
            if words.isEmpty {
                Text("No words yet")
                    .foregroundColor(.secondary)
            } else {
                ForEach(words, id: \.self) { word in
                    Text(word)
                }
            }
        }
    }
}

// MARK: - ViewModel

@MainActor
final class WordScrambleViewModel: ObservableObject {
    @Published var rootWord: String?
    @Published var usedWords: [String] = []
    @Published var score: Int = 0
    @Published var invalidInputError: WordValidationError?
    @Published var isLoading: Bool = false
    @Published var currentGuess: String = ""

    private let startNewGameUseCase: StartNewGameUseCase
    private let submitWordUseCase: SubmitWordUseCase

    init(
        startNewGameUseCase: StartNewGameUseCase = StartNewGameUseCase(repository: LocalWordListRepository()),
        submitWordUseCase: SubmitWordUseCase = SubmitWordUseCase(validator: NativeLanguageWordValidator(language: .english))
    ) {
        self.startNewGameUseCase = startNewGameUseCase
        self.submitWordUseCase = submitWordUseCase
    }

    func startNewGame() async {
        isLoading = true
        defer { isLoading = false }
        do {
            rootWord = try await startNewGameUseCase.execute()
            usedWords = []
            score = 0
            invalidInputError = nil
            currentGuess = ""
        } catch {
            // Handle error fetching root word: fallback to a default word or show alert
            rootWord = "silkworm"
            usedWords = []
            score = 0
            invalidInputError = nil
            currentGuess = ""
        }
    }

    func submitCurrentGuess() async {
        let guess = currentGuess.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !guess.isEmpty else { return }
        guard let rootWord else { return }

        do {
            try submitWordUseCase.execute(word: guess, rootWord: rootWord, usedWords: usedWords)
            usedWords.insert(guess, at: 0)
            score += guess.count
            currentGuess = ""
            invalidInputError = nil
        } catch let error as WordValidationError {
            invalidInputError = error
        } catch {
            invalidInputError = .unknown
        }
    }
}

// MARK: - Feedback Helper

fileprivate func sensoryFeedback(_ type: UINotificationFeedbackGenerator.FeedbackType) {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(type)
}

// MARK: - Errors

enum WordValidationError: LocalizedError, Identifiable {
    var id: String { localizedDescription }

    case empty
    case sameAsRoot
    case alreadyUsed
    case invalid
    case unknown

    var errorDescription: String? {
        switch self {
        case .empty:
            return "The word cannot be empty."
        case .sameAsRoot:
            return "You cannot use the root word itself."
        case .alreadyUsed:
            return "You've already used that word."
        case .invalid:
            return "This is not a valid English word."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
