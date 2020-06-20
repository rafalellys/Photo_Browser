//
//  FeedCollectionViewCell.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var feedCellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCornerAndShadow()
    }
    
    func setupCornerAndShadow(){
        contentView.layer.cornerRadius = 6.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
//        layer.shadowColor = UIColor.lightGray.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        layer.shadowRadius = 6.0
//        layer.shadowOpacity = 1.0
//        layer.masksToBounds = false
//        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
//        layer.backgroundColor = UIColor.clear.cgColor
    }
    
}
