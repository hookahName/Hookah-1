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
    var price: String
    var isAvailable: Bool = false
    var ref: DatabaseReference?
    
    init?(name: String, price: String) {
        
        self.name = name
        self.price = price
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot){
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        price = snapshotValue["price"] as! String
        isAvailable = snapshotValue["isAvailable"] as! Bool
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["name": name,"price": price + " Руб.", "isAvailable": isAvailable]
    }
}
