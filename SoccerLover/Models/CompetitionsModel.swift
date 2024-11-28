//
//  CompetitionsModel.swift
//  SoccerLover
//
//  Created by Mahmoud  on 19/11/2024.
//

import Foundation

struct CompetitionsModel: Codable {
    let competitions: [Competition]
}

struct Competition: Codable {
    let id: Int
    let name: String
    let code: String?
    let numberOfAvailableSeasons: Int?
    let type: String
    let currentSeason:SeasonModel?
    let emblem: String?
}
struct SeasonModel: Codable {
    let id: Int
    let startDate: String
    let endDate: String
    let currentMatchday: Int?
}



