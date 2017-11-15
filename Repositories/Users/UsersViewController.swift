//
//  UsersViewController.swift
//  Repositories
//
//  Created by Roland Beke on 15/11/2017.
//  Copyright © 2017 Roland Beke. All rights reserved.
//

import UIKit
import DATASource
import Sync

class UsersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var array: [Any] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "BasicTableViewCell", bundle: nil), forCellReuseIdentifier: "BasicTableViewCell")
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        searchController.searchBar.delegate = self
        searchController.searchBar.text = "apple"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let vc = segue.destination as? ReposViewController
        
        let user = sender as? User
        vc?.user = user
    }
}

extension UsersViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        SearchManager.serchOrgs(with: searchBar.text) { users in
            
            self.array =  users
            self.tableView.reloadData()
        }
    }
}

extension UsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BasicTableViewCell", for: indexPath) as? BasicTableViewCell
            else {
                fatalError("\(BasicTableViewCell.self) not loaded")
        }
        
        let user = self.array[indexPath.row] as? User
        cell.nameLabel.text = user?.login
        return cell
    }
}

extension UsersViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let user = self.array[indexPath.row] as? User
        self.performSegue(withIdentifier: "openRepo", sender: user)
    }
}

