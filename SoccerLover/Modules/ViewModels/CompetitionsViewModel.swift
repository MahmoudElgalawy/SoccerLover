//
//  CompetitionsViewModel.swift
//  SoccerLover
//
//  Created by Mahmoud  on 19/11/2024.
//

import Foundation
import RxSwift

protocol CompetitionsVMProtocol{
    func fetchCompetitions()
}

class CompetitionsViewModel: CompetitionsVMProtocol {
    let remote: RemoteService!
    private let disposeBag = DisposeBag()
    init(remote: RemoteService) {
        self.remote = remote
    }
    func fetchCompetitions(){
        remote.fetchCompetitions(from: .getAllCompetition, model: CompetitionsModel.self)
            .subscribe(onNext: { competitions in
                print(competitions)
            },onError: {error in
            print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
