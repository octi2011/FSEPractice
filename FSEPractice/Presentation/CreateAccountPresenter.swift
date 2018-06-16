//
//  CreateAccountPresenter.swift
//  Granis
//
//  Created by Octavian Duminica on 15/06/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import Foundation

class CreateAccountPresenter {
    weak var view: CreateAccountView?
    
    private var username: String?
    private var email: String?
    private var password: String?
    private var retypedPassword: String?
    
    init(view: CreateAccountView) {
        self.view = view
    }
    
    func usernamechanged(_ newValue: String?) {
        username = newValue
    }
    
    func emailChanged(_ newValue: String?) {
        email = newValue
    }
    
    func passwordChanged(_ newValue: String?) {
        password = newValue
    }
    
    func retypedPasswordChanged(_ newValue: String?) {
        retypedPassword = newValue
    }
    
    func register(completion: @escaping CompletionHandler) {
        if !dataIsValid() {
            completion(false)
            return
        }
        
        AuthService.register(username: username!, email: email!, password: password!) { (success) in
            if success {
                completion(true)
            } else {
                completion(false)
                return
            }
        }
    }
    
    private func dataIsValid() -> Bool {
        var dataIsValid = true
        
        if !isUsernameValid() {
            dataIsValid = false
            view?.colorizeUsernameTextFieldBorderForError()
        } else {
            view?.colorizeUsernameTextFieldBorder()
        }
        
        if !isEmailValid() {
            dataIsValid = false
            view?.colorizeEmailTextFieldBorderForError()
        } else {
            view?.colorizeEmailTextFieldBorder()
        }
        
        if !passwordsMatch() {
            dataIsValid = false
            view?.colorizePasswordTextFieldBorderForError()
            view?.colorizeRetypePasswordTextFieldBorderForError()
        } else {
            view?.colorizePasswordTextFieldBorder()
            view?.colorizeRetypePasswordTextFieldBorder()
        }
        
        return dataIsValid
    }
    
    private func isUsernameValid() -> Bool {
        if username!.count < 4 {
            return false
        }
        return true
    }
    
    private func isEmailValid() -> Bool {
        let regex = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        let result = predicate.evaluate(with: email!)
        return result
    }
    
    private func passwordsMatch() -> Bool {
        if retypedPassword! != password || password!.count < 6 {
            return false
        }
        return true
    }
}
