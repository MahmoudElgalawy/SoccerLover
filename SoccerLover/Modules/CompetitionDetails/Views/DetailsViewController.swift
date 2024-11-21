//
//  DetailsViewController.swift
//  SoccerLover
//
//  Created by Mahmoud  on 19/11/2024.
//

import UIKit
import RxSwift
import CoreImage

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
    var back:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchesTable.delegate = self
        configureTableView()
        drawTable()
        checkData()
        setIndicator()
        back = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward"), style: .plain, target: self, action: #selector(backButton))
        if let originalImage = UIImage(named: "photo1") {
            let blurredImage = applyBlurEffect(to: originalImage, blurRadius: 10)
            imgBack.image = blurredImage
        }
        
    }
    
}

// Mark:- Draw Table

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
        subScribeToTable()
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
    func applyBlurEffect(to image: UIImage, blurRadius: Double) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(blurRadius, forKey: kCIInputRadiusKey)
        guard let outputImage = filter?.outputImage else { return nil }
        let context = CIContext()
        if let cgImage = context.createCGImage(outputImage, from: ciImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
    
}

// Mark:- Table Delegations

extension DetailsViewController{
    func subScribeToTable() {
        matchesTable.rx.modelSelected(MatchDetails.self).subscribe(onNext: { [weak self] match in
            let MatchesVC  = self?.storyboard?.instantiateViewController(identifier: "MatchesViewController") as! MatchesViewController
            MatchesVC.navigationItem.title = "SoccerLover"
            MatchesVC.navigationController?.navigationBar.backgroundColor = UIColor(named: "Color1")
            MatchesVC.navigationItem.leftBarButtonItem = self?.back
            MatchesVC.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            
            MatchesVC.viewModel = MatchesViewModel(remote: NetworkManager.shared)
            guard let id = match.id else{return}
            MatchesVC.viewModel?.matchId = id
            self?.navigationController?.pushViewController(MatchesVC, animated: true)
        })
        .disposed(by: disposeBag)
    }
    @objc func backButton() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.popViewController(animated: true)
    }
}

