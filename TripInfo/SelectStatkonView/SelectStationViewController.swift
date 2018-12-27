//
//  ViewController.swift
//  TripInfo
//
//  Created by Vignesh Sankaran on 21/11/18.
//  Copyright © 2018 Vignesh Sankaran. All rights reserved.
//

import UIKit

class SearchStationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Hide the keyboard
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: false)

        if let searchText = searchBar.text {
            // Hit the network service
            print("Search for \(searchText)")
            PTVSearchTrainStationsService().searchStations(stationName: searchText, callback: { (URLString: String) -> () in
                print("URL: \(URLString)")
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: "StationCell") as? SelectStationTableViewCell else { fatalError("SelectStationCell not found in Storyboard!") }
        return tableCell
    }
}
