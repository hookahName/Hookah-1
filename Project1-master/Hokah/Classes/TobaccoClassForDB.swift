//
//  TobaccoClassForDB.swift
//  Hokah
//
//  Created by Саша Руцман on 12.01.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Firebase
class TobaccoDB {
    
    var name: String
    var isAvailable: Bool = false
    var ref: DatabaseReference?
    
    init?(name: String) {
        
        self.name = name
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot){
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        isAvailable = snapshotValue["isAvailable"] as! Bool
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["name": name, "isAvailable": isAvailable]
    }
}
