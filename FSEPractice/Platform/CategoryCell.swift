//
//  CategoryCell.swift
//  FSEPractice
//
//  Created by Duminica Octavian on 16/06/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(category: Category) {
        categoryNameLabel.text = category.name
        categoryImageView.image = UIImage(named: category.pictureName)
    }
    
    static func reuseId() -> String {
        return "categoryCell"
    }
}
