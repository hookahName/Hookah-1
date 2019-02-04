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
    var timeTill: String
    var price: String
    var fortress: String
    
    var ref: DatabaseReference?
    
    init?(tobacco: String, tastes: [String], tea: String, time: String, timeTill: String, price: String, fortress: String) {
        self.tobacco = tobacco
        self.tastes = tastes
        self.tea = tea
        self.time = time
        self.timeTill = timeTill
        self.price = price
        self.fortress = fortress
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        tobacco = snapshotValue["tobacco"] as! String
        tastes = snapshotValue["tastes"] as! [String]
        tea = snapshotValue["tea"] as! String
        time = snapshotValue["time"] as! String
        timeTill = snapshotValue["timeTill"] as! String
        price = snapshotValue["price"] as! String
        fortress = snapshotValue["fortress"] as! String
    }
    
    func convertToDict() -> Any {
        return ["tobacco": tobacco, "tastes": tastes, "tea": tea, "time": time,"timeTill": timeTill, "price": price, "fortress": fortress]
    }
}
