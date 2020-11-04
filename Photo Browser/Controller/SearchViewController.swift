//
//  SearchViewController.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPhotos = [Model]()
    
    lazy var feedLoader: FeedLoader = {
        let loader = FeedLoader(client: NetworkManager())
        return loader
    }()
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by term"
        searchController.searchBar.searchTextField.font = UIFont(name: "Avenir", size: 15)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
        
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.separatorStyle = .none
        
        searchResultsTableView.estimatedRowHeight = 110
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        searchResultsTableView.register(UINib.init(nibName: String(describing: SearchResultsTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: SearchResultsTableViewCell.self))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultsTableViewCell.self), for: indexPath) as! SearchResultsTableViewCell
        
        cell.searchCellImageView.image = UIImage(named:"placeholder")
        
        let photoRow = self.filteredPhotos[indexPath.row]
        
        cell.selectionStyle = .none
        
        if let validDate = photoRow.createdAt {
            cell.dateLabel.text = UtilityMethods.makeDateWithReadableMonth(dateTobeConverted: validDate)
        }
        
        cell.usernameLabel.text = photoRow.user?.username
        if photoRow.description != nil {
            cell.descriptionLabel.text = photoRow.description
        } else {
            cell.descriptionLabel.text = photoRow.altDescription
        }
        
        if let thumb = photoRow.urls?.thumb {
            feedLoader.downloadImageData(imageURLString: thumb) {(success, imgData) in
                if success {
                    if let imageData = imgData, let img = UIImage(data: imageData as Data) {
                        DispatchQueue.main.async {
                            cell.searchCellImageView.image = img
                            cell.contentMode = .scaleAspectFill
                        }
                    }
                } else {
                    debugPrint("image fetch failed")
                    cell.searchCellImageView.image = UIImage(named:"placeholder")
                }
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let photoRow = self.filteredPhotos[indexPath.row]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let photoDetailsVC = UIStoryboard.photoDetailsViewController()
        photoDetailsVC.photoModel = photoRow
        navigationController?.pushViewController(photoDetailsVC, animated: true)
    }
}


extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pendingRequestWorkItem?.cancel()
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.searchTerm()
        }
        
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: requestWorkItem)
    }
    
    func searchTerm() {
        if let searchTerm = searchController.searchBar.text, searchTerm.count >= 3 {
            if searchTerm.count >= 3 {
                feedLoader.fetchPhotosByTerm(searchTerm: searchTerm) { [weak self] (success, filteredPhotos) in
                    guard let self = self else {return}
                    if success {
                        self.filteredPhotos = filteredPhotos
                        DispatchQueue.main.async {
                            self.animateTable(self.searchResultsTableView)
                        }
                    } else {
                        debugPrint("failure fetching photos data")
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
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchTerm = searchController.searchBar.text, searchTerm.count == 0 {
            self.filteredPhotos.removeAll()
            DispatchQueue.main.async {
                self.searchResultsTableView.reloadData()
            }
        }
    }
}
