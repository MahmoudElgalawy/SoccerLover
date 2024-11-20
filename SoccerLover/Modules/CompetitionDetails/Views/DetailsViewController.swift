//
//  DetailsViewController.swift
//  SoccerLover
//
//  Created by Mahmoud  on 19/11/2024.
//

import UIKit
import RxSwift

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var imgNodata: UIImageView!
    @IBOutlet weak var matchesTable: UITableView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var nameCompetition: UILabel!
    @IBOutlet weak var imgCompetition: UIImageView!
    var viewModel:DetailsVMProtocol?
    let disposeBag = DisposeBag()
    var indicator : UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        //viewModel = CompetitionDetailsViewModel(remote: NetworkManager.shared)
        viewModel?.fetchCompetitionDetails()
        matchesTable.delegate = self
        configureTableView()
        drawTable()
        checkData()
        setIndicator()
    }

}

extension DetailsViewController: UITableViewDelegate{
    func checkData(){
        viewModel?.dataState = { [weak self] isSuccess in
                    DispatchQueue.main.async {
                        self?.indicator?.stopAnimating()
                        if isSuccess {
                            self?.imgNodata.isHidden = true
                            self?.matchesTable.isHidden = false
                            self?.imgBack.isHidden = false
                            self?.indicator?.stopAnimating()
                        } else {
                            self?.imgNodata.isHidden = false
                            self?.matchesTable.isHidden = true
                            self?.imgBack.isHidden = true
                            self?.indicator?.stopAnimating()
                        }
                    }
                }
    }
    func drawTable(){
        viewModel?.matchesDriver.drive(matchesTable.rx.items(cellIdentifier: "matchesCell")){row,item,cell in
            (cell as? matchesCell)?.configureCell(match: item)
            self.type.text = "Type: \(item.competition.type)"
            self.nameCompetition.text = "Name: \(item.competition.name)"
            guard let imgUrl = item.competition.emblem else{return}
            self.imgCompetition.kf.setImage(with: URL(string: imgUrl),placeholder: UIImage(named:"trophy1"))
            self.matchesTable.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        }.disposed(by: disposeBag)
        fetchData()
    }
    
    func configureTableView() {
        matchesTable.register(UINib(nibName: String(describing: matchesCell.self), bundle: nil), forCellReuseIdentifier: String(describing: matchesCell.self))
    }
    func fetchData(){
        viewModel?.fetchCompetitionDetails()
        viewModel?.matchesDriver
                 .drive(onNext: { [weak self] Matches in
                    DispatchQueue.main.async {
                        self?.indicator?.stopAnimating()
                        if Matches.isEmpty {
                            self?.imgNodata.isHidden = false
                            self?.matchesTable.isHidden = true
                            self?.imgBack.isHidden = true
                        } else {
                            self?.imgNodata.isHidden = true
                            self?.matchesTable.isHidden = false
                            self?.imgBack.isHidden = false
                        }
                    }
                })
                .disposed(by: disposeBag)
       // subScribeToTable()
    }
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.color = .white
        indicator?.center = self.view.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }

}

