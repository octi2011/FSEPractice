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
    
    @IBOutlet weak var tableView: UITableView!
    
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

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseId()) as? CategoryCell else { return UITableViewCell() }
        
        let dictionary = StaticData.categories[indexPath.row]
        
        guard let name = dictionary[CategoriesKey.name], let pictureName = dictionary[CategoriesKey.pictureName] else { return UITableViewCell() }
        
        let category = Category(name: name, pictureName: pictureName)
        
        cell.configureCell(category: category)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StaticData.categories.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictionary = StaticData.categories[indexPath.row]
        
        guard let name = dictionary[CategoriesKey.name], let pictureName = dictionary[CategoriesKey.pictureName] else { return }
        
        let category = Category(name: name, pictureName: pictureName)
        
        navigateToDetailsScreen(category: category)
    }
}

extension CategoriesViewController: CategoriesView {
    func navigateToLoginScreen() {
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardID.loginScreen) as! LoginViewController
        loginViewController.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    func navigateToDetailsScreen(category: Category) {
        let detailsViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardID.detailsScreen) as! CategoryDetailsViewController
        detailsViewController.category = category
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

