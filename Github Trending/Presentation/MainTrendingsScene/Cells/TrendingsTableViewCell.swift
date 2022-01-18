//
//  TrendingsTableViewCell.swift
//  Github Trending
//
//  Created by Fatma Mohamed on 17/01/2022.
//

import UIKit
import Kingfisher

class TrendingsTableViewCell: UITableViewCell {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var repoDescription: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var stars: UILabel!
    @IBOutlet weak var forks: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userName.showAnimatedSkeleton()
        cellImage.showAnimatedSkeleton()
        repoName.showAnimatedSkeleton()
        // Initialization code
    }

    
    func hideAnimation() {
        userName.hideSkeleton()
        cellImage.hideSkeleton()
        repoName.hideSkeleton()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(trending: Repository) {
        self.userName.text = trending.username
        self.repoName.text = trending.repositoryName
        self.languageLabel.text = trending.language
        self.stars.text = String(trending.totalStars)
        self.forks.text = String(trending.forks)
        self.repoDescription.text = trending.welcomeDescription
        let imageURL = URL(string: trending.builtBy[0].avatar)
        self.cellImage.kf.setImage(with: imageURL)
    }
    
}
