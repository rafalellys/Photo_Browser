//
//  Storyboard+Extension.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-21.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    //MARK: - Storyboards
    
    final class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    final class func feedStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Feed", bundle: Bundle.main)
    }
    
    final class func photoDetailsStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "PhotoDetails", bundle: Bundle.main)
    }
    
    final class func searchStoryboard() -> UIStoryboard {
           return UIStoryboard(name: "Search", bundle: Bundle.main)
       }
    
    
    //MARK: - View Controllers
    
    final class func feedViewController() -> FeedViewController {
        return feedStoryboard().instantiateViewController(withIdentifier: String(describing: FeedViewController.self)) as! FeedViewController
    }
    
    final class func photoDetailsViewController() -> PhotoDetailsViewController {
        return photoDetailsStoryboard().instantiateViewController(withIdentifier: String(describing: PhotoDetailsViewController.self)) as! PhotoDetailsViewController
    }
    
    final class func searchViewController() -> SearchViewController {
        return searchStoryboard().instantiateViewController(withIdentifier: String(describing: SearchViewController.self)) as! SearchViewController
    }

}
