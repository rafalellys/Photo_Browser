//
//  CircleView.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit

class CircleView: UIView {

    override func awakeFromNib() {
        
        layer.cornerRadius = frame.size.height * 0.5
        clipsToBounds = true
    }

}
