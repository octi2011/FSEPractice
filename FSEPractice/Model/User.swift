//
//  User.swift
//  Granis
//
//  Created by Octavian Duminica on 14/06/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import Foundation

private struct UserKey {
    static let email = "email"
    static let username = "username"
    static let pictureUrl = "pictureUrl"
}

class User: NSObject {
    
    var id: String?
    var username: String?
    var email: String?
    var pictureUrl: String?
    
    init(username: String, email: String, pictureUrl: String) {
        self.username = username
        self.email = email
        self.pictureUrl = pictureUrl
    }
    
    init?(dictionary: [String: AnyObject]) {
        guard let username = dictionary[UserKey.username] as? String, let email = dictionary[UserKey.email] as? String,
            let pictureUrl = dictionary[UserKey.pictureUrl] as? String else { return nil }
        
        self.username = username
        self.email = email
        self.pictureUrl = pictureUrl
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let username = aDecoder.decodeObject(forKey: UserKey.username) as? String,
            let email = aDecoder.decodeObject(forKey: UserKey.email) as? String,
            let pictureUrl = aDecoder.decodeObject(forKey: UserKey.pictureUrl) as? String else { return nil }
        
        self.init(username: username, email: email, pictureUrl: pictureUrl)
    }
}

extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: UserKey.username)
        aCoder.encode(email, forKey: UserKey.email)
        aCoder.encode(pictureUrl, forKey: UserKey.pictureUrl)
    }
}
