//
//  MoviesTableViewController.swift
//  TMDb
//
//  Created by Alexander Losikov on 11/16/19.
//  Copyright © 2019 Alexander Losikov. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MoviePreviewCellIdentifier"

class MoviesTableViewController: UITableViewController {
    
    private let tmdb = TMDbSearch()
    private var searchName: String = "" // current search name, to match with response from TMDb
    private var movies: [TMDbMovie] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // logo
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        logo.image = #imageLiteral(resourceName: "logo")
        navigationItem.titleView = logo
        
        // search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.backgroundColor = .white
        searchController.searchBar.tintColor = .tmdbBlue
        
        // remove separtor for empty cells
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
}

// MARK: - TMDb Data source
private extension MoviesTableViewController {
    
    func movie(for indexPath: IndexPath) -> TMDbMovie {
        return movies[indexPath.row]
    }
    
    func search(_ name: String) {
        self.searchName = name
        
        // Clean up the result if search name is empty
        if (name.isEmpty) {
            self.movies = []
            self.tableView?.reloadData()
            return
        }
        
        tmdb.search(for: name) {[weak self] response in
            switch response {
            case .error(let error) :
                // TODO: display error to user
                print("Error: '\(error)'.")
            case .data(let data):
                print("\(data.movies.count) matching '\(data.name)'.")
                
                // response may come when we don't need it already
                if (data.name == self?.searchName) {
                    self?.movies = data.movies
                    self?.tableView?.reloadData()
                }
            }
        }
    }
    
}

// MARK: - UISearchResultsUpdating
extension MoviesTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        search(text)
    }
    
}

// MARK: - Table view data source
extension MoviesTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MoviePreviewCell

        let m = movie(for: indexPath)
        
        cell.title.text = m.title ?? ""
        cell.title.accessibilityIdentifier = "title\(indexPath.row)"
        
        cell.overview.text = m.overview ?? ""
        cell.overview.accessibilityIdentifier = "overview\(indexPath.row)"
        
        if let imageUrl = m.imageUrlString() {
            cell.urlTag = m.posterPath
            cell.poster.loadImageWithUrl(string: imageUrl,
                                         placeholder: #imageLiteral(resourceName: "poster_placeholder"),
                                         startedHandler: {
                                             cell.activityIndicator.startAnimating()
                                         },
                                         completionHandler: {[weak self] image in
                                             let cell = self?.tableView.cellForRow(at: indexPath) as? MoviePreviewCell
                                             if let cell = cell {
                                                 if (cell.urlTag == m.posterPath) {
                                                     cell.activityIndicator.stopAnimating()
                                                     cell.poster.image = image
                                                 }
                                             }
                                         })
        } else {
            cell.poster.image = #imageLiteral(resourceName: "poster_placeholder")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detailsViewController") as? MovieDetailsViewController {
            vc.movie = movie(for: indexPath)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

