//
//  FilterChip.swift
//  Evolve
//
//  Created by Pratyush Choubey on 30/11/24.
//

import SwiftUI

struct FilterChip: View {
    let title: String
    @Binding var isSelected: Bool

    var body: some View {
        Button(action: {
            isSelected.toggle()
        }) {
            Text(title)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
                .shadow(radius: 2) // Add shadow for depth
        }
    }
}
