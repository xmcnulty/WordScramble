//
//  LocalWordListRepository.swift
//  WordScramble
//
//  Created by Xavier McNulty on 12/4/25.
//

import Foundation

final class LocalWordListRepository: WordRepository {
    func getRandomWord() async throws -> String {
        let words = try await getWordList()
        
        if words.isEmpty {
            throw WordListError.emptyList
        }
        
        return words.randomElement() ?? "silkworm"
    }
    
    func getWordList() async throws -> [String] {
        guard let url = Bundle.main.url(forResource: "start", withExtension: "txt") else {
            throw WordListError.fileNotFound
        }
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            return content.components(separatedBy: .newlines).filter { !$0.isEmpty }
        } catch {
            throw WordListError.invalidFormat
        }
    }
}
