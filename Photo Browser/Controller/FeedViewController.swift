//
//  FeedViewController.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//


import UIKit

class FeedViewController: UIViewController {
    
    
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    @IBOutlet weak var feedFlowLayout: UICollectionViewFlowLayout!
    
    var photos = [Model]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        feedCollectionView.delegate = self
        feedCollectionView.dataSource = self
        
        feedCollectionView.register(UINib.init(nibName: String(describing: LatestCollectionViewCell.self), bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: LatestCollectionViewCell.self))
        
        feedCollectionView.register(UINib(nibName: String(describing: ListHeaderView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ListHeaderView")
        
        NetworkManager.sharedInstance.fetchPhotosData(orderBy: "latest") { [weak self] (success, photos) in
            
            guard let self = self else {return}
            
            if success {
                if let photos = photos {
                    self.photos = photos
                    DispatchQueue.main.async {
                        self.feedCollectionView.reloadData()
                    }
                }
            } else {
                debugPrint("failure fetching")
            }
        }
    }
}


extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 248)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSide = feedCollectionView.frame.size.width/5
        
        return CGSize(width: cellSide, height: cellSide)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind:UICollectionView.elementKindSectionHeader,withReuseIdentifier: "\(ListHeaderView.self)",for: indexPath) as? ListHeaderView else {
            fatalError("Invalid view type")
        }
        
        headerView.delegate = self
        
        return headerView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestCollectionViewCell", for: indexPath) as! LatestCollectionViewCell
        
        cell.feedCellImageView.image = UIImage(named:"placeholder")
        
        let photoRow = self.photos[indexPath.row]
        
        if let thumb = photoRow.urls?.thumb {
            
            NetworkManager.sharedInstance.downloadImageData(imageURLString: thumb) {[weak self] (success, imgData) in
                
                guard let _ = self else {return}
                
                    if success {
                        if let imageData = imgData {
                            DispatchQueue.main.async {
                                if let img = UIImage(data: imageData as Data) {
                                    cell.feedCellImageView.image = img
                                    cell.contentMode = .scaleAspectFill
                                } else {
                                    cell.feedCellImageView.image = UIImage(named:"placeholder")
                                }
                            }
                        }
                    } else {
                        debugPrint("image fetch failed")
                        cell.feedCellImageView.image = UIImage(named:"placeholder")
                    }
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photoRow = self.photos[indexPath.item]
        segueToPhotoDetails(photo: photoRow)
    }
    
    func segueToPhotoDetails(photo:Model) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let photoDetailsVC = UIStoryboard.photoDetailsViewController()
        photoDetailsVC.photoModel = photo
        navigationController?.pushViewController(photoDetailsVC, animated: true)
        
    }
    
}


extension FeedViewController: ListHeaderDelegate {
    
    func itemSelected(photo: Model) {
        
        segueToPhotoDetails(photo: photo)
        
    }
}
