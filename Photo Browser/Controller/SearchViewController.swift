//
//  SearchViewController.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    var filteredResults: [Model] = []
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPhotos = [Model]()
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by term"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        
        searchResultsTableView.register(UINib.init(nibName: String(describing: SearchResultsTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: SearchResultsTableViewCell.self))
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultsTableViewCell.self), for: indexPath) as! SearchResultsTableViewCell
        
        let photoRow = self.filteredPhotos[indexPath.row]
        
        cell.selectionStyle = .none
        
        if let validDate = photoRow.created_at {
            cell.dateLabel.text = UtilityMethods.makeDateWithReadableMonth(dateTobeConverted: validDate)
        }
        
        cell.usernameLabel.text = photoRow.user?.username
        cell.descriptionLabel.text = photoRow.description
        
        if let thumb = photoRow.urls?.thumb {
            if let photoURL = URL(string: thumb) {
                NetworkManager.sharedInstance.downloadImageData(imageURL: photoURL) { (success, imgData) in
                    DispatchQueue.main.async {
                        if success {
                            if let imageData = imgData {
                                DispatchQueue.main.async {
                                    if let img = UIImage(data: imageData as Data) {
                                        cell.searchCellImageView.image = img
                                        cell.contentMode = .scaleAspectFill
                                    }
                                }
                            }
                        } else {
                            debugPrint("image fetch failed")
                        }
                    }
                }
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let storyboard = UIStoryboard(name: "PhotoDetails", bundle: Bundle.main)
        let photoDetailsVC = storyboard.instantiateViewController(withIdentifier: String(describing: PhotoDetailsViewController.self)) as! PhotoDetailsViewController
        let photoRow = self.filteredPhotos[indexPath.row]
        photoDetailsVC.photoModel = photoRow
        self.navigationController?.pushViewController(photoDetailsVC, animated: true)
    }
    
}

    
extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchTerm = searchController.searchBar.text {
            if searchTerm.count >= 3 {
                NetworkManager.sharedInstance.fetchPhotosByTerm(searchTerm: searchTerm) { [weak self] (success, filteredPhotos) in
                    guard let self = self else {return}
                    if success {
                        if let filteredPhotos = filteredPhotos {
                            self.filteredPhotos = filteredPhotos
                            DispatchQueue.main.async {
                                self.searchResultsTableView.reloadData()
                            }
                        }
                    } else {
                        debugPrint("failure fetching")
                    }
                }
            } else {
                self.filteredPhotos.removeAll()
                DispatchQueue.main.async {
                    self.searchResultsTableView.reloadData()
                }

            }
        }
    }
}
