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
    var competitionsDriver: Driver<[Competition]> { get }
    var dataState: ((Bool)-> Void)?{get set}
}

class CompetitionsViewModel: CompetitionsVMProtocol {
    let remote: RemoteService!
    private let competitionsSubject = PublishSubject<[Competition]>()
    var competitionsDriver: Driver<[Competition]> {
           competitionsSubject.asDriver(onErrorJustReturn: [])
       }
    private let disposeBag = DisposeBag()
    var dataState: ((Bool)-> Void)?
    
    init(remote: RemoteService) {
        self.remote = remote
    }
    
    func fetchCompetitions(){
        remote.fetchCompetitions(from: .getAllCompetition, model: CompetitionsModel.self)
            .subscribe(onNext: { [weak self] competition in
                self?.competitionsSubject.onNext(competition.competitions)
                self?.dataState?(true)
            },onError: {[weak self] error in
               self?.competitionsSubject.onNext([])
               self?.dataState?(false)
               print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
