//
//  FeedPopularSectionCell.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-25.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit


protocol FeedPopularSectionCellDelegate: class {
    func itemSelected(photo: Model)
}

class FeedPopularSectionCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var popularCollectionView: UICollectionView!
    
    let flowLayout = CenteredFlowLayout()
    var popularPhotos = [Model]()
    public weak var delegate: FeedPopularSectionCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        popularCollectionView.register(UINib.init(nibName: String(describing: PopularCollectionViewCell.self), bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: PopularCollectionViewCell.self))
        
        popularCollectionView.delegate = self
        popularCollectionView.dataSource = self
        
        popularCollectionView.collectionViewLayout = flowLayout
        flowLayout.scrollDirection = .horizontal
        
        NetworkManager.sharedInstance.fetchPhotosData(orderBy: "popular") { [weak self] (success, popularPhotos) in
            
            guard let self = self else {return}
            
            if success {
                if let popularPhotos = popularPhotos {
                    self.popularPhotos = popularPhotos
                    DispatchQueue.main.async {
                        self.popularCollectionView.reloadData()
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PopularCollectionViewCell.self), for: indexPath) as! PopularCollectionViewCell
        
        cell.popularPhotoImageView.image = UIImage(named:"placeholder")
        
        let photoRow = self.popularPhotos[indexPath.row]
        
        if let thumb = photoRow.urls?.thumb {
            NetworkManager.sharedInstance.downloadImageData(imageURLString: thumb) {[weak self] (success, imgData) in
                
                guard let _ = self else {return}
                
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.itemSelected(photo:self.popularPhotos[indexPath.row])
    }
}

