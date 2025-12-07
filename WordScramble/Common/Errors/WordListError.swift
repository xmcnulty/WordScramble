//
//  WordListError.swift
//  WordScramble
//
//  Created by Xavier McNulty on 12/4/25.
//

import Foundation

enum WordListError: Error {
    case emptyList
    case fileNotFound
    case invalidFormat
    
}

extension WordListError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .emptyList: return "The word list is empty."
            case .fileNotFound: return "The word list file was not found."
            case .invalidFormat: return "The word list file format is invalid."
        }
    }
}
