//
//  BasicTableViewCell.swift
//  Repositories
//
//  Created by Roland Beke on 14/11/2017.
//  Copyright © 2017 Roland Beke. All rights reserved.
//

import UIKit

class BasicTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var starsImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.nameLabel.text = ""
        self.descriptionLabel.text = ""
        self.starsCountLabel.text = ""
        self.updatedAtLabel.text = ""

        self.avatarImageView.image = nil
        self.starsImageView.image = nil
    }
}
