//
//  CompetitionsDetails.swift
//  SoccerLover
//
//  Created by Mahmoud  on 19/11/2024.
//

import Foundation

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

struct DataResponse: Codable {
    let competition: Competition
    let matches: [MatchDetails]
}
