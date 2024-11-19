//
//  ViewController.swift
//  SoccerLover
//
//  Created by Mahmoud  on 19/11/2024.
//

import UIKit

class CompetitionsVC: UIViewController {
    var viewModel:CompetitionsVMProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CompetitionsViewModel(remote: NetworkManager.shared)
        viewModel.fetchCompetitions()
    }


}

