//
//  MoviesListViewController.swift
//  CiklumCodeChallenge
//
//  Created by Jalal Khan on 23/11/2019.
//  Copyright © 2019 Jalal Khan. All rights reserved.
//

import UIKit
import SDWebImage
import ESPullToRefresh

class MoviesListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = MoviesListViewModel()
    var dataArray = [MoviesDataResult]()
    var apiManager = APIManager.shared
    var searchedMoviesList = [String]()
    var pageNumber = 1
    var searchString = ""
    var isCellTypeMovie = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.controller = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView.init(frame: .zero)
        self.searchBar.delegate = self

        self.customizeUI()
    }
    
    func customizeUI(){
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 190
        self.tableView.tableFooterView = UIView.init(frame: .zero)
        self.title = "Movies List"
        
        self.tableView.es.addPullToRefresh {
            [unowned self] in

            self.tableView.es.resetNoMoreData()
            self.pageNumber = 1
            self.dataArray.removeAll()
            self.viewModel.getMoviesList()
        }
        self.tableView.es.addInfiniteScrolling {
            [unowned self] in
            
            self.pageNumber = self.pageNumber + 1
            self.viewModel.getMoviesList()
        }
    }
    
}


extension MoviesListViewController: UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isCellTypeMovie == true{
            return self.dataArray.count
        }else{
            return self.searchedMoviesList.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isCellTypeMovie == true{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell", for: indexPath) as! MoviesTableViewCell
            cell.labelMovieName.text = self.dataArray[indexPath.row].title
            cell.labelMovieReleaseDate.text = self.dataArray[indexPath.row].releaseDate
            cell.labelMovieOverview.text = self.dataArray[indexPath.row].overview
            
            if cell.labelMovieOverview.text?.count == 0{
                cell.labelMovieOverview.text = "No overview found"
            }
            if let imageURL = self.dataArray[indexPath.row].posterPath{
                cell.imagePoster.isUserInteractionEnabled = true
                let urlString = URLs.k_IMAGE_URL + imageURL

                cell.imagePoster.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "Placeholder"),options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
                    cell.imagePoster.isUserInteractionEnabled = false
                })
            }
            cell.layoutIfNeeded()
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesSuggestionTableViewCell", for: indexPath) as! MoviesSuggestionTableViewCell
            cell.labelMovieName.text = self.searchedMoviesList[indexPath.row]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isCellTypeMovie == false{
            self.isCellTypeMovie = true
            self.searchString = self.searchedMoviesList[indexPath.row]
            self.pageNumber = 1
            self.viewModel.getMoviesList()
        }
    }
}

extension MoviesListViewController:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.isCellTypeMovie = true
        
        if searchBar.text?.count == 0 {
            self.showAlertController("Error", message: "Please enter movie name")
        }
        else {
        
            searchBar.resignFirstResponder()
//            showLoadingHUD()
                
            self.searchString = self.searchBar.text ?? ""
            self.viewModel.getMoviesList()
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isCellTypeMovie = false
        self.pageNumber = 1
        self.dataArray.removeAll()
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.tableView.es.noticeNoMoreData()
        self.tableView.es.resetNoMoreData()
    }
    
}
