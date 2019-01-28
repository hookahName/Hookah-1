//
//  InfoClassForDB.swift
//  Hokah
//
//  Created by Саша Руцман on 28.01.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Firebase

class InfoDB {
    
    var location: String
    var contacts: String
    var ref: DatabaseReference?
    
    init?(location: String, contacts: String) {
        
        self.contacts = contacts
        self.location = location
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot){
        let snapshotValue = snapshot.value as! [String: AnyObject]
        location = snapshotValue["Location"] as! String
        contacts = snapshotValue["Contacts"] as! String
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["Location": location, "Contacts": contacts]
    }
}
