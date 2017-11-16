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
import ReactiveSwift
import Result

class UsersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private static let cellName = "BasicTableViewCell"
    private static let detailIdentifier = "openRepo"

    var array: MutableProperty<[User]> = MutableProperty([])

    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: UsersViewController.cellName, bundle: nil), forCellReuseIdentifier: UsersViewController.cellName)

        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true

        self.array.producer
            .observe(on: UIScheduler())
            .startWithResult {_ in

                self.tableView.reloadData()
        }

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

        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        self.array <~ SearchManager.createSearchSP(with: searchBar.text)
            .flatMapError({ (_) -> SignalProducer<[User], NoError> in

                return SignalProducer<[User], NoError>.empty
        })
    }
}

extension UsersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.array.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: UsersViewController.cellName, for: indexPath) as? BasicTableViewCell
            else {
                fatalError("\(BasicTableViewCell.self) not loaded")
        }

        let user = self.array.value[indexPath.row]
        cell.nameLabel.text = user.login
        cell.descriptionLabel.text = user.repos
        cell.avatarImageView.image = nil
        cell.avatarImageView.downloadImage(from: user.avatar)

        return cell
    }
}

extension UsersViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let user = self.array.value[indexPath.row]
        self.performSegue(withIdentifier: UsersViewController.detailIdentifier, sender: user)
    }
}
