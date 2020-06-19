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
    
    @IBOutlet weak var likesImageView: UIImageView!
    
    @IBOutlet weak var photoContainerHeight: NSLayoutConstraint!
    
    var photoModel: Model?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoadingIndicator()
        
        likesImageView.image = UIImage(named: "heart")
        
         usernameLabel.text = photoModel?.user?.username
                
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
