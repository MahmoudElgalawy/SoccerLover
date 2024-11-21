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
    var back:UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CompetitionsViewModel(remote: NetworkManager.shared)
        competitionsTable.delegate = self
        setIndicator()
        configureTableView()
        drawTable()
        checkData()
        subScribeToTable()
        back = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward"), style: .plain, target: self, action: #selector(backButton))
        checkNetworkConnection()
    }
}

// Mark:- Draw Table

extension CompetitionsVC{
    func checkNetworkConnection() {
        viewModel.checkNetworkReachability { [weak self] isReachable in
            if isReachable {
                self?.fetchData()
            } else {
                self?.showNoInternetAlert()
            }
        }
        viewModel.reachabilityHandler.rreachability.whenReachable = { [weak self] _ in
            self?.fetchData()
        }
        viewModel.reachabilityHandler.rreachability.whenUnreachable = { [weak self] _ in
            self?.showNoInternetAlert()
            self?.fetchLocalCompetitions()
        }
    }
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
    }
    func fetchLocalCompetitions() {
        viewModel.fetchLocalCompetitions()
    }
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.color = .gray
        indicator?.center = self.competitionsTable.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
    }
    func showNoInternetAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "No Internet Connection", message: "You are offline. Please check your connection.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in                   self?.fetchLocalCompetitions()
                self?.indicator?.stopAnimating()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// Mark:- Table Delegations

extension CompetitionsVC {
    func subScribeToTable() {
        competitionsTable.rx.modelSelected(Competition.self).subscribe(onNext: { [weak self] competition in
            if self?.viewModel.isDataLoaded == true {
                let competitionDetails = self?.storyboard?.instantiateViewController(identifier: "DetailsViewController") as! DetailsViewController
                competitionDetails.navigationItem.title = "SoccerLover"
                competitionDetails.navigationController?.navigationBar.backgroundColor = UIColor(named: "Color1")
                competitionDetails.navigationItem.leftBarButtonItem = self?.back
                competitionDetails.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
                competitionDetails.viewModel?.competitionId = competition.id
                competitionDetails.viewModel = CompetitionDetailsViewModel(remote: NetworkManager.shared)
                competitionDetails.viewModel?.competitionId = competition.id
                self?.navigationController?.pushViewController(competitionDetails, animated: true)
            }
        })
        .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.layer.shadowRadius = 1
        cell.layer.shadowOpacity = 0.1
    }
    @objc func backButton() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.popViewController(animated: true)
    }
    
}

