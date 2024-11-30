//
//  SearchBar.swift
//  Evolve
//
//  Created by Pratyush Choubey on 30/11/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            TextField("Search", text: $searchText)
                .padding(10)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
    
        }
        .padding(.horizontal)
    }
}
