//
//  AppFonts.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit


enum AppFonts: String {
    case Regular = "Avenir Next"
    case Medium = "AvenirNext-Medium"
    case SemiBold = "AvenirNext-DemiBold"
    
    func of(size: CGFloat) -> UIFont? {
        return UIFont(name: self.rawValue, size: size)
    }
}

enum Size: CGFloat {
    case h1 = 30.0
    case h2 = 25.0
    case h3 = 20.0
    case h4 = 17.0
    case h5 = 16.0
    case h6 = 14.0
}
