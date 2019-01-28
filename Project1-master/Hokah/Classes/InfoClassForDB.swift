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
    var url: String
    var imageName: String
    var ref: DatabaseReference?
    
    init?(location: String, contacts: String, url: String, imageName: String) {
        
        self.contacts = contacts
        self.location = location
        self.url = url
        self.imageName = imageName
        
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot){
        let snapshotValue = snapshot.value as! [String: AnyObject]
        location = snapshotValue["Location"] as! String
        contacts = snapshotValue["Contacts"] as! String
        url = snapshotValue["Url"] as! String
        imageName = snapshotValue["imageName"] as! String
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["Location": location, "Contacts": contacts, "Url": url, "imageName": imageName]
    }
}
