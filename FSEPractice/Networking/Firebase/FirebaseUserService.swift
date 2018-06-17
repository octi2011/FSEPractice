//
//  FirebaseUserService.swift
//  FSEPractice
//
//  Created by Octavian Duminica on 14/06/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import Foundation
import Firebase

private struct UserKey {
    static let email = "email"
    static let username = "username"
    static let pictureUrl = "pictureUrl"
    static let points = "points"
}

class FirebaseUserService {
    
    static func loginToFirebase(email: String, password: String, completion: @escaping CompletionHandler) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                print(error as Any)
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    static func fetchUserFromFirebaseDatabase(completion: @escaping CompletionHandler) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child(FirebaseChild.users).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                if let user = User(dictionary: dictionary) {
                    let data = NSKeyedArchiver.archivedData(withRootObject: user)
                    UserDefaults.standard.set(data, forKey: UserDefaultsKey.user)
                    completion(true)
                } else {
                    completion(false)
                    return
                }
            } else {
                completion(false)
                return
            }
        }, withCancel: nil)
    }
    
    static func registerToFirebase(username: String, email: String, password: String, completion: @escaping CompletionHandler) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                print(error as Any)
                completion(false)
                return
            }
            
            guard let uid = user?.user.uid else {
                completion(false)
                return
            }
            
            let values = [UserKey.username: username, UserKey.email: email, UserKey.pictureUrl: FirebaseStoragePath.defaultProfilePath, UserKey.points: 0] as [String : AnyObject]
            
            registerUserIntoDatabase(withUID: uid, values: values as [String : AnyObject], completion: { (success) in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            })
        }
    }
    
    static func registerUserIntoDatabase(withUID uid: String, values: [String: AnyObject], completion: @escaping CompletionHandler) {
        
        let ref = Database.database().reference()
        let usersReference = ref.child(FirebaseChild.users).child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err as Any)
                completion(false)
                return
            }
            
            if let user = User(dictionary: values)  {
                let data = NSKeyedArchiver.archivedData(withRootObject: user)
                UserDefaults.standard.set(data, forKey: UserDefaultsKey.user)
                completion(true)
            } else {
                completion(false)
                return
            }
        })
    }
}
