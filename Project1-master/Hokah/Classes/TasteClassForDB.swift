//
//  TasteClassForDB.swift
//  Hokah
//
//  Created by Саша Руцман on 20.01.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Firebase

class TasteDB {
    
    var name: String
    var isAvailable: Bool = false
    var imageName: String
    var ref: DatabaseReference?
    
    init?(name: String, imageName: String) {
        
        self.name = name
        self.imageName = imageName
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot){
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        isAvailable = snapshotValue["isAvailable"] as! Bool
        imageName = snapshotValue["imageName"] as! String
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["name": name, "isAvailable": isAvailable, "imageName": imageName]
    }
}
