//
//  GuessedWordsView.swift
//  WordScramble
//
//  Created by Xavier McNulty on 12/6/25.
//

import SwiftUI

struct GuessedWordsView: View {
    
    private var guessedWords: [String]
    
    init(words: [String]) {
        self.guessedWords = words
    }
    
    var body: some View {
        Section {
            ForEach(guessedWords, id: \.self) { word in
                HStack(spacing: 12) {
                    // Letter count badge
                    ZStack {
                        Circle()
                            .fill(.blue.gradient)
                            .frame(width: 32, height: 32)
                        
                        Text("\(word.count)")
                            .font(.system(.caption, design: .rounded, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    
                    Text(word)
                        .font(.body)
                    
                    Spacer()
                    
                    // Points earned
                    Text("+\(word.count)")
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.quaternary, in: Capsule())
                }
                .padding(.vertical, 4)
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .opacity
                ))
            }
        } header: {
            HStack {
                Text("Your Words")
                    .textCase(.none)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
        }
    }
}

#Preview {
    GuessedWordsView(words: ["Test1", "Test2"])
}
