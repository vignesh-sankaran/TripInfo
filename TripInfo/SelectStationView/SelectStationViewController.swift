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
    
    var loadingAlert: UIAlertController
    var viewModel = SelectStationViewModel()
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        loadingAlert = LoadingAlert.create()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        loadingAlert = LoadingAlert.create()
        super.init(coder: aDecoder)
    }
    
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
            // Start spinner inside of UIAlertController
            
            self.present(loadingAlert, animated: true, completion: nil)
            
            // Hit the network service
            print("Search for \(searchText)")
            
            viewModel.populate(stationName: searchText)
            
            // TODO: Figure out how to pass the UIAlertController into stationListLoaded()
            // Figure out how to pass a second variable 
            NotificationCenter.default.addObserver(self, selector: #selector(stationListLoaded(with:)), name: .stationListPopulated, object: nil)
        }
    }
    
    @objc
    func stationListLoaded(with notification: NSNotification) {
        DispatchQueue.main.async {
            print("ViewModel has successfully loaded!")
            self.loadingAlert.dismiss(animated: false, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: "StationCell") as? SelectStationTableViewCell else { fatalError("SelectStationCell not found in Storyboard!") }
        return tableCell
    }
}
