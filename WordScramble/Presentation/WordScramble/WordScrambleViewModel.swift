//
//  WordScrambleViewModel.swift
//  WordScramble
//
//  Created by Xavier McNulty on 12/4/25.
//

import Foundation

@MainActor
@Observable
final class WordScrambleViewModel {
    private var gameState: GameState?
    private(set) var invalidInputError: String? = nil
    private(set) var isLoading: Bool = false
    
    private let startNewGameUseCase: StartNewGameUseCase
    private let submitWordUseCase: SubmitWordUseCase
    
    var rootWord: String? {
        gameState?.sourceWord
    }
    
    var usedWords: [String] {
        gameState?.guessedWords ?? []
    }
    
    var score: Int {
        gameState?.score ?? 0
    }
    
    init(
        startNewGameUseCase: StartNewGameUseCase,
        submitGuessUseCase: SubmitWordUseCase
    ) {
        self.startNewGameUseCase = startNewGameUseCase
        self.submitWordUseCase = submitGuessUseCase
    }
    
    func startNewGame() async {
        do {
            isLoading = true
            gameState = try await startNewGameUseCase.execute()
            invalidInputError = nil
            isLoading = false
        } catch {
            if gameState == nil {
                fatalError("Could not load word list.")
            }
        }
    }
    
    func submitWord(_ word: String) {
        guard let gameState = gameState else { return }
        
        let (result, newGameState) = submitWordUseCase.execute(
            guess: word,
            gameState: gameState
        )
        
        if result.isValid, let newState = newGameState {
            self.gameState = newState
            invalidInputError = nil
        } else {
            invalidInputError = result.reason?.description ?? "Unknown Error"
        }
    }
}
