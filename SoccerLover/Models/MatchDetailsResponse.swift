//
//  MatchDetailsResponse.swift
//  SoccerLover
//
//  Created by Mahmoud  on 19/11/2024.
//

import Foundation

struct MatchDetailsResponse: Codable{
    let match: MatchDetails
}

struct MatchDetails: Codable {
    let id: Int
    let utcDate: String
    let status: String
    let matchday: Int?
    let venue: String
    let homeTeam: Team
    let awayTeam: Team
    let score: Score
    let referees: [Referee]
}

struct Referee: Codable{
    let id: Int
    let name: String
    let nationality: String?
}
