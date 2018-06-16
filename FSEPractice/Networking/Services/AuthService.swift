//
//  AuthService.swift
//  Granis
//
//  Created by Octavian Duminica on 14/06/2018.
//  Copyright © 2018 Endava. All rights reserved.
//

import Foundation

class AuthService {
    
    static func login(email: String, password: String, completion: @escaping CompletionHandler) {
        FirebaseUserService.loginToFirebase(email: email, password: password) { (success) in
            if success {
                completion(true)
            } else {
                completion(false)
                return
            }
        }
    }
    
    static func fetchUserFromDatabase(completion: @escaping CompletionHandler) {
        FirebaseUserService.fetchUserFromFirebaseDatabase { (success) in
            if success {
                completion(true)    
            } else {
                completion(false)
                return
            }
        }
    }
    
    static func register(username: String, email: String, password: String, phone: String, completion: @escaping CompletionHandler) {
        FirebaseUserService.registerToFirebase(username: username, email: email, password: password, phone: phone) { (success) in
            if success {
                completion(true)
            } else {
                completion(false)
                return
            }
        }
    }
}
