//
//  MatchViewController.swift
//  FSEPractice
//
//  Created by Duminica Octavian on 16/06/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import UIKit
import Firebase

class MatchViewController: UIViewController {
    
    var questions = [Question]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var playerOneImageView: UIImageView!
    @IBOutlet weak var playerTwoImageView: UIImageView!
    @IBOutlet weak var playerOneName: UILabel!
    @IBOutlet weak var playerTwoName: UILabel!
    @IBOutlet weak var playerTwoPoints: UILabel!
    @IBOutlet weak var playerOnePoints: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        
        questionView.layer.cornerRadius = 10.0
        questionView.clipsToBounds = true
        
        getQuestions { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.questionLabel.text = self.questions.first?.question
            }
        }
    }
    
    private func getQuestions(completion: @escaping CompletionHandler) {
        let ref = Database.database().reference().child(FirebaseChild.questions)
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let question = Question(dictionary: dictionary) {
                    self.questions.append(question)
                    print(question.question!)
                }
                completion(true)
            } else {
                completion(false)
                return
            }
        }, withCancel: nil)
    }
}

extension MatchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnswerCell.reuseId()) as? AnswerCell else { return UITableViewCell() }
        
        if let question = questions.first {
            cell.configureCell(question: question, indexPath: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}
