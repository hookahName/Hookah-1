//
//  UserClass.swift
//  Hokah
//
//  Created by Саша Руцман on 25.01.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Firebase

class UserDB {
    
    var name: String
    var email: String
    var password: String
    var userId: String
    var ref: DatabaseReference?
    
    init?(name: String, email: String, password: String, userId: String) {
        
        self.name = name
        self.email = email
        self.password = password
        self.userId = userId
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot){
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        email = snapshotValue["email"] as! String
        password = snapshotValue["password"] as! String
        userId = snapshotValue["userId"] as! String
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["name": name, "email": email, "password": password, "userId": userId]
    }
}
