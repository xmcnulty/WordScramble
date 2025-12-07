//
//  ContentView.swift
//  WordScramble
//
//  Created by Xavier McNulty on 12/4/25.
//

import SwiftUI


struct WordScrambleScreen: View {
    @State private var newWord = ""
    @FocusState private var isTextFieldFocused: Bool
    
    let viewModel: WordScrambleViewModel
    
    init(viewModel: WordScrambleViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Score header with visual prominence
                ScoreHeaderView(
                    score: viewModel.score,
                    wordCount: viewModel.usedWords.count
                )
                
                // Main content
                List {
                    inputSection
                    
                    // Guessed words section
                    if !viewModel.usedWords.isEmpty {
                        GuessedWordsView(words: viewModel.usedWords)
                    }
                }
                .listStyle(.insetGrouped)
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationTitle(viewModel.rootWord ?? "Word Scramble")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        newWord = ""
                        isTextFieldFocused = false
                        Task { await viewModel.startNewGame() }
                    } label: {
                        Label("New Game", systemImage: "arrow.clockwise")
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .controlSize(.large)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.ultraThinMaterial)
                }
            }
            .sensoryFeedback(.success, trigger: viewModel.usedWords.count)
            .sensoryFeedback(.error, trigger: viewModel.invalidInputError)
        }
        .task {
            await viewModel.startNewGame()
        }
    }
    
    // MARK: - Input Section
    
    private var inputSection: some View {
        Section {
            HStack(spacing: 12) {
                Image(systemName: "pencil.circle.fill")
                    .foregroundStyle(.blue)
                    .font(.title2)
                    .symbolEffect(.bounce, value: isTextFieldFocused)
                
                TextField("Enter your word", text: $newWord)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($isTextFieldFocused)
                    .submitLabel(.done)
                    .onSubmit(submitWord)
                
                if !newWord.isEmpty {
                    Button {
                        newWord = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 4)
        } header: {
            Text("Make words from '\(viewModel.rootWord ?? "...")'")
                .textCase(.none)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        } footer: {
            if let error = viewModel.invalidInputError {
                Label(error, systemImage: "exclamationmark.triangle.fill")
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(duration: 0.3), value: viewModel.invalidInputError)
    }
    
    // MARK: - Actions
    
    private func submitWord() {
        guard !newWord.isEmpty else { return }
        
        withAnimation(.spring(duration: 0.3)) {
            viewModel.submitWord(newWord)
        }
        
        if viewModel.invalidInputError == nil {
            newWord = ""
            isTextFieldFocused = true // Keep focus for rapid entry
        }
    }
}

#Preview {
    let repository = LocalWordListRepository()
    let startUseCase = StartNewGameUseCase(wordRepository: repository)
    
    let submitWordUseCase = SubmitWordUseCase(validator: NativeLanguageWordValidator(language: .english))
    
    let viewModel = WordScrambleViewModel(
        startNewGameUseCase: startUseCase,
        submitGuessUseCase: submitWordUseCase
    )
    
    WordScrambleScreen(
        viewModel: viewModel
    )
}

