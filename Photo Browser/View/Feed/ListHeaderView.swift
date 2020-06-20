//
//  ListHeaderView.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit

class ListHeaderView: UICollectionReusableView, UICollectionViewDelegate, UICollectionViewDataSource {
        
    @IBOutlet weak var listHeaderCollectionView: UICollectionView!
    
     let flowLayout = CenteredFlowLayout()

    var popularPhotos = [Model]()

        override func awakeFromNib() {
            super.awakeFromNib()
            
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
            
                
                return cell
            
        }
        
}
