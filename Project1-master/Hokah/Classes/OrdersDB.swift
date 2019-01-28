//
//  OrdersDB.swift
//  Hokah
//
//  Created by Кирилл Иванов on 28/01/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Firebase

class OrdersDB {
    
    
    var identifier: String
    var ref: DatabaseReference?
    
    init?(identifier: String){
        self.identifier = identifier
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        identifier = snapshotValue["identifier"] as! String
        ref = snapshot.ref
    }
    /*
    func convertToDictionary() -> Any {
        return ["table": tableNumber, "tobacco": tobacco, "tastes": tastes, "tea": tea, "time": time, "isDone": isDone, "identifier": identifier, "price": price, "userId": userId]
    }*/
}
