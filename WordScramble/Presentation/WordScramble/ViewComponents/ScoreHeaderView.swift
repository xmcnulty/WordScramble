//
//  ScoreHeaderView.swift
//  WordScramble
//
//  Created by Xavier McNulty on 12/5/25.
//

import SwiftUI

struct ScoreHeaderView: View {
    
    let score: Int
    let wordCount: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Score")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("\(score)")
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .contentTransition(.numericText())
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Words Found")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("\(wordCount)")
                    .font(.system(.title2, design: .rounded, weight: .semibold))
                    .contentTransition(.numericText())
            }
        }
        .padding()
        .background(.ultraThinMaterial)
    }
}
