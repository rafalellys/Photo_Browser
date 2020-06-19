//
//  NetworkManager.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit
import SystemConfiguration


final class NetworkManager {
    
    //MARK: - Init
    static let sharedInstance = NetworkManager()
    private init() {}
    
    //MARK: - Endpoints
    private let unsplashBaseEndPoint = "https://api.unsplash.com/photos"
    private let numberOfItemsPath = "&per_page=30"
    private let unsplashClientId = "qTK-KmVJTrzaP2yFWMQ3jIh_mQXSziamlezYGWZ7Kvs"
    private let clientIdPath = "?client_id="
    
    let imageDataCache = NSCache<NSString, NSData>()
    
    //MARK: - Completion Handlers
    typealias APIPhotoCompletionHandler = (_ success: Bool, _ responseObject: [Model]?) -> Void
    typealias Parameters = [String: String]
    
    
    //MARK: - Photos Data
    func fetchAllPhotosData(completion: @escaping APIPhotoCompletionHandler) {
        
        guard let url = URL(string: unsplashBaseEndPoint + clientIdPath + unsplashClientId + numberOfItemsPath) else {
            debugPrint(APIMessages.invalidUrl)
            completion(false, nil)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethodTypes.get.rawValue
        
        let postSession = URLSession.shared
        urlRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = postSession.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
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
    
    //MARK: - Image Data
    func downloadImageData(imageURL: URL?, completion: @escaping (_ success: Bool ,_ imgData: NSData?) -> Void) {
        
        guard let url = imageURL else {
            
            debugPrint(APIMessages.invalidUrl)
            completion(false, nil)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethodTypes.get.rawValue
        
        let postSession = URLSession.shared
        urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
        
        let task = postSession.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                
                debugPrint(error?.localizedDescription ?? APIMessages.noData)
                completion(false, nil)
                return
            }
            
            guard self.checkHttpResponse(response: response as? HTTPURLResponse) else { return completion(false, nil) }
            
            if let imgURL = imageURL {
                self.imageDataCache.setObject(data as NSData, forKey: "Image Data: \(imgURL)" as NSString)
            }
            
            completion(true, data as NSData)
            
        }
        task.resume()
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
