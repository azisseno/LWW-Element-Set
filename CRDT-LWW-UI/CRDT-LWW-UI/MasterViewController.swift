//
//  MasterViewController.swift
//  CRDT-LWW-UI
//
//  Created by Azis Senoaji Prasetyotomo on 15/01/20.
//  Copyright © 2020 siza. All rights reserved.
//

import UIKit
import CRDTLWWElementSet

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var setCollection = [CRDTLWWSet<String>]()
    var mergedSet = CRDTLWWSet<String>()

    private func _setupView() {
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers.first as? UINavigationController)?.topViewController as? DetailViewController
        }
    }

    override func viewDidLoad() {
        _setupView()
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc private func insertNewObject(_ sender: Any) {
        setCollection.insert(CRDTLWWSet(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func mergeAction(_ sender: Any) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        performSegue(withIdentifier: "showDetail", sender: nil)
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            guard let controller = (segue.destination as! UINavigationController).topViewController as? DetailViewController else { return }
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
            detailViewController = controller

            if let indexPath = tableView.indexPathForSelectedRow {
                let set = setCollection[indexPath.row]
                controller.set = set
            } else {
                mergedSet = CRDTLWWSet<String>()
                for i in setCollection {
                    mergedSet.merge(i)
                }
                controller.isMergePage = true
                controller.set = mergedSet
            }
        }
    }

}

// MARK: - Table View
extension MasterViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setCollection.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let set = setCollection[indexPath.row]
        cell.textLabel?.text = "LWW Element Set"
        cell.detailTextLabel?.text = set.uniqueCode
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            setCollection.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
