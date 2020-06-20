//
//  AppFonts.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit


let fontSetForWidth : CGFloat = 375.0

enum AppFonts: String {
    case Regular = "Times"
    case Medium = "Poppins-Medium"
    case SemiBold = "Poppins-SemiBold"
    
    func of(size: CGFloat) -> UIFont? {
        return UIFont(name: self.rawValue, size: size)
    }
}

enum StandardSize: CGFloat {
    case sMin = 8.0
    case s0 = 11.0
    case s1 = 13.0
    case s2 = 14.0
    case s3 = 16.0
    case s4 = 17.0
    case s5 = 20.0
    case s6 = 25.0
    
}
