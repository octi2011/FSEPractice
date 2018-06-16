//
//  Constants.swift
//  FSEPractice
//
//  Created by Duminica Octavian on 16/06/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

typealias CompletionHandler = (_ Success: Bool) -> ()

struct StoryboardID {
    static let loginScreen = "login"
    
    static let createAccountScreen = "createAccount"
    
    static let categoriesScreen = "categories"
}

struct UserDefaultsKey {
    static let user = "user"
}

struct FirebaseChild {
    static let users = "users"
}

struct FirebaseStoragePath {
    static let defaultProfilePath = "https://firebasestorage.googleapis.com/v0/b/fsepractice.appspot.com/o/profile-default.jpg?alt=media&token=c8bee6fe-49c5-402b-ac0b-69e51ee3b5cd"
}


