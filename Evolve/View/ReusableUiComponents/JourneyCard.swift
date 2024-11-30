//
//  JourneyCard.swift
//  Evolve
//
//  Created by Pratyush Choubey on 30/11/24.
//

import SwiftUI

struct JourneyCard: View {
    let journey: Journey

    var body: some View {
        VStack(alignment: .leading) {
            if let url = URL(string: journey.thumbImage) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 120)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 120)
                            .cornerRadius(10)
                            .clipped()
                    case .failure:
                        Image(systemName: "exclamationmark.triangle")
                            .frame(height: 120)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(10)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Color.gray
                    .frame(height: 120)
                    .cornerRadius(10)
                    .overlay(Text("No Image").foregroundColor(.white))
            }
            Text(journey.title)
                .font(.headline)
                .padding(.top, 8)
                .lineLimit(2)
            Text("\(journey.sessions) sessions • \(journey.mins) mins")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(7)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .frame(height: 250)
    }
}
