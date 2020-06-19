//
//  RoundedCornersView.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit

class RoundedCornersImageView: UIImageView {

    override func awakeFromNib() {
        
        layer.cornerRadius = 8.0
        clipsToBounds = true
        
    }

}
