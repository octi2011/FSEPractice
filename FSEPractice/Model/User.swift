//
//  User.swift
//  Granis
//
//  Created by Octavian Duminica on 14/06/2018.
//  Copyright © 2018 Endava. All rights reserved.
//

import Foundation

private struct UserKey {
    static let email = "email"
    static let username = "username"
    static let pictureUrl = "pictureUrl"
    static let phone = "phone"
}

class User: NSObject {
    
    var id: String?
    var username: String?
    var email: String?
    var phone: String?
    var pictureUrl: String?
    
    init(username: String, email: String, phone: String, pictureUrl: String) {
        self.username = username
        self.email = email
        self.phone = phone
        self.pictureUrl = pictureUrl
    }
    
    init?(dictionary: [String: AnyObject]) {
        guard let username = dictionary[UserKey.username] as? String, let email = dictionary[UserKey.email] as? String,
            let phone = dictionary[UserKey.phone] as? String,
            let pictureUrl = dictionary[UserKey.pictureUrl] as? String else { return nil }
        
        self.username = username
        self.email = email
        self.phone = phone
        self.pictureUrl = pictureUrl
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let username = aDecoder.decodeObject(forKey: UserKey.username) as? String,
            let email = aDecoder.decodeObject(forKey: UserKey.email) as? String,
            let phone = aDecoder.decodeObject(forKey: UserKey.phone) as? String,
            let pictureUrl = aDecoder.decodeObject(forKey: UserKey.pictureUrl) as? String else { return nil }
        
        self.init(username: username, email: email, phone: phone, pictureUrl: pictureUrl)
    }
}

extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: UserKey.username)
        aCoder.encode(email, forKey: UserKey.email)
        aCoder.encode(phone, forKey: UserKey.phone)
        aCoder.encode(pictureUrl, forKey: UserKey.pictureUrl)
    }
}
