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
    @IBOutlet weak var titleView: RoundedView!
    

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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = titleView.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if selected {
            titleView.backgroundColor = color
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = titleView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            titleView.backgroundColor = color
        }
    }
}
