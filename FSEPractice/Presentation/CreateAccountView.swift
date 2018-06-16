//
//  CreateAccountView.swift
//  Granis
//
//  Created by Octavian Duminica on 15/06/2018.
//  Copyright © 2018 Endava. All rights reserved.
//

import Foundation

protocol CreateAccountView: class {
    func roundCreateAccountButton()
    func colorizeUsernameTextFieldBorder()
    func colorizeEmailTextFieldBorder()
    func colorizePhoneTextFieldBorder()
    func colorizePasswordTextFieldBorder()
    func colorizeRetypePasswordTextFieldBorder()
    func colorizePhoneTextFieldBorderForError()
    func colorizePasswordTextFieldBorderForError()
    func colorizeRetypePasswordTextFieldBorderForError()
    func colorizeUsernameTextFieldBorderForError()
    func colorizeEmailTextFieldBorderForError()
    func displayRegisterFailedAlert()
    func navigateToMyAccountScreen()
    func startActivityIndicator()
    func stopActivityIndicator()
}
