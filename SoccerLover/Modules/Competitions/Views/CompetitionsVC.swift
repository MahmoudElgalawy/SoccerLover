//
//  ViewController.swift
//  SoccerLover
//
//  Created by Mahmoud  on 19/11/2024.
//

import UIKit
import RxSwift
import RxCocoa

class CompetitionsVC: UIViewController,UITableViewDelegate {
    
    @IBOutlet weak var imgNodata: UIImageView!
    @IBOutlet weak var competitionsTable: UITableView!
    
    var viewModel:CompetitionsVMProtocol!
    let disposeBag = DisposeBag()
    var indicator : UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CompetitionsViewModel(remote: NetworkManager.shared)
        competitionsTable.delegate = self
        setIndicator()
        configureTableView()
        drawTable()
        checkData()
    }
}

// Mark:- Draw Table

extension CompetitionsVC{
    func checkData(){
        viewModel.dataState = { [weak self] isSuccess in
                    DispatchQueue.main.async {
                        self?.indicator?.stopAnimating()
                        if isSuccess {
                            self?.imgNodata.isHidden = true
                            self?.competitionsTable.isHidden = false
                        } else {
                            self?.imgNodata.isHidden = false
                            self?.competitionsTable.isHidden = true
                        }
                    }
                }
    }
    func drawTable(){
        viewModel.competitionsDriver.drive(competitionsTable.rx.items(cellIdentifier: "competitionsCell")){row,item,cell in
            (cell as? competitionsCell)?.configureCell(competition: item)
        }.disposed(by: disposeBag)
        fetchData()
    }
    
    func configureTableView() {
        competitionsTable.register(UINib(nibName: String(describing: competitionsCell.self), bundle: nil), forCellReuseIdentifier: String(describing: competitionsCell.self))
    }
    
    func fetchData() {
        viewModel.fetchCompetitions()
        viewModel.competitionsDriver
                 .drive(onNext: { [weak self] competitions in
                    DispatchQueue.main.async {
                        self?.indicator?.stopAnimating()
                        if competitions.isEmpty {
                            self?.imgNodata.isHidden = false
                            self?.competitionsTable.isHidden = true
                        } else {
                            self?.imgNodata.isHidden = true
                            self?.competitionsTable.isHidden = false
                        }
                    }
                })
                .disposed(by: disposeBag)
        subScribeToTable()
    }
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.color = .gray
        indicator?.center = self.competitionsTable.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
    }
}

// Mark:- Table Delegations

extension CompetitionsVC {
    func subScribeToTable() {
        //        competitionsTable.rx.modelSelected(Competition.self).subscribe { item in
        //            let competitionDetails  = self.storyboard?.instantiateViewController(identifier: "DetailsVC") as! DetailsVC
        //
        //            details.detPres = detailsPresenter(view: details)
        //            details.detPres.details = item
        //            self.navigationController?.pushViewController(details, animated: true)
    }//.disposed(by: disposeBag)
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
}

