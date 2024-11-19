//
//  CompetitionsModel.swift
//  SoccerLover
//
//  Created by Mahmoud  on 19/11/2024.
//

import Foundation

struct CompetitionsModel: Codable {
    let count: Int
    let competitions: [Competition]
}

struct Competition : Codable {
    let id: Int
    let name: String
    let code: String?
    let area: Area
    let numberOfAvailableSeasons: Int
    let currentSeason:Season?
    let emblem: String?
}

struct Area: Codable{
    let id: Int
    let name: String
    let flag: String?
}

struct Season: Codable {
    let id: Int
    let startDate: String
    let endDate: String
    let currentMatchday: Int?
    let winner: Winner?
}

struct Winner: Codable {
    let id: Int
    let name: String
    let shortName: String
    let tla: String
    let crest: String
    let address: String?
    let website: String?
    let founded: Int?
    let clubColors: String?
    let venue: String?
    let lastUpdated: String?
}
