//
//  passClass.swift
//  Hokah
//
//  Created by Саша Руцман on 22.01.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Firebase
class PasswordDB {
    
    var password: String
    var ref: DatabaseReference?
    
    init?(password: String) {
        
        self.password = password
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot){
        let snapshotValue = snapshot.value as! [String: String]
        password = snapshotValue["password"]!
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["password": password]
    }
}
