//
//  ViewController.swift
//  fetchproject_tosin_oyekeye
//
//  Created by Oluwatosin Oyekeye on 10/7/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    var groupedItems: [Int: [Item]] = [:]
    var sortedListIds: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        fetchData()
    }
    
    func fetchData() {
        DataService.shared.fetchItems { [weak self] items in
            guard let items = items else { return }
            
            // Filter items with blank or null names
            let filteredItems = items.filter { $0.name != nil && $0.name != "" }
            
            // Group by listId
            self?.groupedItems = Dictionary(grouping: filteredItems, by: { $0.listId })
            
            // Sort each group
            for (key, value) in self?.groupedItems ?? [:] {
                self?.groupedItems[key] = value.sorted(by: {
                    (item1, item2) -> Bool in
                    let number1 = Int(item1.name?.components(separatedBy: " ").last ?? "") ?? 0
                    let number2 = Int(item2.name?.components(separatedBy: " ").last ?? "") ?? 0
                    return number1 < number2
                })
            }

            
            // Get sorted listIds
            if let keys = self?.groupedItems.keys {
                self?.sortedListIds = Array(keys).sorted()
            } else {
                self?.sortedListIds = []
            }

            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    // UITableViewDataSource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedListIds.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let listId = sortedListIds[section]
        return groupedItems[listId]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "List IDs: \(sortedListIds[section])"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            header.textLabel?.textColor = UIColor.blue
            header.backgroundView?.backgroundColor = UIColor.lightGray
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        let listId = sortedListIds[indexPath.section]
        if let item = groupedItems[listId]?[indexPath.row] {
            cell.textLabel?.text = item.name
            print("Item Name here: \(item.name)")
        } else {
            print("No item found")
        }
        return cell
    }
}


