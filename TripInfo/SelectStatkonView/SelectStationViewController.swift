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
        print("Search for \(searchBar.text!)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell
    }
}
