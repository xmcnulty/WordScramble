//
//  SubmitWordUseCase.swift
//  WordScramble
//
//  Created by Xavier McNulty on 12/4/25.
//

import Foundation

final class SubmitWordUseCase {
    private let validator: WordValidator
    
    init(validator: WordValidator) {
        self.validator = validator
    }
    
    func execute(guess: String, gameState: GameState) -> (result: WordValidationResult, newGameState: GameState?) {
        let result = validator.validate(guess: guess, sourceWord: gameState.sourceWord, previousGuesses: gameState.guessedWords)
        
        guard result.isValid else {
            return (result, nil)
        }
        
        let updatedState = GameState(sourceWord: gameState.sourceWord, guessedWords: [guess] + gameState.guessedWords, score: gameState.score + guess.count)
        
        
        return (result, updatedState)
    }
}
