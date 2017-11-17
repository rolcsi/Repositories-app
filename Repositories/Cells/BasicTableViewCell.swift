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

        self.starsImageView.image = nil

        self.model.producer
            .startWithValues { [unowned self] (model) in

                if let repo = model as? Repo {

                    self.setCell(model: repo)
                } else if let user = model as? User {

                    self.setCell(model: user)
                }
            }
    }

    // MARK: Private methods

    private func setCell(model: User) {

        self.nameLabel.text = model.login
        self.descriptionLabel.text = model.repos
        self.avatarImageView.image = #imageLiteral(resourceName: "no_image")
        self.starsImageView.image = nil
        self.avatarImageView.downloadImage(from: model.avatar)
    }

    private func setCell(model: Repo) {

        self.nameLabel.text = model.login
        self.descriptionLabel.text = model.description
        self.starsCountLabel.text = model.starsCount
        self.updatedAtLabel.text = model.updatedAt

        self.starsImageView.image = #imageLiteral(resourceName: "star_icon")
        self.avatarImageView.image = #imageLiteral(resourceName: "no_image")
        self.avatarImageView.downloadImage(from: model.avatar)
    }
}
