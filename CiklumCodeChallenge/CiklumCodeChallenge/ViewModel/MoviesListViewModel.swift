//
//  MoviesListViewModel.swift
//  CiklumCodeChallenge
//
//  Created by Jalal Khan on 24/11/2019.
//  Copyright © 2019 Jalal Khan. All rights reserved.
//

import Foundation
import UIKit

class MoviesListViewModel {
    
    var controller: MoviesListViewController?
    var apiManager = APIManager.shared


    func getMoviesList(){

        self.apiManager.getMoviesData(self.controller?.pageNumber ?? 1, searchString: self.controller?.searchString ?? "", completion: { (isSuccessful, errorMessage, arrUsers) in

            if isSuccessful{
                
                if (arrUsers?.count)! > 0{
                    
                    if !(self.controller?.searchedMoviesList.contains(self.controller?.searchString ?? "") ?? false){
                        self.controller?.searchedMoviesList.insert(self.controller!.searchString, at: 0)
                    }
                    
                    if (self.controller?.searchedMoviesList.count)! > 10{
                        self.controller?.searchedMoviesList.removeLast()
                    }
                    
                    if self.controller?.pageNumber == 1{
                        self.controller?.tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
                    }else{
                        self.controller?.tableView.es.stopLoadingMore()
                    }
                    self.controller?.dataArray += arrUsers!
                    self.controller?.tableView.reloadData()
                }else{
                    self.controller?.tableView.es.noticeNoMoreData()

                    if self.controller?.pageNumber == 1{
                        self.controller?.tableView.es.resetNoMoreData()
                        self.controller?.showAlertController("Error!", message: "No data found")
                    }
                }
            }
            else{
                self.controller?.showAlertController("Error!", message: errorMessage ?? "Some error occured")
            }
        })
    }
}
