//
//  DetailViewController.swift
//  CRDT-LWW-UI
//
//  Created by Azis Senoaji Prasetyotomo on 15/01/20.
//  Copyright © 2020 siza. All rights reserved.
//

import UIKit
import CRDTLWWElementSet

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    var set: CRDTLWWSet<String>?
    var isMergePage: Bool = false
    var headerText: String?
    private var allSortedKeys: [String] = []
    
    func configureView() {
        textField.text = ""
        tableView.reloadData()
    }

    func setupView() {
        if isMergePage {
            addButton.isHidden = true
            removeButton.isHidden = true
        }
        tableView.tableFooterView = UIView()
        textField.autocorrectionType = .no
        textField.inputAssistantItem.leadingBarButtonGroups = []
        textField.inputAssistantItem.trailingBarButtonGroups = []
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setDidChange()
        scrollToBottom()
    }

    @IBAction func addAction(_ sender: Any) {
        let text = textField.text!.trimmingCharacters(in: .whitespaces)
        guard text != "" else { return }
        set?.add(CRDTNode(value: text))
        setDidChange()
        scrollToBottom()
    }
    @IBAction func queryAction(_ sender: Any) {
        let value = set?.query(element: textField.text!)
        let title: String = value == nil ? "Data doesn't exist" : "Data exist!"
        let alert = UIAlertController(title: title,
                                      message: value?.value,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func removeAction(_ sender: Any) {
        set?.remove(CRDTNode(value: textField.text!))
        setDidChange()
    }
    
    private func setDidChange() {
        guard let set = set else { return }
        allSortedKeys = set.completedSet.map { $0.key }.sorted()
        configureView()
    }
    
    private func scrollToBottom() {
        guard let count = set?.sortedExistingData.count, count > 0 else { return }
        tableView.scrollToRow(at: IndexPath(row: count - 1, section: 1), at: .bottom, animated: false)
    }
    
}

extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return allSortedKeys.count
        } else {
            return set?.sortedExistingData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if indexPath.section == 0 {
            guard let data = set?.completedSet[allSortedKeys[indexPath.row]] else { return UITableViewCell() }
            cell.textLabel?.text = data.node.value
            cell.detailTextLabel?.text =
                """
                \(data.operation == .addition ? "Addition" : "Deletion")
                \(data.node.timestampDate)
                """
        } else {
            let data = set?.sortedExistingData[indexPath.row]
            cell.textLabel?.text = data?.value
            cell.detailTextLabel?.text = nil
        }

        return cell

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Complete Set" : "Current Existing Data"
    }
    
}
