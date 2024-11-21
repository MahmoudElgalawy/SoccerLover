//
//  matchesCell.swift
//  SoccerLover
//
//  Created by Mahmoud  on 20/11/2024.
//

import UIKit
import Kingfisher
class matchesCell: UITableViewCell {
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var nameAway: UILabel!
    @IBOutlet weak var nameHome: UILabel!
    @IBOutlet weak var imgAway: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(match:MatchDetails) {
        score.text = "\(match.score.fullTime.home ?? 1 ) - \(match.score.fullTime.away ?? 1)"
        status.text = match.status
        nameHome.text = match.homeTeam.name ?? "portsMouth"
        nameAway.text = match.awayTeam.name ?? "portsMouth"
        guard let awayUrl = match.awayTeam.crest else{return}
        imgAway.kf.setImage(with: URL(string: awayUrl), placeholder: UIImage(named:"defaultTeam"))
        guard let awayUrl2 = match.homeTeam.crest else{return}
        imgHome.kf.setImage(with: URL(string: awayUrl2), placeholder: UIImage(named:"defaultTeam"))
    }
}
