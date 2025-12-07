//
//  NativeLanguageWordValidator.swift
//  WordScramble
//
//  Created by Xavier McNulty on 12/4/25.
//

import Foundation
import SwiftUI

final class NativeLanguageWordValidator: WordValidator {
    var minWordLength: Int
    
    private let textChecker: UITextChecker
    private let language: Language
    
    init(language: Language = .english, minWordLength: Int = 3) {
        self.language = language
        self.minWordLength = minWordLength
        self.textChecker = UITextChecker()
    }
    
    func validate(guess: String, sourceWord: String, previousGuesses: [String]) -> WordValidationResult {
        let guess = guess.lowercased()
        let sourceWord = sourceWord.lowercased()
        
        if let coreValidationResult = coreValidate(guess: guess, sourceWord: sourceWord, previousGuesses: previousGuesses) {
            return coreValidationResult
        }
        
        if !isValidWord(guess) {
            return WordValidationResult(isValid: false, reason: .notAWord)
        } else if !canFormWord(guess: guess, from: sourceWord) {
            return WordValidationResult(isValid: false, reason: .cannotBeFormedFromSource)
        } else {
            return WordValidationResult(isValid: true)
        }
    }
    
    private func isValidWord(_ guess: String) -> Bool {
        let range = NSRange(location: 0, length: guess.utf16.count)
        let mispelledRange = textChecker.rangeOfMisspelledWord(in: guess, range: range, startingAt: 0, wrap: false, language: language.rawValue)
        
        return mispelledRange.location == NSNotFound
    }
    
    private func canFormWord(guess: String, from sourceWord: String) -> Bool {
        var sourceLetters = sourceWord.map { $0 }
        
        for letter in guess {
            guard let index = sourceLetters.firstIndex(of: letter) else {
                return false
            }
            
            sourceLetters.remove(at: index)
        }
        
        return true
    }
    
    enum Language: String {
        case english = "en"
    }
}
