//
//  BasicTableViewCell.swift
//  Repositories
//
//  Created by Roland Beke on 14/11/2017.
//  Copyright © 2017 Roland Beke. All rights reserved.
//

import UIKit
import ReactiveSwift

class BasicTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var starsImageView: UIImageView!
    
    var model: MutableProperty<Any> = MutableProperty(Repo())
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.starsCountLabel.text = ""
        self.starsImageView.image = nil
        
        self.model.producer
            .startWithValues{ (model) in
            
                if let user = model as? User {
                 
                    self.nameLabel.text = user.login
                    self.descriptionLabel.text = user.repos
                    self.avatarImageView.image = #imageLiteral(resourceName: "no_image")
                    self.avatarImageView.downloadImage(from: user.avatar)
                } else if let repo = model as? Repo {
                    
                    self.nameLabel.text = repo.login
                    self.descriptionLabel.text = repo.description
                    self.starsCountLabel.text = repo.starsCount
                    self.updatedAtLabel.text = repo.updatedAt
                    
                    self.starsImageView.image = #imageLiteral(resourceName: "star_icon")
                    self.avatarImageView.image = #imageLiteral(resourceName: "no_image")
                    self.avatarImageView.downloadImage(from: repo.avatar)
                }
            }
    }
}
