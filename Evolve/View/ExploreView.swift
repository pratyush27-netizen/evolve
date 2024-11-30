//
//  ExploreView.swift
//  Evolve
//
//  Created by Pratyush Choubey on 30/11/24.
//

import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = ExploreViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $viewModel.searchText)
                    .padding(.top)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.categories, id: \.self) { category in
                            FilterChip(
                                title: category,
                                isSelected: Binding(
                                    get: { viewModel.selectedCategories.contains(category) },
                                    set: { isSelected in
                                        if isSelected {
                                            viewModel.selectedCategories.insert(category)
                                        } else {
                                            viewModel.selectedCategories.remove(category)
                                        }
                                    }
                                )
                            ).padding(.top)
                        }
                    }
                    .padding(.horizontal)
                }
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: 150), spacing: 26)],
                            spacing: 16
                        ) {
                            ForEach(viewModel.filteredJourneys) { journey in
                                JourneyCard(journey: journey)
                                    .onAppear {
                                        viewModel.fetchNextPageIfNeeded(currentItem: journey)
                                    }
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Explore")
            .onAppear {
                viewModel.fetchJourneys()
            }
            .overlay {
                if viewModel.isLoading && viewModel.filteredJourneys.isEmpty {
                    ProgressView("Loading...")
                }
            }
        }
    }
}
