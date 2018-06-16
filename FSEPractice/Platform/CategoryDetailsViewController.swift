//
//  CategoryDetailsViewController.swift
//  FSEPractice
//
//  Created by Duminica Octavian on 16/06/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import UIKit
import Firebase

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
//        let ref = Database.database().reference().child(FirebaseChild.questions)
//        let childRef = ref.childByAutoId()
//        let values = [
//            "question": "Managementul integrat al marketingului este:",
//            "0": "un concept subliniat de mai multi autori; ",
//            "1": "procesul complex decizional, amplu si atotcuprinzator bazat pe cunostinte si maiestrie prin care se concep si implementeaza unitar procedurile decizionale adoptate de substructurile companiei (firmei) in scopul identificarii pietelor tinta, atragerii si mentinerii clientilor satisfacuti de produsele/serviciile oferite in relatii reciproc profitabile;",
//            "2": "un proces deosebit de complex si complicat pe care se bazeaza economia de piata globalizata.",
//            "answer": "1"
//        ]
//        childRef.updateChildValues(values) { (error, ref) in
//            if error != nil {
//                print(error as Any)
//                return
//            }
//        }
    }
    
    private func fetchUsers() {
        Database.database().reference().child(FirebaseChild.users).observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                if let user = User(dictionary: dictionary) {
                    user.id = snapshot.key
                    self.users.append(user)
                }
                
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
        
        let roomRef = Database.database().reference().child("queue")
        let childRef = roomRef.child(uid)
        let values = ["userId": uid] as [String: AnyObject]
        
        childRef.updateChildValues(values) { (error, ref) in
            
            if (error != nil) {
                print(error as Any)
                return
            }
        }
        
        roomRef.observe(.value, with: { (snapshot) in
            print(snapshot)
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
            let roomRef = Database.database().reference().child("queue")
            let childRef = roomRef.child(uid)
            childRef.removeValue { (error, ref) in
                if error != nil {
                    print(error as Any)
                    return
                }
            }
        }
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
