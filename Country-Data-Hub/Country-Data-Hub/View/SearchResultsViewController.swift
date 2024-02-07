//
//  SearchResultsViewController.swift
//  Country-Data-Hub
//
//  Created by Sajal Gupta on 08/02/24.
//

import UIKit

final class SearchResultsViewController: UITableViewController {
    
    var countryList = [CountryModel]() {
        didSet {
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: "CountryTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(textSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    @objc func textSizeChanged() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension SearchResultsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell: MovieCell = tableView.dm_dequeueReusableCellWithDefaultIdentifier()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell") as? CountryTableViewCell else {
            fatalError("Undablet to dequeue cell")
        }
        let countryList = countryList[indexPath.row]
        cell.populate(with: countryList)
        
        return cell
    }
    
}

