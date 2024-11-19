//
//  competitionsCell.swift
//  SoccerLover
//
//  Created by Mahmoud  on 19/11/2024.
//

import UIKit
import Kingfisher

class competitionsCell: UITableViewCell {

    @IBOutlet weak var imgCompetitions: UIImageView!
    
    @IBOutlet weak var currentMatchs: UILabel!
    @IBOutlet weak var availableSeasons: UILabel!
    @IBOutlet weak var nameCompetition: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(competition: Competition){
        guard let dayMatches = competition.currentSeason?.currentMatchday else{return}
        currentMatchs.text = "Day Matches: \(dayMatches)"
        nameCompetition.text = competition.name
        availableSeasons.text = "Available Seasons: \(competition.numberOfAvailableSeasons)"
        guard let imgUrl = competition.emblem else{return}
        imgCompetitions.kf.setImage(with: URL(string: imgUrl), placeholder: UIImage(named:"trophy1"))
    }
    
}
