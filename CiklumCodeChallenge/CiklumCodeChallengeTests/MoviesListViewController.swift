//
//  MoviesListViewController.swift
//  CiklumCodeChallengeTests
//
//  Created by Jalal Khan on 24/11/2019.
//  Copyright © 2019 Jalal Khan. All rights reserved.
//

import XCTest
@testable import CiklumCodeChallenge

class MoviesListViewControllerTests: XCTestCase {

    var mainViewController:MoviesListViewController!

    override func setUp() {
        super.setUp()

        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        mainViewController = storyboard.instantiateViewController(withIdentifier: "MoviesListViewController") as? MoviesListViewController
        _ = mainViewController.view
    
        mainViewController.searchString = "Joker"
        mainViewController.viewModel.getMoviesList()
    }
    
    func testTableViewIsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(mainViewController.tableView)
    }
    
    func testShouldSetTableViewDataSource() {
        XCTAssertNotNil(mainViewController.tableView.dataSource)
    }
    
    func testShouldSetTableViewDelegate() {
        XCTAssertNotNil(mainViewController.tableView.delegate)
    }
    
    func testConformsToTableViewDataSourceProtocol() {
        
        XCTAssert(mainViewController.conforms(to: UITableViewDataSource.self))
        XCTAssert(mainViewController.responds(to: #selector(mainViewController.tableView(_:numberOfRowsInSection:))))
        XCTAssert(mainViewController.responds(to: #selector(mainViewController.tableView(_:cellForRowAt:))))
    }
    
    func testTableViewUsesCustomCell_TableViewCustomCell() {
        
        if mainViewController.dataArray.count > 0{
            if mainViewController.isCellTypeMovie == true{
                let firstCell = mainViewController.tableView(mainViewController.tableView, cellForRowAt: IndexPath.init(row: 0, section: 0))
                XCTAssert(firstCell is MoviesTableViewCell)
            }else{
                let firstCell = mainViewController.tableView(mainViewController.tableView, cellForRowAt: IndexPath.init(row: 0, section: 0))
                XCTAssert(firstCell is MoviesSuggestionTableViewCell)
            }
        }

    }
    
    func testConformsToTableViewDelegateProtocol() {
        
        XCTAssert(mainViewController.conforms(to: UITableViewDelegate.self))
        XCTAssert(mainViewController.responds(to: #selector(mainViewController.tableView(_:didSelectRowAt:))))
    }

}
