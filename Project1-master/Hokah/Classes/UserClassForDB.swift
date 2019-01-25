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
    var lastname: String
    var email: String
    var password: String
    var ref: DatabaseReference?
    
    init?(name: String, lastname: String, email: String, password: String) {
        
        self.name = name
        self.lastname = lastname
        self.email = email
        self.password = password
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot){
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        lastname = snapshotValue["lastname"] as! String
        email = snapshotValue["email"] as! String
        password = snapshotValue["password"] as! String
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["name": name, "lastname": lastname, "email": email, "password": password]
    }
}
