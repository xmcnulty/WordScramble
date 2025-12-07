//
//  WordScrambleApp.swift
//  WordScramble
//
//  Created by Xavier McNulty on 12/4/25.
//

import SwiftUI

@main
struct WordScrambleApp: App {
    var body: some Scene {
        WindowGroup {
            WordScrambleScreen(viewModel: makeViewModel())
        }
    }
    
    private func makeViewModel() -> WordScrambleViewModel {
            // Choose your implementations here
            let wordListRepository = LocalWordListRepository()
            let wordValidator = NativeLanguageWordValidator(language: .english)
            
            let startNewGameUseCase = StartNewGameUseCase(
                wordRepository: wordListRepository
            )
            let submitWordUseCase = SubmitWordUseCase(
                validator: wordValidator
            )
            
            return WordScrambleViewModel(startNewGameUseCase: startNewGameUseCase, submitGuessUseCase: submitWordUseCase)
        }
}
