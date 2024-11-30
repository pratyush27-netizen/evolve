//
//  ExploreModel.swift
//  Evolve
//
//  Created by Pratyush Choubey on 30/11/24.
//
import Foundation

// MARK: - Journey Model
struct Journey: Identifiable, Codable, Equatable {
    var id: String
    var title: String
    var juLabel: String
    var promoText: String
    var description: String
    var juType: String
    var juPremium: String
    var numDays: Int
    var thumbImage: String
    var coverImage: String
    var juLink: String?
    var problems: [String]
    var techniques: [Technique]
    var days: [Day]
    var details: String
    var sessions: String
    var mins: String

    enum CodingKeys: String, CodingKey {
        case id, title, juLabel = "ju_label",
             promoText = "promo_text",
             description, juType = "ju_type",
             juPremium = "ju_premium",
             numDays = "num_days",
             thumbImage = "thumb_image",
             coverImage = "cover_image",
             juLink = "ju_link", problems,
             techniques,
             days,
             details,
             sessions,
             mins
    }
}

// MARK: - Day Model
struct Day: Codable, Equatable {
    var id: Int
    var title: String
    var description: String
    var numSteps: Int
    var dayCompleted: String
    var completedSteps: Int

    enum CodingKeys: String, CodingKey {
        case id, title, description, numSteps = "num_steps", dayCompleted = "day_completed", completedSteps = "completed_steps"
    }
}

// MARK: - Technique Model
struct Technique: Codable, Equatable {
    var name: String
    var description: String?

    enum CodingKeys: String, CodingKey {
        case name, description
    }
}

struct paginatedResponse: Codable {
    let journeys: [Journey]
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case journeys = "data"
        case totalPages = "total_pages"
    }
}

// mockData for test

extension Journey {
    static func mockData() -> [Journey] {
        return [
            Journey(
                id: "1",
                title: "Become more self-aware",
                juLabel: "Self-Care",
                promoText: "Promo 1",
                description: "Learn how to connect with yourself.",
                juType: "Type1",
                juPremium: "Premium",
                numDays: 5,
                thumbImage: "placeholder",
                coverImage: "",
                juLink: nil,
                problems: [],
                techniques: [],
                days: [],
                details: "",
                sessions: "5",
                mins: "5-10"
            ),
            Journey(
                id: "2",
                title: "Create a morning routine",
                juLabel: "Work",
                promoText: "Promo 2",
                description: "Set your day up for success.",
                juType: "Type2",
                juPremium: "Free",
                numDays: 5,
                thumbImage: "placeholder",
                coverImage: "",
                juLink: nil,
                problems: [],
                techniques: [],
                days: [],
                details: "",
                sessions: "5",
                mins: "5-10"
            ),
            Journey(
                id: "3",
                title: "Start loving your body more",
                juLabel: "Self-Care",
                promoText: "Promo 3",
                description: "Practice self-love and acceptance.",
                juType: "Type3",
                juPremium: "Free",
                numDays: 7,
                thumbImage: "placeholder",
                coverImage: "",
                juLink: nil,
                problems: [],
                techniques: [],
                days: [],
                details: "",
                sessions: "7",
                mins: "10-15"
            ),
            Journey(
                id: "4",
                title: "Stop procrastinating",
                juLabel: "Work",
                promoText: "Promo 4",
                description: "Learn how to tackle procrastination.",
                juType: "Type4",
                juPremium: "Premium",
                numDays: 3,
                thumbImage: "placeholder",
                coverImage: "",
                juLink: nil,
                problems: [],
                techniques: [],
                days: [],
                details: "",
                sessions: "3",
                mins: "5-10"
            )
        ]
    }
}
