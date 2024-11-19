//
//  CompetitionsDetails.swift
//  SoccerLover
//
//  Created by Mahmoud  on 19/11/2024.
//

import Foundation


struct CompetitionsDetails: Codable{
    let competition: CompetitionInfo
    let matches: [Match]
}

struct CompetitionInfo: Codable{
    let id: Int
    let name: String
    let area: Area
    let code: String?
    let plan: String?
    let emblem: String?
}

struct Match: Codable {
    let id: Int
    let utcDate: String
    let season: Season
    let status: String
    let Matchday: Int?
    let homeTeam: Team
    let awayTeam: Team
    let score: Score
}

struct Team: Codable {
    let id: Int
    let name: String
    let shortName: String?
    let crest: String?
}

struct Score: Codable{
    let winner: String?
    let fullTime: MatchScore
    let halfTime: MatchScore
    let extraTime: MatchScore?
    let penalties: MatchScore?
}

struct MatchScore: Codable {
    let home: Int?
    let away: Int?
}
