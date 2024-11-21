//
//  LocalCompetetionManger.swift
//  SoccerLover
//
//  Created by Mahmoud  on 21/11/2024.
//

import Foundation
import CoreData
import UIKit

protocol LocalService {
    func storeCompetition(competition: [Competition])
    func fetchCompetitions() -> [Competition]
    func deleteAllData()
}

class CompetitionStorage: LocalService {
    
    static let shared = CompetitionStorage()
    private init() {}
    
    private var managedContext: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not retrieve app delegate")
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    func storeCompetition(competition: [Competition]) {
        for competition in competition {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CompetitionEntity")
            fetchRequest.predicate = NSPredicate(format: "num == %d", competition.id)
            
            do {
                let results = try managedContext.fetch(fetchRequest)
                if results.isEmpty {
                    guard let competitionEntity = NSEntityDescription.entity(forEntityName: "CompetitionEntity", in: managedContext) else { return }
                    let competitionObject = NSManagedObject(entity: competitionEntity, insertInto: managedContext)
                    
                    competitionObject.setValue(competition.id, forKey: "num")
                    competitionObject.setValue(competition.name, forKey: "name")
                    competitionObject.setValue(competition.numberOfAvailableSeasons, forKey: "numberOfAvailableSeasons")
                    competitionObject.setValue(competition.type, forKey: "type")
                    competitionObject.setValue(competition.emblem, forKey: "emblem")
                    
                    if let currentSeason = competition.currentSeason {
                        competitionObject.setValue(currentSeason.id, forKey: "seasonid")
                        competitionObject.setValue(currentSeason.startDate, forKey: "startDate")
                        competitionObject.setValue(currentSeason.endDate, forKey: "endDate")
                        competitionObject.setValue(currentSeason.currentMatchday, forKey: "currentMatchday")
                    }
                    
                    try managedContext.save()
                    print("Competition with ID \(competition.id) saved successfully!")
                } else {
                    print("Competition with ID \(competition.id) already exists. Skipping...")
                }
            } catch {
                print("Error checking or saving competition with ID \(competition.id): \(error)")
            }
        }
    }
    
    
    func fetchCompetitions() -> [Competition] {
        var competitions = [Competition]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CompetitionEntity")
        
        do {
            let results = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for competitionObject in results {
                let id = competitionObject.value(forKey: "num") as! Int
                let name = competitionObject.value(forKey: "name") as! String
                let code = competitionObject.value(forKey: "code") as? String
                let numberOfAvailableSeasons = competitionObject.value(forKey: "numberOfAvailableSeasons") as! Int
                let type = competitionObject.value(forKey: "type") as! String
                let emblem = competitionObject.value(forKey: "emblem") as? String
                
                let seasonId = competitionObject.value(forKey: "seasonid") as? Int
                let startDate = competitionObject.value(forKey: "startDate") as? String
                let endDate = competitionObject.value(forKey: "endDate") as? String
                let currentMatchday = competitionObject.value(forKey: "currentMatchday") as? Int
                
                let currentSeason = (seasonId != nil && startDate != nil && endDate != nil) ?
                SeasonModel(id: seasonId!, startDate: startDate!, endDate: endDate!, currentMatchday: currentMatchday) : nil
                
                let competition = Competition(
                    id: id,
                    name: name,
                    code: code,
                    numberOfAvailableSeasons: numberOfAvailableSeasons,
                    type: type,
                    currentSeason: currentSeason,
                    emblem: emblem
                )
                
                competitions.append(competition)
            }
        } catch {
            print("Error fetching competitions: \(error)")
        }
        
        return competitions
    }
    
    func deleteAllData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CompetitionEntity")
        
        do {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            print("All data deleted successfully!")
        } catch {
            print("Failed to delete all data: \(error)")
        }
    }
}
