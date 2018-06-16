//
//  LoginView.swift
//  Granis
//
//  Created by Octavian Duminica on 14/06/2018.
//  Copyright © 2018 Endava. All rights reserved.
//

import Foundation

protocol LoginView: class {
    func roundLoginButton()
    func colorizeEmailTextFieldBorder()
    func colorizePasswordTextFieldBorder()
    func setupForgotPasswordButtonTitle()
    func setupSignupButtonTitle()
    func navigateToMyAccountScreen()
    func navigateToCreateAccountScreen()
    func displayLoginFailedAlert()
    func startActivityIndicator()
    func stopActivityIndicator()
}
