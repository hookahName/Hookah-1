//
//  Tabacoo.swift
//  Hokah
//
//  Created by Кирилл Иванов on 06/01/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class Tabacoo {
    
    var name: String
    var info: String
    var image: UIImage?
    
    init?(name: String, info: String, image: UIImage?) {

        self.name = name
        self.info = info
        self.image = image
    }
}
