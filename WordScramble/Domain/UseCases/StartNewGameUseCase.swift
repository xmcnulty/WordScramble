//
//  StartNewGameUseCase.swift
//  WordScramble
//
//  Created by Xavier McNulty on 12/4/25.
//

import Foundation

final class StartNewGameUseCase {
    private let wordRepository: WordRepository
    
    init(wordRepository: WordRepository) {
        self.wordRepository = wordRepository
    }
    
    func execute() async throws -> GameState {
        let sourceWord = try await wordRepository.getRandomWord()
        
        return GameState(sourceWord: sourceWord, guessedWords: [], score: 0)
    }
}
