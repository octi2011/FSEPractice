//
//  LoginPresenter.swift
//  FSEPractice
//
//  Created by Octavian Duminica on 14/06/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import Foundation

class LoginPresenter {
    weak var view: LoginView?
    
    private var email: String?
    private var password: String?
    
    init(view: LoginView) {
        self.view = view
    }
    
    func emailChanged(_ newValue: String?) {
        email = newValue
    }
    
    func passwordChanged(_ newValue: String?) {
        password = newValue
    }
    
    func login(completion: @escaping CompletionHandler) {
        AuthService.login(email: email!, password: password!) { (success) in
            if success {
                AuthService.fetchUserFromDatabase(completion: { (success) in
                    if success {
                        completion(true)
                    } else {
                        completion(false)
                        return
                    }
                })
            } else {
                completion(false)
                return
            }
        }
    }
}
