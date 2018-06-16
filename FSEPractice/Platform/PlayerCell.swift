//
//  PlayerCell.swift
//  FSEPractice
//
//  Created by Duminica Octavian on 16/06/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import UIKit

class PlayerCell: UITableViewCell {

    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(user: User) {
        playerNameLabel.text = user.username
        if let pictureUrl = user.pictureUrl {
            playerImageView.loadImageUsingCache(withUrlString: pictureUrl)
        }
    }
    
    static func reuseId() -> String {
        return "playerCell"
    }
}
