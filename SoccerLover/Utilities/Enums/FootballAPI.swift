//
//  FootballAPI.swift
//  SoccerLover
//
//  Created by Mahmoud  on 19/11/2024.
//

import Foundation

enum FootballAPI{
    case getAllCompetition
    case getCompetitionsDetails(competitionId: Int)
    case getMatchDetails(matchId: Int)
    
    private var baseURL: String {
        return "https://api.football-data.org"
    }
    func url() -> URL? {
        let urlString: String
        switch self {
        case .getAllCompetition :
            urlString = "\(baseURL)/v4/competitions"
        case .getCompetitionsDetails(let competitionId):
            let competitionIdString = String(competitionId)
            urlString = "\(baseURL)/v4/competitions/\(competitionIdString)/matches"
        case .getMatchDetails(let matchId) :
            let matchIdString = String(matchId)
            urlString = "\(baseURL)/v4/matches/\(matchIdString)"
        }
        return URL(string: urlString)
    }
}


