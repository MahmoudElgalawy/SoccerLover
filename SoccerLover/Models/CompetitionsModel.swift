//
//  CompetitionsModel.swift
//  SoccerLover
//
//  Created by Mahmoud  on 19/11/2024.
//

import Foundation



struct CompetitionsModel : Codable {
    
    let id: Int
    let name: String
    let code: String?
    let area: Area
    let numberOfAvailableSeasons: Int
    let currentSeason:Season?
}

struct Area: Codable{
    let id: Int
    let name: String
    let ensignUrl: String?
}

struct Season: Codable {
    let id: Int
    let startDate: String
    let endDate: String
    let currentMatchday: Int?
}
