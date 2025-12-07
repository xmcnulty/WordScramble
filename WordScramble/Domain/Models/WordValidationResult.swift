//
//  WordValidationResult.swift
//  WordScramble
//
//  Created by Xavier McNulty on 12/4/25.
//

import Foundation

struct WordValidationResult {
    let isValid: Bool
    let reason: InvalidReason?
    
    init(isValid: Bool, reason: InvalidReason? = nil) {
        self.isValid = isValid
        self.reason = reason
    }
    
    enum InvalidReason {
          case tooShort(minLength: Int)
          case alreadyGuessed
          case notAWord
          case cannotBeFormedFromSource
          case guessSameAsSource

          var description: String {
              switch self {
              case .tooShort(let min): return "Your guess is too short. Use at least \(min) letters."
              case .alreadyGuessed: return "You already used that word."
              case .notAWord: return "That doesn’t appear to be a real word."
              case .cannotBeFormedFromSource: return "You can’t form that from the source word."
              case .guessSameAsSource: return "You can’t use the source word itself."
              }
          }
      }
}
