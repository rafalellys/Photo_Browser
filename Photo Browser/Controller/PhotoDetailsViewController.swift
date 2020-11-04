//
//  PhotoDetailsViewController.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: BaseViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var datePublishedLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var instagramLogo: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var findMeLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var instagramProfileLabel: UILabel!
    @IBOutlet weak var likesImageView: UIImageView!
    @IBOutlet weak var socialMediaContainer: UIView!
    @IBOutlet weak var photoContainerHeight: NSLayoutConstraint!
    
    var photoModel: Model?
    
    lazy var feedLoader: FeedLoader = {
        let loader = FeedLoader(client: NetworkManager())
        return loader
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoadingIndicator()
        setupUI()
        
        usernameLabel.text = photoModel?.user?.username
        descriptionLabel.text = photoModel?.description ?? photoModel?.altDescription
        bioLabel.text = photoModel?.user?.bio
        
        if let instagramProfile = photoModel?.user?.instagramUsername {
            instagramProfileLabel.text = "@" + instagramProfile
        } else {
            socialMediaContainer.isHidden = true
        }
        
        
        if let likes = photoModel?.likes {
            likesCountLabel.text = "\(String(describing: likes))"
        }
        
        if let validDate = photoModel?.createdAt {
            datePublishedLabel.text = UtilityMethods.makeDateWithReadableMonth(dateTobeConverted: validDate)
        }
        
        if let photoURLString = photoModel?.urls?.full {
            
            feedLoader.downloadImageData(imageURLString: photoURLString) { [weak self] (success, imgData) in
                guard let self = self else {return}
                if success {
                    if let imageData = imgData, let img = UIImage(data: imageData as Data) {
                        DispatchQueue.main.async {
                            let ratio = img.size.width / img.size.height
                            let newHeight = self.photoImageView.frame.width / ratio
                            
                            self.photoContainerHeight.constant = newHeight
                            self.photoImageView.image = img.renderWith(newSize: CGSize(width: self.photoImageView.frame.width, height: newHeight))
                            self.hideLoadingIndicator()
                        }
                    }
                } else {
                    debugPrint("image fetch failed")
                    self.photoImageView.image = UIImage(named:"placeholder")
                    self.hideLoadingIndicator()
                }
            }
        }
        
        if let userPhotoURLString = photoModel?.user?.profileImage?.medium {
            feedLoader.downloadImageData(imageURLString: userPhotoURLString) {(success, imgData) in
                if success {
                    if let imageData = imgData, let img = UIImage(data: imageData as Data) {
                        DispatchQueue.main.async {
                            self.userProfileImageView.image = img
                        }
                    }
                } else {
                    debugPrint("image fetch failed")
                    self.userProfileImageView.image = UIImage(named: "placeholder")
                }
            }
        }
    }
    
    func setupUI(){
        navigationItem.largeTitleDisplayMode = .never
        
        datePublishedLabel.textColor = .lightGray
        datePublishedLabel.font = AppFonts.RalewayRegular.of(size: Size.h5.rawValue)
        
        descriptionLabel.textColor = .darkGray
        descriptionLabel.font = AppFonts.RalewayRegular.of(size: Size.h4.rawValue)
        
        likesImageView.tintColor = .darkGray
        
        usernameLabel.textColor = .darkGray
        usernameLabel.font = AppFonts.RalewayRegular.of(size: Size.h4.rawValue)
        
        bioLabel.textColor = .lightGray
        bioLabel.font = AppFonts.RalewayRegular.of(size: Size.h5.rawValue)
        
        
        instagramProfileLabel.textColor = .lightGray
        instagramProfileLabel.font = AppFonts.RalewayRegular.of(size: Size.h5.rawValue)
        
        findMeLabel.textColor = .darkGray
        findMeLabel.font = AppFonts.RalewayRegular.of(size: Size.h5.rawValue)
        
        
        likesCountLabel.textColor = .darkGray
        likesCountLabel.font = AppFonts.RalewayRegular.of(size: Size.h5.rawValue)
        
        
        likesImageView.image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
    }
}
