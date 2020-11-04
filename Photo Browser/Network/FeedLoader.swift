//
//  FeedLoader.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-11-03.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import Foundation


class FeedLoader {
    
    let client: NetworkManager
    
    init(client: NetworkManager) {
        self.client = client
    }
    
    func loadLatest(completion: @escaping (_ success: Bool, _ responseObject: [Model] ) -> Void ){
        client.fetchPhotosData(orderBy: "latest") {(success, photos) in
            if success {
                if let photos = photos {
                    completion(true, photos)
                }
            } else {
                completion(false, [])
                debugPrint("failure fetching")
            }
        }
    }
    
    func loadPopular(completion: @escaping (_ success: Bool, _ responseObject: [Model] ) -> Void ){
        client.fetchPhotosData(orderBy: "popular") {(success, photos) in
            if success {
                if let photos = photos {
                    completion(true, photos)
                }
            } else {
                completion(false, [])
                debugPrint("failure fetching")
            }
        }
    }
    
    func fetchPhotosByTerm(searchTerm: String, completion: @escaping (_ success: Bool, _ responseObject: [Model]) -> Void) {
        client.fetchPhotosByTerm(searchTerm: searchTerm) { (success, filteredResults) in
            if success {
                if let filteredResults = filteredResults {
                    completion(true, filteredResults)
                }
            } else {
                completion(false, [])
                debugPrint("failure fetching")
            }
        }
    }
    
    func downloadImageData(imageURLString: String, completion: @escaping (_ success: Bool ,_ imgData: NSData?) -> Void) {
        client.downloadImageData(imageURLString: imageURLString) { (success, data) in
            if success {
                if let data = data {
                    completion(true, data)
                }
            } else {
                completion(false, nil)
                debugPrint("failure fetching")
            }
        }
    }
}
