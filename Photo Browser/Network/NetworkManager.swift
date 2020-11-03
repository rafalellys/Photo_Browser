//
//  NetworkManager.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit
import SystemConfiguration

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

public final class NetworkManager {
        
    //MARK: - Endpoints
    private let unsplashBaseEndPoint = "https://api.unsplash.com/photos"
    private let searchEndPoint = "https://api.unsplash.com/search/photos"
    private let numberOfItemsPath = "?per_page=30"
    private let unsplashClientId = "qTK-KmVJTrzaP2yFWMQ3jIh_mQXSziamlezYGWZ7Kvs"
    private let clientIdPath = "?client_id="
    private let searchQueryPath = "?query="
    private let orderByPath = "&order_by="
    
    private let imageDataCache = NSCache<NSString, NSData>()
    
    //MARK: - Completion Handlers
    typealias PhotoAPICompletionHandler = (_ success: Bool, _ responseObject: [Model]?) -> Void
    typealias ImageDataCompletionHandler = (_ success: Bool ,_ imgData: NSData?) -> Void
    
    //MARK: - Photos Data
    func fetchPhotosData(orderBy: String, completion: @escaping PhotoAPICompletionHandler) {
        
        guard let url = URL(string: unsplashBaseEndPoint + numberOfItemsPath + orderByPath + orderBy) else {
            debugPrint(APIMessages.invalidUrl)
            completion(false, nil)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethodTypes.get.rawValue
        
        let headers = [
            "Authorization": "Client-ID \(unsplashClientId)",
            "Content-Type" : "application/json"
        ]
        
        urlRequest.allHTTPHeaderFields = headers
        
        let urlSession = URLSession.shared
        urlRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = urlSession.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                debugPrint(error?.localizedDescription ?? APIMessages.noData)
                completion(false, nil)
                return
            }
            
            guard self.checkHttpResponse(response: response as? HTTPURLResponse) else { return completion(false, nil) }
            
            var allPhotos = [Model]()
            
            do {
                let photoModelsDecoded = try JSONDecoder().decode([Model].self, from: data)
                for eachPhoto in photoModelsDecoded {
                    allPhotos.append(eachPhoto)
                }
                completion(true, allPhotos)
            } catch let jsonError {
                debugPrint(jsonError)
                completion(false, nil)
            }
        }
        task.resume()
        
    }
    
    func fetchPhotosByTerm(searchTerm: String, completion: @escaping PhotoAPICompletionHandler) {
        
        guard let url = URL(string: searchEndPoint + searchQueryPath + searchTerm) else {
            debugPrint(APIMessages.invalidUrl)
            completion(false, nil)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethodTypes.get.rawValue
        
        let headers = [
            "Authorization": "Client-ID \(unsplashClientId)",
            "Content-Type" : "application/json"
        ]
        
        urlRequest.allHTTPHeaderFields = headers
        
        let urlSession = URLSession.shared
        urlRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = urlSession.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                debugPrint(error?.localizedDescription ?? APIMessages.noData)
                completion(false, nil)
                return
            }
            
            guard self.checkHttpResponse(response: response as? HTTPURLResponse) else { return completion(false, nil) }
            
            var filteredResults = [Model]()
            
            do {
                let photoModelsDecoded = try JSONDecoder().decode(SearchResultsModel.self, from: data)
                
                if let photoModelsResults = photoModelsDecoded.results {
                    //array of photo models
                    for eachPhoto in photoModelsResults {
                        filteredResults.append(eachPhoto)
                    }
                }
                
                completion(true, filteredResults)
                
            } catch let jsonError {
                debugPrint(jsonError)
                completion(false, nil)
            }
        }
        task.resume()
        
    }
    
    //MARK: - Image Data
    func downloadImageData(imageURLString: String, completion: @escaping ImageDataCompletionHandler) {
        
        if let cachedImageData = imageDataCache.object(forKey: "Image Data: \(imageURLString)" as NSString) {
            debugPrint("image fetched from cache: \(imageURLString)")
            completion(true, cachedImageData as NSData)
        } else {
            
            guard let url = URL(string: imageURLString) else {
                debugPrint(APIMessages.invalidUrl)
                completion(false, nil)
                return
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethodTypes.get.rawValue
            
            let urlSession = URLSession.shared
            urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
            
            let task = urlSession.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
                guard let data = data, error == nil else {
                    
                    debugPrint(error?.localizedDescription ?? APIMessages.noData)
                    completion(false, nil)
                    return
                }
                
                guard self.checkHttpResponse(response: response as? HTTPURLResponse) else { return completion(false, nil) }
                
                self.imageDataCache.setObject(data as NSData, forKey: "Image Data: \(imageURLString)" as NSString)
                
                debugPrint("image fetched from network: \(imageURLString)")
                
                completion(true, data as NSData)
                
            }
            task.resume()
        }
    }
    
}



extension NetworkManager {
    
    //MARK: HTTP Response Check
    func checkHttpResponse(response: HTTPURLResponse?) -> Bool {
        if let httpResponse = response {
            switch httpResponse.statusCode {
            case 100...199:
                debugPrint("Http Response Status Code: \(httpResponse.statusCode)")
                return true
            case 200...299:
                debugPrint("Http Response Status Code: \(httpResponse.statusCode)")
                return true
            case 300...399:
                debugPrint("Http Response Status Code: \(httpResponse.statusCode)")
                return true
            case 400...499:
                debugPrint("Http Response Status Code: \(httpResponse.statusCode)")
                return false
            case 500...599:
                debugPrint("Http Response Status Code: \(httpResponse.statusCode)")
                return false
            default:
                debugPrint("Status code: \(httpResponse.statusCode)")
                return true
            }
        }
        return true
    }
}

extension NetworkManager {
    
    //MARK: - Enums
    enum APIMessages: String {
        case noData = "No Data"
        case invalidUrl = "Error: cannot create URL"
    }
    
    enum HTTPMethodTypes: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
    }
}
