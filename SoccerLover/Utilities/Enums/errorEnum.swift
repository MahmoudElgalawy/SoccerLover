//
//  errorEnum.swift
//  SoccerLover
//
//  Created by Mahmoud  on 19/11/2024.


import Foundation

enum SoccerError : Error,CustomNSError{
    case apiError
    case invalidResponse
    case invalidEndPoint
    case noData
    case serializationError
    
    var localizedDescription:String{
        switch self{
        case .apiError:
            return "Failed to fetch data"
        case .invalidResponse:
            return "Invalid response"
        case .invalidEndPoint:
            return "Invalid endPoint"
        case .noData:
            return "No data"
        case .serializationError:
            return "Failed to decode data"
        }
    }
    
    var errorUserInfo :[String : Any] {
        [NSLocalizedDescriptionKey:localizedDescription]
    }
}

