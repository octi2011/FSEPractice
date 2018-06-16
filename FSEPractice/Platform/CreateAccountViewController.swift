//
//  CreateAccountViewController.swift
//  Granis
//
//  Created by Octavian Duminica on 15/06/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import UIKit

private struct Constants {
    static let cornerRadius: CGFloat = 5.0
    static let borderWidth: CGFloat = 1.5
}

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    lazy var presenter: CreateAccountPresenter = {
        return CreateAccountPresenter(view: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupGestures()
    }
    
    private func setupUI() {
        activityIndicatorView.isHidden = true
        roundCreateAccountButton()
        colorizeUsernameTextFieldBorder()
        colorizeEmailTextFieldBorder()
        colorizePasswordTextFieldBorder()
        colorizeRetypePasswordTextFieldBorder()
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - Actions
    @IBAction func onCreateAccountButtonTapped(_ sender: Any) {
        presenter.usernamechanged(usernameTextField.text)
        presenter.emailChanged(emailTextField.text)
        presenter.passwordChanged(passwordTextField.text)
        presenter.retypedPasswordChanged(retypePasswordTextField.text)
        startActivityIndicator()
        presenter.register { (success) in
            if success {
                self.navigateToCategoriesScreen()
                self.stopActivityIndicator()
            } else {
                self.displayRegisterFailedAlert()
                self.stopActivityIndicator()
            }
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
}

extension CreateAccountViewController: CreateAccountView {
    
    func roundCreateAccountButton() {
        createAccountButton.layer.cornerRadius = Constants.cornerRadius
        createAccountButton.clipsToBounds = true
    }
    
    func colorizeUsernameTextFieldBorder() {
        usernameTextField.layer.borderColor = UIColor.appBlue.cgColor
        usernameTextField.layer.borderWidth = Constants.borderWidth
    }
    
    func colorizeEmailTextFieldBorder() {
        emailTextField.layer.borderColor = UIColor.appBlue.cgColor
        emailTextField.layer.borderWidth = Constants.borderWidth
    }
    
    func colorizePasswordTextFieldBorder() {
        passwordTextField.layer.borderColor = UIColor.appBlue.cgColor
        passwordTextField.layer.borderWidth = Constants.borderWidth
    }
    
    func colorizeRetypePasswordTextFieldBorder() {
        retypePasswordTextField.layer.borderColor = UIColor.appBlue.cgColor
        retypePasswordTextField.layer.borderWidth = Constants.borderWidth
    }
    
    func colorizePasswordTextFieldBorderForError() {
        passwordTextField.layer.borderColor = UIColor.red.cgColor
        passwordTextField.layer.borderWidth = Constants.borderWidth
    }
    
    func colorizeRetypePasswordTextFieldBorderForError() {
        retypePasswordTextField.layer.borderColor = UIColor.red.cgColor
        retypePasswordTextField.layer.borderWidth = Constants.borderWidth
    }
    
    func colorizeUsernameTextFieldBorderForError() {
        usernameTextField.layer.borderColor = UIColor.red.cgColor
        usernameTextField.layer.borderWidth = Constants.borderWidth
    }
    
    func colorizeEmailTextFieldBorderForError() {
        emailTextField.layer.borderColor = UIColor.red.cgColor
        emailTextField.layer.borderWidth = Constants.borderWidth
    }
    
    func navigateToCategoriesScreen() {
        navigationController?.popToViewController((navigationController?.viewControllers.first)!, animated: true)
    }
    
    func displayRegisterFailedAlert() {
        let alert = UIAlertController(title: "Registration failed!", message: "Invalid data!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func startActivityIndicator() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }
}
