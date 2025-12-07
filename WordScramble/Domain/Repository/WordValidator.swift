//
//  WordValidator.swift
//  WordScramble
//
//  Created by Xavier McNulty on 12/4/25.
//

import Foundation

protocol WordValidator {
    var minWordLength: Int { get }
    
    func validate(guess: String, sourceWord: String, previousGuesses: [String]) -> WordValidationResult
}

extension WordValidator {
    func coreValidate(guess: String, sourceWord: String, previousGuesses: [String]) -> WordValidationResult? {
        if guess == sourceWord {
            return WordValidationResult(isValid: true, reason: .guessSameAsSource)
        }
        
        if guess.count < minWordLength {
            return WordValidationResult(isValid: false, reason: .tooShort(minLength: minWordLength))
        }
        
        if previousGuesses.contains(guess) {
            return WordValidationResult(isValid: false, reason: .alreadyGuessed)
        }
        
        return nil
    }
}
