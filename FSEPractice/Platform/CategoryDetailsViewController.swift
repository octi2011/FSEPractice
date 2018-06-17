//
//  CategoryDetailsViewController.swift
//  FSEPractice
//
//  Created by Duminica Octavian on 16/06/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import UIKit
import Firebase

private struct QuestionKey {
    static let question = "question"
    static let firstAnswer = "0"
    static let secondAnswer = "1"
    static let thirdAnswer = "2"
    static let answer = "answer"
}

class CategoryDetailsViewController: UIViewController {
    
    var users = [User]()
    
    var timer: Timer?
    var timeInt = 10
    var category: Category? {
        didSet {
            navigationItem.title = category?.name
        }
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var progressImageView: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    
    var questions = [Question]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pictureName = category?.pictureName {
            categoryImageView.image = UIImage(named: pictureName)
        }
        
        playButton.layer.cornerRadius = 10.0
        playButton.clipsToBounds = true
        
        fetchUsers()
    }
    
    @IBAction func onStatsTapped(_ sender: Any) {
    }
    
    private func fetchUsers() {
        Database.database().reference().child(FirebaseChild.users).observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                if let user = User(dictionary: dictionary) {
                    user.id = snapshot.key
                    self.users.append(user)
                }
                
                self.users.sort(by: { (u1, u2) -> Bool in
                    return u1.points! > u2.points!
                })
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    @IBAction func onPlayTapped(_ sender: Any) {
        playButton.setTitle("", for: .normal)
        playButton.isEnabled = false
        progressImageView.isHidden = false
        progressLabel.isHidden = false
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let roomRef = Database.database().reference().child(FirebaseChild.queue)
        let childRef = roomRef.child(uid)
        let values = ["userId": uid] as [String: AnyObject]
        
        childRef.updateChildValues(values) { (error, ref) in
            
            if (error != nil) {
                print(error as Any)
                return
            }
        }
        
        roomRef.observe(.value, with: { (snapshot) in
            if snapshot.childrenCount == 2 {
                
                let matchViewController = self.storyboard?.instantiateViewController(withIdentifier: StoryboardID.matchScreen) as! MatchViewController
                matchViewController.navigationItem.setHidesBackButton(true, animated: true)
                
                self.navigationController?.pushViewController(matchViewController, animated: true)
                
                childRef.removeValue { (error, ref) in
                    if error != nil {
                        print(error as Any)
                        return
                    }
                }
                
                let ref = Database.database().reference().child(FirebaseChild.rooms)
                
                if let dict = snapshot.children.allObjects.first as? DataSnapshot {
                    if let item = dict.value as? [String: AnyObject] {
                        let refChildRef = ref.child(item["userId"] as! String)
                        
                        if let room = item["userId"] as? String {
                            matchViewController.roomId = room
                            print(matchViewController.roomId!)
                        }
                        
                        let value = [uid: uid]
                        refChildRef.updateChildValues(value, withCompletionBlock: { (error, ref) in
                            if error != nil {
                                print(error as Any)
                                return
                            }
                        })
                        
                        self.getQuestions { (success) in
                            if success {
                                self.questions.shuffle()
                                let questionsToSend = self.questions.prefix(6)
                                let questionsArray = Array(questionsToSend)
                                var dictArray = [[String: AnyObject]]()
                                for item in questionsArray {
                                    var qDict = [String: AnyObject]()
                                    qDict[QuestionKey.question] = item.question as AnyObject
                                    qDict[QuestionKey.firstAnswer] = item.firstAnswer as AnyObject
                                    qDict[QuestionKey.secondAnswer] = item.secondAnswer as AnyObject
                                    qDict[QuestionKey.thirdAnswer] = item.thirdAnswer as AnyObject
                                    qDict[QuestionKey.answer] = item.answer as AnyObject
                                    dictArray.append(qDict)
                                }
                                let qValues = ["questions": dictArray]
                                
                                refChildRef.updateChildValues(qValues, withCompletionBlock: { (error, ref) in
                                    if error != nil {
                                        print(error as Any)
                                        return
                                    }
                                })
                            }
                        }
                    }
                    
                }
            }
        }, withCancel: nil)
    }
    
    
    @objc func updateTimer() {
        timeInt -= 1
        progressLabel.text = String(describing: timeInt)
        
        progressImageView.image = UIImage(named: "progress\(String(describing: timeInt))")
        
        
        if timeInt == 0 {
            timer?.invalidate()
            playButton.setTitle("Joaca", for: .normal)
            playButton.isEnabled = true
            progressImageView.isHidden = true
            progressLabel.isHidden = true
            timeInt = 10
            progressLabel.text = String(describing: timeInt)
            progressImageView.image = UIImage(named: "progress\(String(describing: timeInt))")
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let roomRef = Database.database().reference().child(FirebaseChild.queue)
            let childRef = roomRef.child(uid)
            childRef.removeValue { (error, ref) in
                if error != nil {
                    print(error as Any)
                    return
                }
            }
        }
    }
    
    
    
    private func getQuestions(completion: @escaping CompletionHandler) {
        let ref = Database.database().reference().child(FirebaseChild.questions)
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

extension CategoryDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.reuseId()) as? PlayerCell else { return UITableViewCell() }
        
        let user = users[indexPath.row]
        
        cell.rankLabel.text = "\(String(describing: indexPath.row+1))."
        
        cell.configureCell(user: user)
        
        return cell
    }
}


extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}
