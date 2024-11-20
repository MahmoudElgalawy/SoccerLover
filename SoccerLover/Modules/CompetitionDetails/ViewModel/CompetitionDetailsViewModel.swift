//
//  CompetitionDetailsViewModel.swift
//  SoccerLover
//
//  Created by Mahmoud  on 19/11/2024.
//

import Foundation
import RxCocoa
import RxSwift

protocol DetailsVMProtocol{
    func fetchCompetitionDetails()
    var matchesDriver: Driver<[Match]> { get }
    var dataState: ((Bool)-> Void)?{get set}
    var competitionId: Int?{get set}
    var competition:Competition2?{get set}
}
class CompetitionDetailsViewModel: DetailsVMProtocol {
    var dataState: ((Bool) -> Void)?
    let remote: RemoteService!
    var competition:Competition2?
    private let competitionsSubject = PublishSubject<[Match]>()
    var matchesDriver: Driver<[Match]> {
        return competitionsSubject
                    .asDriver(onErrorJustReturn: [])
    }

    private let disposeBag = DisposeBag()
    var competitionId: Int?
    
    init(remote: RemoteService) {
        self.remote = remote
    }
    
    func fetchCompetitionDetails() {
        remote.fetchCompetitions(from: .getCompetitionsDetails(competitionId: competitionId ?? 2002), model: DataResponse.self)
            .subscribe(onNext: { [weak self] matchesResponse in
                self?.competitionsSubject.onNext(matchesResponse.matches )
                self?.dataState?(true)
            }, onError: { [weak self] error in
                self?.dataState?(false)
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
