//
//  SearchResultsTableViewCell.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var searchCellImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateLabel.textColor = .lightGray
        dateLabel.font = AppFonts.Raleway.of(size: Size.h6.rawValue)

        usernameLabel.textColor = .darkGray
        usernameLabel.font = AppFonts.Raleway.of(size: Size.h5.rawValue)

        descriptionLabel.textColor = .darkGray
        descriptionLabel.font = AppFonts.Raleway.of(size: Size.h5.rawValue)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
