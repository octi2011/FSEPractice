//
//  AnswerCell.swift
//  FSEPractice
//
//  Created by Duminica Octavian on 16/06/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import UIKit

class AnswerCell: UITableViewCell {

    @IBOutlet weak var answerTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(question: Question, indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            answerTextLabel.text = question.firstAnswer
        case 1:
            answerTextLabel.text = question.secondAnswer
        case 2:
            answerTextLabel.text = question.thirdAnswer
        default:
            return
        }
    }
    
    static func reuseId() -> String {
        return "answerCell"
    }
}
