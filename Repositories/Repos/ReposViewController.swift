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
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: User?
    
    private let dataStack = DataStack(modelName: "Model")
    private lazy var dataSource: DATASource = {
        
        guard let user = self.user else {
            fatalError("User \(String(describing: self.user)) not found")
        }
        
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDRepo")
        request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: true),
                                   NSSortDescriptor(key: "fullName", ascending: true)]
        request.predicate = NSPredicate(format: "owner.id = %@", user.id)
        
        let dataSource = DATASource(tableView: self.tableView,
                                    cellIdentifier: "BasicTableViewCell",
                                    fetchRequest: request,
                                    mainContext: self.dataStack.mainContext,
                                    configuration: { cell, item, _ in
                                        
                                        guard let cell = cell as? BasicTableViewCell else {
                                            fatalError("\(BasicTableViewCell.self) not loaded")
                                        }
                                        
                                        cell.nameLabel.text = String.bindNilOrEmpty(item.value(forKey: "fullName"))
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

        guard let user = self.user else {
            fatalError("User \(String(describing: self.user)) not found")
        }
        
        self.tableView.register(UINib(nibName: "BasicTableViewCell", bundle: nil), forCellReuseIdentifier: "BasicTableViewCell")
        self.tableView.dataSource = self.dataSource
        
        self.title = user.repos.replacingOccurrences(of: Constants.api, with: "")
        
        let sync = SyncManager(dataStack: dataStack)
        sync.checkForRepos(user: user)
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
