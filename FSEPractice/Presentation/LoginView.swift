//
//  LoginView.swift
//  Granis
//
//  Created by Octavian Duminica on 14/06/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import Foundation

protocol LoginView: class {
    func roundLoginButton()
    func colorizeEmailTextFieldBorder()
    func colorizePasswordTextFieldBorder()
    func setupSignupButtonTitle()
    func navigateToCreateAccountScreen()
    func navigateToCategoriesScreen()
    func displayLoginFailedAlert()
    func startActivityIndicator()
    func stopActivityIndicator()
}
