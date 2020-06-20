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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoadingIndicator()
        
        navigationItem.largeTitleDisplayMode = .never
        
        likesImageView.image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
        likesImageView.tintColor = .darkGray
        
        usernameLabel.text = photoModel?.user?.username
        descriptionLabel.text = photoModel?.description ?? photoModel?.alt_description
        
        print(photoModel?.user?.twitter_username)
        
        
        bioLabel.text = photoModel?.user?.bio
        if let instagramProfile = photoModel?.user?.instagram_username {
            instagramProfileLabel.text = "@" + instagramProfile
        } else {
            socialMediaContainer.isHidden = true
        }
        
        
        if let likes = photoModel?.likes {
            likesCountLabel.text = "\(String(describing: likes))"
        }
        
        if let validDate = photoModel?.created_at {
            datePublishedLabel.text = UtilityMethods.makeDateWithReadableMonth(dateTobeConverted: validDate)
        }
        
        guard let photoURLString = photoModel?.urls?.full else {return}
        if let photoURL = URL(string: photoURLString) {
            NetworkManager.sharedInstance.downloadImageData(imageURL: photoURL) { [weak self] (success, imgData) in
                
                guard let self = self else {return}
                
                DispatchQueue.main.async {
                    if success {
                        if let imageData = imgData {
                            print(imageData)
                            DispatchQueue.main.async {
                                if let img = UIImage(data: imageData as Data) {
                                    let ratio = img.size.width / img.size.height
                                    let newHeight = self.photoImageView.frame.width / ratio
                                    self.photoContainerHeight.constant = newHeight
                                    self.photoImageView.image = img
                                }
                                self.hideLoadingIndicator()
                            }
                        }
                    } else {
                        debugPrint("image fetch failed")
                        self.hideLoadingIndicator()
                        
                    }
                }
            }
        }
        
        guard let userPhotoURLString = photoModel?.user?.profileImage?.medium else {return}
        if let userPhotoURL = URL(string: userPhotoURLString) {
            NetworkManager.sharedInstance.downloadImageData(imageURL: userPhotoURL) { [weak self] (success, imgData) in
                
                guard let self = self else {return}
                
                DispatchQueue.main.async {
                    if success {
                        if let imageData = imgData {
                            print(imageData)
                            DispatchQueue.main.async {
                                if let img = UIImage(data: imageData as Data) {
                                    self.userProfileImageView.image = img
                                }
                                
                            }
                        }
                    } else {
                        print("image fetch failed")
                    }
                }
            }
        }
        
    }
    
}
