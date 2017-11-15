//
//  ReposViewController.swift
//  Repositories
//
//  Created by Roland Beke on 14/11/2017.
//  Copyright © 2017 Roland Beke. All rights reserved.
//

import UIKit
import DATASource
import Sync

class ReposViewController: UIViewController {

    var userUrlString: String?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let dataStack = DataStack(modelName: "Model")
    private lazy var dataSource: DATASource = {
        
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDRepo")
        request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: true),
                                   NSSortDescriptor(key: "name", ascending: true)]
        
        let dataSource = DATASource(tableView: self.tableView,
                                    cellIdentifier: "ReposTableViewCell",
                                    fetchRequest: request,
                                    mainContext: self.dataStack.mainContext,
                                    configuration: { cell, item, _ in
                                        
                                        guard let cell = cell as? ReposTableViewCell else {
                                            fatalError("\(ReposTableViewCell.self) not loaded")
                                        }
                                        
                                        cell.nameLabel.text = String.bindNilOrEmpty(item.value(forKey: "name"))
                                        cell.descriptionLabel.text = String.bindNilOrEmpty(item.value(forKey: "summary"))
                                        cell.starsCountLabel.text = String.bindNilOrEmpty(item.value(forKey: "starsCount"))
                                        cell.updatedAtLabel.text = String.bindNilOrEmpty(item.value(forKey: "updatedAt"))
                                        
                                        guard let owner = item.value(forKey: "owner") as? CDOwner else { return }
                                        cell.avatarImageView.downloadImage(from: owner.avatarUrl)
        })
        
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.userUrlString = Constants.applesReposUrl
        
        guard let urlString = self.userUrlString else { return }
        self.title = urlString
        
        self.tableView.dataSource = self.dataSource
        
        let sync = SyncManager(dataStack: dataStack)
        sync.checkForRepos(userUrlString: urlString)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let vc = segue.destination as? WKWebViewController
        vc?.urlString = sender as? String
    }
}

extension ReposViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.dataSource.object(indexPath)
        let urlString = item?.value(forKey: "htmlUrl")
        self.performSegue(withIdentifier: "openWebView", sender: urlString)
    }
}
