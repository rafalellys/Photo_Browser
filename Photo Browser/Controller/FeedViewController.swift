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
    
    var photos = [Model]()
    
    lazy var feedLoader: FeedLoader = {
        let loader = FeedLoader(client: NetworkManager())
        return loader
    }()

    lazy var flowLayout: FeedCollectionViewFlowLayout = {
        let layout = FeedCollectionViewFlowLayout()
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        feedCollectionView.delegate = self
        feedCollectionView.dataSource = self
        
        feedCollectionView.register(UINib.init(nibName: String(describing: LatestCollectionViewCell.self), bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: LatestCollectionViewCell.self))
        
        feedCollectionView.collectionViewLayout = flowLayout
        flowLayout.scrollDirection = .vertical
        
        feedCollectionView.register(UINib.init(nibName: String(describing: FeedPopularSectionCell.self), bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: FeedPopularSectionCell.self))
        
        feedCollectionView.register(UINib(nibName: String(describing: FeedSectionHeaderView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FeedSectionHeaderView")
        
        feedLoader.loadLatest (completion: { success, data in
            if success {
                self.photos = data
                DispatchQueue.main.async {
                    self.feedCollectionView.reloadData()
                }
            } else {
                debugPrint("failure fetching")
            }
        })
    }
}


extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: feedCollectionView.frame.size.width, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        var insets = UIEdgeInsets()
        
        switch section {
        case 0:
            insets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        case 1:
            insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            
        default: break
            
        }
        
        return insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize = CGSize()
        
        switch indexPath.section {
        case 0:
            cellSize = CGSize(width: feedCollectionView.frame.size.width, height: 178)
            
        case 1:
            let cellSide = feedCollectionView.frame.size.width/5
            
            cellSize = CGSize(width: cellSide, height: cellSide)
            
        default: break
            
        }
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var numberOfItems = Int()
        
        switch section {
        case 0:
            //popular photos collectionView inside
            numberOfItems = 1
        case 1:
            //latest photos
            numberOfItems = photos.count
            
        default: break
            
        }
        
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind:UICollectionView.elementKindSectionHeader,withReuseIdentifier: "\(FeedSectionHeaderView.self)",for: indexPath) as? FeedSectionHeaderView else {
            fatalError("Invalid view type")
        }
        
        
        switch indexPath.section {
        case 0:
            headerView.setupLabelsUI(labelTitle: "Popular today", labelColor: .darkGray, labelFont: AppFonts.RalewayBold.of(size: Size.h3.rawValue) ?? UIFont.systemFont(ofSize: 16))
            
        case 1:
            headerView.setupLabelsUI(labelTitle: "Latest photos", labelColor: .darkGray, labelFont: AppFonts.RalewayRegular.of(size: Size.h4.rawValue) ?? UIFont.systemFont(ofSize: 15))
            
        default: break
            
        }
        
        return headerView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedPopularSectionCell", for: indexPath) as! FeedPopularSectionCell
            
            //data source logic and layout inside FeedPopularSectionCell
            cell.delegate = self
            
            return cell
            
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestCollectionViewCell", for: indexPath) as! LatestCollectionViewCell
            
            cell.feedCellImageView.image = UIImage(named:"placeholder")
            
            let photoRow = self.photos[indexPath.row]
            
            if let thumb = photoRow.urls?.thumb {
                
                feedLoader.downloadImageData(imageURLString: thumb) {(success, imgData) in
                    if success {
                        DispatchQueue.main.async {
                            if let imageData = imgData, let img = UIImage(data: imageData as Data) {
                                    cell.feedCellImageView.image = img
                                    cell.contentMode = .scaleAspectFill
                            } else {
                                cell.feedCellImageView.image = UIImage(named:"placeholder")
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


extension FeedViewController: FeedPopularSectionCellDelegate {
    
    func itemSelected(photo: Model) {
        segueToPhotoDetails(photo: photo)
    }
}
