//
//  LatestCollectionViewCell.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit

class LatestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var feedCellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCorner()
    }
    
    func setupCorner(){
        contentView.layer.cornerRadius = 6.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    }
}
