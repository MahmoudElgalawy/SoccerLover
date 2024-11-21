//
//  MatchesViewController.swift
//  SoccerLover
//
//  Created by Mahmoud  on 20/11/2024.
//

import UIKit
import RxSwift

class MatchesViewController: UIViewController {
    
    @IBOutlet weak var vs: UIImageView!
    @IBOutlet weak var titleAway: UILabel!
    @IBOutlet weak var titleHome: UILabel!
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var nationality: UILabel!
    @IBOutlet weak var referees: UILabel!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var competitionImg: UIImageView!
    @IBOutlet weak var season: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var nameCompetition: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var imgAway: UIImageView!
    @IBOutlet weak var nameHome: UILabel!
    @IBOutlet weak var nameAway: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var history: UILabel!
    let noDataImage = UIImageView()
    var indicator : UIActivityIndicatorView?
    var viewModel:MatchesProtocol?
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setIndicator()
        fetchData()
        if let originalImage = UIImage(named: "photo5") {
            let blurredImage = applyBlurEffect(to: originalImage, blurRadius: 10)
            backImg.image = blurredImage
        }
        setupImageView()
    }
    
   
}

// Mark:- Data Setup 

extension MatchesViewController{
    func fetchData(){
        viewModel?.fetchMatches()
        binData()
        checkData()
    }
    
    func binData(){
        viewModel?.matchesDriver
                 .drive(onNext: { [weak self] match in
                     DispatchQueue.main.async {
                         self?.indicator?.stopAnimating()
                         if match == nil {
                             self?.view(bool:false)
                         }else {
                             self?.view(bool:true)
                             self?.score.text = "\(match?.score.fullTime.home ?? 1 ) - \(match?.score.fullTime.away ?? 1)"
                             self?.nameHome.text = match?.homeTeam.name ?? "portsMouth"
                             self?.nameAway.text = match?.awayTeam.name ?? "portsMouth"
                             guard let awayUrl = match?.awayTeam.crest else{return}
                             self?.imgAway.kf.setImage(with: URL(string: awayUrl), placeholder: UIImage(named:"defaultTeam"))
                             guard let awayUrl2 = match?.homeTeam.crest else{return}
                             self?.imgHome.kf.setImage(with: URL(string: awayUrl2), placeholder: UIImage(named:"defaultTeam"))
                             self?.status.text = match?.status
                             let result = self?.extractDateAndTime(from: match?.utcDate ?? "")
                             if let date = result?.date, let time = result?.time {
                                 self?.time.text = time
                                 self?.history.text = date
                             }
                             self?.nameCompetition.text = match?.competition.name
                             guard let type = match?.competition.type else{return}
                             self?.type.text = "Type: \(type)"
                             self?.season.text = "\(match?.season.startDate ?? "2024-08-16") / \(match?.season.endDate ?? "2025-05-25")"
                             guard let competitionUrl = match?.competition.emblem else{return}
                             self?.competitionImg.kf.setImage(with: URL(string: competitionUrl), placeholder: UIImage(named:"trophy1"))
                             guard let arrea = match?.area.name else{return}
                             self?.area.text = "Area: \(arrea)"
                             guard let flagUrl = match?.area.flag else{
                                 return (self?.flag.image = UIImage(named: "Fifa"))!}
                             self?.flag.kf.setImage(with: URL(string: flagUrl),placeholder: UIImage(named: "Fifa"))
                             guard let referee = match?.referees.first?.name else{return}
                             self?.referees.text = "referee: \(referee)"
                             guard let nation = match?.referees.first?.nationality else{return}
                             self?.nationality.text = "Nationality: \(nation)"
                         }
                     }
                })
                .disposed(by: disposeBag)
    }
    
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.color = .white
        indicator?.center = self.view.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
    }
    
    func extractDateAndTime(from isoDate: String) -> (date: String?, time: String?) {
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        isoFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = isoFormatter.date(from: isoDate) else { return (nil, nil) }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let formattedTime = timeFormatter.string(from: date)
        return (formattedDate, formattedTime)
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
    
    func view(bool:Bool){
        noDataImage.isHidden = bool
        backImg.isHidden = !bool
        nationality.isHidden = !bool
        referees.isHidden = !bool
        flag.isHidden = !bool
        area.isHidden = !bool
        competitionImg.isHidden = !bool
        season.isHidden = !bool
        type.isHidden = !bool
        nameCompetition.isHidden = !bool
        time.isHidden = !bool
        score.isHidden = !bool
        imgHome.isHidden = !bool
        imgAway.isHidden = !bool
        nameHome.isHidden = !bool
        nameAway.isHidden = !bool
        status.isHidden = !bool
        history.isHidden = !bool
        titleHome.isHidden = !bool
        titleAway.isHidden = !bool
        vs.isHidden = !bool
    }
    func setupImageView() {
        noDataImage.image = UIImage(named: "nodata")
        noDataImage.contentMode = .scaleAspectFill
            view.addSubview(noDataImage)
        noDataImage.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                noDataImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                noDataImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                noDataImage.widthAnchor.constraint(equalToConstant: 200),
                noDataImage.heightAnchor.constraint(equalToConstant: 200)
            ])
        }
    func checkData(){
        viewModel?.dataState = { [weak self] isSuccess in
                    DispatchQueue.main.async {
                        self?.indicator?.stopAnimating()
                        if isSuccess {
                            self?.view(bool:true)
                        } else {
                            self?.view(bool:false)
                        }
                    }
                }
    }
}
