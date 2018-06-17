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
    
    static let detailsScreen = "details"
    
    static let matchScreen = "match"
    
    static let myAccountScreen = "myAccount"
}

struct UserDefaultsKey {
    static let user = "user"
}

struct FirebaseChild {
    static let users = "users"
    static let questions = "questions"
    static let rooms = "rooms"
    static let queue = "queue"
}

struct FirebaseStoragePath {
    static let defaultProfilePath = "https://firebasestorage.googleapis.com/v0/b/fsepractice.appspot.com/o/image%403x.png?alt=media&token=40ee8fd5-ff39-4bd7-90ca-d309cabf49cb"
}

struct CategoriesKey {
    static let name = "name"
    static let pictureName = "pictureName"
}

struct StaticData {
    static let categories = [
        [
        CategoriesKey.name: "Management",
        CategoriesKey.pictureName: "fse1"
        ],
        [
        CategoriesKey.name: "Marketing",
        CategoriesKey.pictureName: "fse2"
        ],
        [
        CategoriesKey.name: "Finante",
        CategoriesKey.pictureName: "fse3"
        ],
        [
        CategoriesKey.name: "Economie",
        CategoriesKey.pictureName: "fse4"
        ],
        [
        CategoriesKey.name: "Contabilitate",
        CategoriesKey.pictureName: "fse5"
        ],
        [
        CategoriesKey.name: "Afaceri",
        CategoriesKey.pictureName: "fse6"
        ]
    ]
}


