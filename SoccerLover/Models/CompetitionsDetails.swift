//
//  CompetitionsDetails.swift
//  SoccerLover
//
//  Created by Mahmoud  on 19/11/2024.
//

import Foundation


struct Competition2: Codable {
    let id: Int?
    let name: String
    let type: String
    let emblem: String?
}

struct Team: Codable {
    let id: Int?
    let name: String?
    let crest: String?
}

struct Score: Codable {
    let fullTime: ScoreDetails
    let halfTime: ScoreDetails
}

struct ScoreDetails: Codable {
    let home: Int?
    let away: Int?
}

struct Match: Codable {
    let competition: Competition2
    let id: Int
    let status: String?
    let attendance: Int?
    let homeTeam: Team
    let awayTeam: Team
    let score: Score
}

struct DataResponse: Codable {
    let competition: Competition2
    let matches: [Match]
}
