//
//  FeedSectionHeaderView.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit


class FeedSectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var headerViewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension FeedSectionHeaderView {

    func setupLabelsUI(labelTitle: String, labelColor: UIColor, labelFont: UIFont) {
        headerViewLabel.text = labelTitle
        headerViewLabel.textColor = labelColor
        headerViewLabel.font = labelFont
    }
}
