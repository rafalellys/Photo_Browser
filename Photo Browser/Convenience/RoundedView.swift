//
//  RoundedView.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-20.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit

class RoundedView: UIView {

    override func awakeFromNib() {
        layer.cornerRadius = 8.0
        clipsToBounds = true
    }

}
