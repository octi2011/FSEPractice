//
//  LoginViewController.swift
//  Granis
//
//  Created by Octavian Duminica on 14/06/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import UIKit

private struct Constants {
    static let cornerRadius: CGFloat = 5.0
    static let borderWidth: CGFloat = 1.5
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    lazy var presenter: LoginPresenter = {
        return LoginPresenter(view: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupGestures()
    }
    
    private func setupUI() {
        activityIndicatorView.isHidden = true
        roundLoginButton()
        colorizeEmailTextFieldBorder()
        colorizePasswordTextFieldBorder()
        setupSignupButtonTitle()
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @IBAction private func onLoginTapped(_ sender: Any) {
        presenter.emailChanged(emailTextField.text)
        presenter.passwordChanged(passwordTextField.text)
        startActivityIndicator()
        presenter.login { (success) in
            if success {
                self.navigateToCategoriesScreen()
                self.stopActivityIndicator()
            } else {
                self.displayLoginFailedAlert()
                self.stopActivityIndicator()
            }
        }
    }
    
    @IBAction func onSignupButtonTapped(_ sender: Any) {
        navigateToCreateAccountScreen()
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
}

// MARK: - LoginView
extension LoginViewController: LoginView {
    
    func roundLoginButton() {
        loginButton.layer.cornerRadius = Constants.cornerRadius
        loginButton.clipsToBounds = true
    }
    
    func colorizeEmailTextFieldBorder() {
        emailTextField.layer.borderColor = UIColor.appBlue.cgColor
        emailTextField.layer.borderWidth = Constants.borderWidth
    }
    
    func colorizePasswordTextFieldBorder() {
        passwordTextField.layer.borderColor = UIColor.appBlue.cgColor
        passwordTextField.layer.borderWidth = Constants.borderWidth
    }
    
    func setupSignupButtonTitle() {
        let attributedString = NSMutableAttributedString(string: "Nu aveti inca un cont? Creati unul aici!", attributes: [
            .font: UIFont.OpenSansRegularBig!,
            .foregroundColor: UIColor.appGray
            ])
        attributedString.addAttribute(.font, value: UIFont.OpenSansSemiboldBig!, range: NSRange(location: 23, length: 15))
        signupButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    func displayLoginFailedAlert() {
        let alert = UIAlertController(title: "Login Failed", message: "Incorrect username or password!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func navigateToCreateAccountScreen() {
        let createAccountController = storyboard?.instantiateViewController(withIdentifier: StoryboardID.createAccountScreen) as! CreateAccountViewController
        navigationController?.pushViewController(createAccountController, animated: true)
    }
    
    func navigateToCategoriesScreen() {
        navigationController?.popToViewController((navigationController?.viewControllers.first)!, animated: true)
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
