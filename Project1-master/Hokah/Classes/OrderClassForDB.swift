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
    //var tobacco: String
    //var tastes: [String]
    //var tea: String
    //var time: String
    var isDone: Bool = false
    var identifier: String
    var price: String
    var userId: String
    var timeTill: String
    var timeStart: String
    var ref: DatabaseReference?
    
    init?(tableNumber: Int, identifier: String, price: String, userId: String, timeTill: String, timeStart: String){
        self.tableNumber = tableNumber
        self.identifier = identifier
        self.price = price
        self.userId = userId
        self.timeTill = timeTill
        self.timeStart = timeStart
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        tableNumber = snapshotValue["table"] as! Int
        isDone = snapshotValue["isDone"] as! Bool
        identifier = snapshotValue["identifier"] as! String
        price = snapshotValue["price"] as! String
        userId = snapshotValue["userId"] as! String
        timeTill = snapshotValue["timeTill"] as! String
        timeStart = snapshotValue["timeStart"] as! String
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["table": tableNumber, "isDone": isDone, "identifier": identifier, "price": price, "userId": userId, "timeTill": timeTill, "timeStart": timeStart]
    }
}
