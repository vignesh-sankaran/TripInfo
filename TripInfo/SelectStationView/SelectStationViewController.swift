//
//  ViewController.swift
//  TripInfo
//
//  Created by Vignesh Sankaran on 21/11/18.
//  Copyright © 2018 Vignesh Sankaran. All rights reserved.
//

import UIKit
import Alamofire

class SearchStationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
    
    var viewModel = SelectStationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
    }
    
    // Credit to ylin0x81 and petesalt. Retrieved 11 Jan 2019 from https://stackoverflow.com/a/27034447/5891072
    func displayLoadingAlert() -> UIAlertController {
        let pending = UIAlertController(title: "Loading...", message: nil, preferredStyle: .alert)
        
        let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        pending.view.addSubview(indicator)
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
 
        return pending
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Hide the keyboard
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: false)

        if let searchText = searchBar.text {
            // Start spinner inside of UIAlertController
            let loadingAlert = displayLoadingAlert()
            self.present(loadingAlert, animated: true, completion: nil)
            
            // Hit the network service
            print("Search for \(searchText)")
            
            viewModel.populate(stationName: searchText)
            
            // Add observer
            
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
