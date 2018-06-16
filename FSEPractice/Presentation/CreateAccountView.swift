//
//  CreateAccountView.swift
//  Granis
//
//  Created by Octavian Duminica on 15/06/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import Foundation

protocol CreateAccountView: class {
    func roundCreateAccountButton()
    func colorizeUsernameTextFieldBorder()
    func colorizeEmailTextFieldBorder()
    func colorizePasswordTextFieldBorder()
    func colorizeRetypePasswordTextFieldBorder()
    func colorizePasswordTextFieldBorderForError()
    func colorizeRetypePasswordTextFieldBorderForError()
    func colorizeUsernameTextFieldBorderForError()
    func colorizeEmailTextFieldBorderForError()
    func navigateToCategoriesScreen()
    func displayRegisterFailedAlert()
    func startActivityIndicator()
    func stopActivityIndicator()
}
