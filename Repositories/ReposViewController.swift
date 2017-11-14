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
    
    let dataStack = DataStack(modelName: "Model")
    lazy var dataSource: DATASource = {
        
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDRepo")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let dataSource = DATASource(tableView: self.tableView,
                                    cellIdentifier: "RepoTableViewCell",
                                    fetchRequest: request,
                                    mainContext: self.dataStack.mainContext,
                                    configuration: { cell, item, _ in
                                        
                                        cell.textLabel?.text = String.bindNilOrEmpty(item.value(forKey: "name"))
        })
        
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self.dataSource
        
        let sync = SyncManager(dataStack: dataStack)
        sync.checkForRepos()
    }
}

extension ReposViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
