//
//  Flavour.swift
//  Hokah
//
//  Created by Кирилл Иванов on 06/01/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class Flavour {
    
    var name: String
    var photoImage: UIImage?
    
    init?(name: String, photoImage: UIImage?) {
        self.name = name
        self.photoImage = photoImage
    }
}
