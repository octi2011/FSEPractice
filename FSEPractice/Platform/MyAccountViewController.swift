//
//  MyAccountViewController.swift
//  FSEPractice
//
//  Created by Duminica Octavian on 17/06/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import UIKit
import Firebase

class MyAccountViewController: UIViewController {

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var pointsView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pointsView.layer.cornerRadius = 10.0
        pointsView.clipsToBounds = true
        
        nameView.layer.cornerRadius = 10.0
        nameView.clipsToBounds = true
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child(FirebaseChild.users).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                if let user = User(dictionary: dictionary) {
                    self.pointsLabel.text = "\(String(describing: user.points!)) Puncte"
                    self.nameLabel.text = user.username
                    if let pictureUrl = user.pictureUrl {
                        self.profileImageView.loadImageUsingCache(withUrlString: pictureUrl)
                    }
                    
                }
            }
        }, withCancel: nil)
    }
}
