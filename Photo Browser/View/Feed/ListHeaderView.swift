//
//  ListHeaderView.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit


protocol ListHeaderDelegate: class {
    func itemSelected(photo: Model)
}

class ListHeaderView: UICollectionReusableView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var listHeaderCollectionView: UICollectionView!
    @IBOutlet weak var popularLabel: UILabel!
    @IBOutlet weak var latestLabel: UILabel!
    
    let flowLayout = CenteredFlowLayout()
    var popularPhotos = [Model]()
    public weak var delegate: ListHeaderDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        popularLabel.textColor = .darkGray
        latestLabel.textColor = .darkGray
        
        listHeaderCollectionView.register(UINib.init(nibName: String(describing: FeaturedCollectionViewCell.self), bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: FeaturedCollectionViewCell.self))
        
        listHeaderCollectionView.delegate = self
        listHeaderCollectionView.dataSource = self
        
        listHeaderCollectionView.collectionViewLayout = flowLayout
        flowLayout.scrollDirection = .horizontal
        
        NetworkManager.sharedInstance.fetchAllPhotosData(orderBy: "popular") { [weak self] (success, popularPhotos) in
            
            guard let self = self else {return}
            
            if success {
                if let popularPhotos = popularPhotos {
                    self.popularPhotos = popularPhotos
                    DispatchQueue.main.async {
                        self.listHeaderCollectionView.reloadData()
                    }
                }
            } else {
                debugPrint("failure fetching")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.popularPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FeaturedCollectionViewCell.self), for: indexPath) as! FeaturedCollectionViewCell
        
        let photoRow = self.popularPhotos[indexPath.row]
        
        if let thumb = photoRow.urls?.thumb {
            if let photoURL = URL(string: thumb) {
                NetworkManager.sharedInstance.downloadImageData(imageURL: photoURL) {[weak self] (success, imgData) in
                    
                    guard let _ = self else {return}
                    
                    DispatchQueue.main.async {
                        if success {
                            if let imageData = imgData {
                                DispatchQueue.main.async {
                                    if let img = UIImage(data: imageData as Data) {
                                        cell.popularPhotoImageView.image = img
                                        cell.contentMode = .scaleAspectFill
                                    } else {
                                        cell.popularPhotoImageView.image = UIImage(named:"placeholder")
                                    }
                                }
                            }
                        } else {
                            debugPrint("image fetch failed")
                            cell.popularPhotoImageView.image = UIImage(named:"placeholder")
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.itemSelected(photo:self.popularPhotos[indexPath.row])
       }
}
