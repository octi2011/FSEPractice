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
    var roomId: String?
    
    var timer: Timer?
    var timeInt = 10
    var count = 0
    var player1Points = 0
    var player2Points = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var playerOneImageView: UIImageView!
    @IBOutlet weak var playerTwoImageView: UIImageView!
    @IBOutlet weak var playerOneName: UILabel!
    @IBOutlet weak var playerTwoName: UILabel!
    @IBOutlet weak var playerTwoPoints: UILabel!
    @IBOutlet weak var playerOnePoints: UILabel!
    @IBOutlet weak var progressImageView: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        
        questionView.layer.cornerRadius = 10.0
        questionView.clipsToBounds = true
        
        playerOneImageView.layer.cornerRadius = playerOneImageView.frame.width / 2
        playerOneImageView.clipsToBounds = true
        
        playerTwoImageView.layer.cornerRadius = playerTwoImageView.frame.width / 2
        playerTwoImageView.clipsToBounds = true
        
        getQuestions { (success) in
            if success {
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.questionLabel.text = self.questions.first?.question
            }
        }
        
        getFirstPlayer { (success) in
            if success {
            }
        }
        
        getSecondPlayer { (success) in
            if success {
            }
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    private func getQuestions(completion: @escaping CompletionHandler) {
        if let room = roomId {
            let ref = Database.database().reference().child(FirebaseChild.rooms).child(room).child(FirebaseChild.questions)
            ref.observe(.childAdded, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    if let question = Question(dictionary: dictionary) {
                        self.questions.append(question)
                    }
                    completion(true)
                } else {
                    completion(false)
                    return
                }
            }, withCancel: nil)
        }
    }
    
    private func updateUserOneScore() {
        if let room = roomId {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let ref = Database.database().reference().child(FirebaseChild.rooms).child(room).child(uid)
            
            let values = ["points": player1Points]
            ref.updateChildValues(values)
        }
    }
    
    private func addToOverallScore() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child(FirebaseChild.users).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                if let user = User(dictionary: dictionary) {
                    if var points = user.points {
                        points += self.player1Points
                        
                        let ref = Database.database().reference().child(FirebaseChild.users).child(uid)
                        let values = ["points": points]
                        ref.updateChildValues(values)
                    }
                }
            }
        }, withCancel: nil)
    }
    
    private func getFirstPlayer(completion: @escaping CompletionHandler) {
        if let room = roomId {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let ref = Database.database().reference().child(FirebaseChild.rooms).child(room).child(uid)
            ref.observe(.value) { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject] {
                    if let userId = dict["userId"] as? String{
                        Database.database().reference().child(FirebaseChild.users).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            if let dictionary = snapshot.value as? [String: AnyObject] {
                                
                                if let user = User(dictionary: dictionary) {
                                    self.playerOneName.text = user.username
                                    if let pictureUrl = user.pictureUrl {
                                        self.playerOneImageView.loadImageUsingCache(withUrlString: pictureUrl)
                                    }
                                    completion(true)
                                } else {
                                    completion(false)
                                    return
                                }
                            } else {
                                completion(false)
                                return
                            }
                        }, withCancel: nil)
                    }
                    if let points = dict["points"] as? Int {
                        self.playerOnePoints.text = "\(String.init(describing: points)) Puncte"
                        self.player1Points = points
                    }
                }
                completion(true)
            }
        }
    }
    @objc func updateTimer() {
        timeInt -= 1
        progressLabel.text = String(describing: timeInt)
        
        progressImageView.image = UIImage(named: "match\(String(describing: timeInt))")
        
        
        if timeInt == 0 {
            if count == 5 {
                timer?.invalidate()
                if player1Points > player2Points {
                    let alert = UIAlertController(title: "Bravo!", message: "Ai castigat!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                        self.navigationController?.popToViewController((self.navigationController?.viewControllers.first)!, animated: true)
                        self.addToOverallScore()
                        if let room = self.roomId {
                            let roomRef = Database.database().reference().child(FirebaseChild.rooms).child(room)
                            
                            roomRef.removeValue()
                        }
                    }
                    alert.addAction(okAction)
                    present(alert, animated: true, completion: nil)
                } else if player1Points < player2Points {
                    let alert = UIAlertController(title: "Ne pare rau!", message: "Ai pierdut!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                        self.navigationController?.popToViewController((self.navigationController?.viewControllers.first)!, animated: true)
                        if let room = self.roomId {
                            let roomRef = Database.database().reference().child(FirebaseChild.rooms).child(room)
                            roomRef.removeValue()
                        }
                        
                    }
                    alert.addAction(okAction)
                    present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Egalitate!", message: "Ai intalnit un oponent pe masura ta!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                        self.navigationController?.popToViewController((self.navigationController?.viewControllers.first)!, animated: true)
                        if let room = self.roomId {
                            let roomRef = Database.database().reference().child(FirebaseChild.rooms).child(room)
                            roomRef.removeValue()
                        }
                    }
                    alert.addAction(okAction)
                    present(alert, animated: true, completion: nil)
                }
            } else {
                questions.removeFirst()
                self.tableView.reloadData()
                self.questionLabel.text = questions.first?.question
                tableView.allowsSelection = true
                count += 1
                timeInt = 10
                
                progressLabel.text = String(describing: timeInt)
                progressImageView.image = UIImage(named: "progress\(String(describing: timeInt))")
            }
            
        }
    }
    
    private func getSecondPlayer(completion: @escaping CompletionHandler) {
        
        var otherPlayerId: String?
        if let room = roomId {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let ref = Database.database().reference().child(FirebaseChild.rooms).child(room)
            ref.observe(.value, with: { (snapshot) in
                if let array = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in array {
                        if snap.key.count == 28 && snap.key != uid {
                            otherPlayerId = snap.key
                        }
                    }
                }
                
                if let otherId = otherPlayerId {
                    let otherRef = Database.database().reference().child(FirebaseChild.rooms).child(room).child(otherId)
                    otherRef.observe(.value) { (snapshot) in
                        if let dict = snapshot.value as? [String: AnyObject] {
                            if let userId = dict["userId"] as? String{
                                Database.database().reference().child(FirebaseChild.users).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                                    
                                    if let dictionary = snapshot.value as? [String: AnyObject] {
                                        
                                        if let user = User(dictionary: dictionary) {
                                            self.playerTwoName.text = user.username
                                            if let pictureUrl = user.pictureUrl {
                                                self.playerTwoImageView.loadImageUsingCache(withUrlString: pictureUrl)
                                            }
                                            completion(true)
                                        } else {
                                            completion(false)
                                            return
                                        }
                                    } else {
                                        completion(false)
                                        return
                                    }
                                }, withCancel: nil)
                            }
                            if let points = dict["points"] as? Int {
                                self.playerTwoPoints.text = "\(String.init(describing: points)) Puncte"
                                self.player2Points = points
                            }
                        }
                        completion(true)
                    }
                }
            }, withCancel: nil)
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let question = questions.first {
            let answer = question.answer
            if indexPath.row == answer {
                player1Points += 1
                updateUserOneScore()
                tableView.allowsSelection = false
            } else {
                tableView.allowsSelection = false
            }
            
        }
    }
}

