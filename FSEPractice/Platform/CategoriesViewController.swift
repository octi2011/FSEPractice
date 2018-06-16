//
//  CategoriesViewController.swift
//  FSEPractice
//
//  Created by Duminica Octavian on 16/06/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import UIKit
import Firebase

class CategoriesViewController: UIViewController {
    
    lazy var presenter: CategoriesPresenter = {
        return CategoriesPresenter(view: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
    }
    
    private func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            navigateToLoginScreen()
        }
    }
    @IBAction func onLogoutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigateToLoginScreen()
        } catch {
            print(error)
        }
        
    }
}

extension CategoriesViewController: CategoriesView {
    func navigateToLoginScreen() {
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardID.loginScreen) as! LoginViewController
        loginViewController.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.pushViewController(loginViewController, animated: true)
    }
}

