//
//  OrderID.swift
//  Hokah
//
//  Created by Кирилл Иванов on 29/01/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Firebase

class HookahDB {
    
    var tobacco: String
    var tastes: [String]
    var tea: String
    var time: String
    var price: String
    
    var ref: DatabaseReference?
    
    init?(tobacco: String, tastes: [String], tea: String, time: String, price: String) {
        self.tobacco = tobacco
        self.tastes = tastes
        self.tea = tea
        self.time = time
        self.price = price
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        tobacco = snapshotValue["tobacco"] as! String
        tastes = snapshotValue["tastes"] as! [String]
        tea = snapshotValue["tea"] as! String
        time = snapshotValue["time"] as! String
        price = snapshotValue["price"] as! String
    }
    
    func convertToDict() -> Any {
        return ["tobacco": tobacco, "tastes": tastes, "tea": tea, "time": time, "price": price]
    }
}
