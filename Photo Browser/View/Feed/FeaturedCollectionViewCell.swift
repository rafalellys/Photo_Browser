//
//  FeaturedCollectionViewCell.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit

class FeaturedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var popularPhotoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCornerAndShadow()
    }
    
    func setupCornerAndShadow(){
           contentView.layer.cornerRadius = 6.0
           contentView.layer.borderWidth = 1.0
           contentView.layer.borderColor = UIColor.clear.cgColor
           contentView.layer.masksToBounds = true
       }

}
