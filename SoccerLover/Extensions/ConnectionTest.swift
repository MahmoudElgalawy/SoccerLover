//
//  ConnectionTest.swift
//  SoccerLover
//
//  Created by Mahmoud  on 21/11/2024.
//

import Foundation
import Reachability

class ReachabilityManager {
    private let reachability = try! Reachability()
    init() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    var rreachability: Reachability {
        return reachability
    }
}
