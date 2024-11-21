//
//  MatchesViewModel.swift
//  SoccerLover
//
//  Created by Mahmoud  on 20/11/2024.
//

import Foundation
import RxCocoa
import RxSwift

protocol MatchesProtocol{
    func fetchMatches()
    var matchesDriver: Driver<MatchDetails?> { get }
    var dataState: ((Bool)-> Void)?{get set}
    var matchId: Int?{get set}
}
class MatchesViewModel: MatchesProtocol {
    var dataState: ((Bool) -> Void)?
    let remote: RemoteService!
    private let matcchesSubject = PublishSubject<MatchDetails?>()
    var matchesDriver: Driver<MatchDetails?> {
        return matcchesSubject
            .asDriver(onErrorJustReturn: nil)
    }
    private let disposeBag = DisposeBag()
    var matchId: Int?
    
    init(remote: RemoteService) {
        self.remote = remote
    }
    
    func fetchMatches() {
        remote.fetchCompetitions(from: .getMatchDetails(matchId: matchId ?? 2002), model: MatchDetails.self)
            .subscribe(onNext: { [weak self] matchesResponse in
                self?.matcchesSubject.onNext(matchesResponse)
                self?.dataState?(true)
                // print(matchesResponse)
            }, onError: { [weak self] error in
                self?.dataState?(false)
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
