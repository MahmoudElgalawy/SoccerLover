//
//  CompetitionsViewModel.swift
//  SoccerLover
//
//  Created by Mahmoud  on 19/11/2024.
//

import Foundation
import RxSwift
import RxCocoa

protocol CompetitionsVMProtocol{
    func fetchCompetitions()
    func fetchLocalCompetitions()
    func checkNetworkReachability(completion: @escaping (Bool) -> Void)
    var competitionsDriver: Driver<[Competition]> { get }
    var dataState: ((Bool)-> Void)?{get set}
    var local:LocalService!{get}
    var reachabilityHandler: ReachabilityManager { get }
    var isDataLoaded: Bool{get set}
    
}

class CompetitionsViewModel: CompetitionsVMProtocol {
    let remote: RemoteService!
    private let competitionsSubject = PublishSubject<[Competition]>()
    var competitionsDriver: Driver<[Competition]> {
        competitionsSubject.asDriver(onErrorJustReturn: [])
    }
    private let disposeBag = DisposeBag()
    var dataState: ((Bool)-> Void)?
    var local:LocalService!
    var reachabilityHandler = ReachabilityManager()
    var isDataLoaded = false
    init(remote: RemoteService) {
        self.remote = remote
        self.local = CompetitionStorage.shared
    }
    
    func fetchCompetitions(){
        remote.fetchCompetitions(from: .getAllCompetition, model: CompetitionsModel.self)
            .subscribe(onNext: { [weak self] competition in
                self?.isDataLoaded = true
                self?.competitionsSubject.onNext(competition.competitions)
                self?.local.storeCompetition(competition: competition.competitions)
                self?.dataState?(true)
            },onError: {[weak self] error in
                self?.isDataLoaded = false
                self?.competitionsSubject.onNext([])
                self?.dataState?(false)
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    func fetchLocalCompetitions(){
        competitionsSubject.onNext(local.fetchCompetitions())
    }
    
    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        reachabilityHandler.rreachability.whenReachable = { reachability in
            completion(true)
        }
        reachabilityHandler.rreachability.whenUnreachable = { reachability in
            completion(false)
        }
    }
}
