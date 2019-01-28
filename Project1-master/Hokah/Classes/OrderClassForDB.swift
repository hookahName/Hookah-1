//
//  OrderClassForDB.swift
//  Hokah
//
//  Created by Кирилл Иванов on 26/01/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Firebase

class OrderDB {
    
    var tableNumber: Int
    var tobacco: String
    var tastes: [String]
    var tea: String
    var time: String
    var isDone: Bool = false
    var identifier: String?
    var price: String
    var userId: String
    var ref: DatabaseReference?
    
    init?(tableNumber: Int, tobacco: String, tastes: [String], tea: String, time: String, identifier: String, price: String, userId: String){
        self.tableNumber = tableNumber
        self.tobacco = tobacco
        self.tastes = tastes
        self.tea = tea
        self.time = time
        self.identifier = identifier
        self.price = price
        self.userId = userId
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        tableNumber = snapshotValue["table"] as! Int
        tobacco = snapshotValue["tobacco"] as! String
        tastes = snapshotValue["tastes"] as! [String]
        tea = snapshotValue["tea"] as! String
        time = snapshotValue["time"] as! String
        isDone = snapshotValue["isDone"] as! Bool
        identifier = snapshotValue["identifier"] as? String
        price = snapshotValue["price"] as! String
        userId = snapshotValue["userId"] as! String
        ref = snapshot.ref
    }
    
    init?(tableNumber: Int, tobacco: String, tastes: [String], tea: String, time: String, price: String, userId: String){
        self.tableNumber = tableNumber
        self.tobacco = tobacco
        self.tastes = tastes
        self.tea = tea
        self.time = time
        identifier = nil
        self.price = price
        self.userId = userId
        ref = nil
    }
    
    func convertToDictionary() -> Any {
        return ["table": tableNumber, "tobacco": tobacco, "tastes": tastes, "tea": tea, "time": time, "isDone": isDone, "identifier": identifier, "price": price, "userId": userId]
    }
}
