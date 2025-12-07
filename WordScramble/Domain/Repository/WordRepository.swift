//
//  WordListRepository.swift
//  WordScramble
//
//  Created by Xavier McNulty on 12/4/25.
//

import Foundation

protocol WordRepository {
    func getRandomWord() async throws -> String
    func getWordList() async throws -> [String]
}
