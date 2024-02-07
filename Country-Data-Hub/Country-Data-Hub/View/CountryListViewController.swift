//
//  CountryListViewController.swift
//  Country-Data-Hub
//
//  Created by Sajal Gupta on 07/02/24.
//

import UIKit

final class CountryListViewController: UIViewController {
    
    private let viewModel: CountryListViewModel
    private var dataSource: UITableViewDiffableDataSource<Section, CountryModel>?
    
    enum Section {
        case main
    }

    private let leftBarButtonLabel: UILabel = {
        let label = UILabel()
        label.text = "WrkSpot"
        return label
    }()
    
    let searchViewController = UISearchController(searchResultsController: SearchResultsViewController())
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: String(describing: CountryTableViewCell.self))
        tableView.allowsSelection = false
        return tableView
    }()
   
    init(viewModel: CountryListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        self.view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Country List"
        
        setupNavigationBar()
        configureSearchBar()
        setupDataSource()
        bindUI()
        viewModel.fetchCountryList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchViewController.searchResultsUpdater = self
        
        navigationItem.searchController = searchViewController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonLabel)
        
        navigationItem.rightBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill"), style: .plain, target: self, action:  #selector(rightButtonAction))
    }
    
    private func configureSearchBar() {
        searchViewController.searchBar.searchTextField.clearButtonMode = .never

        let searchTextField = searchViewController.searchBar.searchTextField
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search by Country", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular), .foregroundColor: UIColor.gray])
        
        searchTextField.font = UIFont.systemFont(ofSize: 14)
        searchTextField.backgroundColor = UIColor(red: 248 / 255.0, green: 248 / 255.0, blue: 248 / 255.0, alpha: 1)
        searchTextField.borderStyle = .none
        searchTextField.layer.borderColor = UIColor.black.withAlphaComponent(0.08).cgColor
        searchTextField.layer.borderWidth = 1.0
        searchTextField.layer.cornerRadius = 8
        
        searchViewController.searchBar.setLeftImage(UIImage(systemName: "text.magnifyingglass"))
        
        searchViewController.searchBar.barTintColor = .clear
        searchViewController.searchBar.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle.fill"), for: .bookmark, state: .normal)
        searchViewController.searchBar.showsBookmarkButton = true
        searchViewController.searchBar.delegate = self
    }

    @objc func rightButtonAction(sender: UIBarButtonItem) {
        print("sender sender clieck")
        // TODO
        // Handle Action
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, model -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CountryTableViewCell.self), for: indexPath) as? CountryTableViewCell
            cell?.populate(with: model)
            return cell
        })
    }
    
    private func bindUI() {
//        if viewModel.state == .loading {
//            
//        }
        viewModel.onSuccess = { [weak self] in
            guard let self = self else { return }
            
            self.updateDataSource(countryList: self.viewModel.country)
        }
        viewModel.onError = { error in
            // TODO
            // Add Error Handling
        }
    }
    
    private func updateDataSource(countryList: [CountryModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CountryModel>()
        
        snapshot.appendSections([.main])
        if case .populationFilterActive(let countryList) = viewModel.state {
            snapshot.appendItems(countryList)
        } else if case .coutryListLoaded(let countryList) = viewModel.state {
            snapshot.appendItems(countryList)
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension CountryListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            let filteredList = viewModel.getCountryList(for: searchText)
            
            self.update(searchController: searchController, countryList: filteredList)
        }
    }
    
    private func update(searchController: UISearchController, countryList: [CountryModel]) {
        if let searchController = searchController.searchResultsController as? SearchResultsViewController {
            searchController.countryList = countryList
        }

    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let alertController = UIAlertController(title: "Population", message: "Filter Population based on the Selcted Field", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: PopulationFilter.lessThan1Million.stringValue, style: .default, handler: { action in
            self.filter(population: .lessThan1Million)
        }))
        
        alertController.addAction(UIAlertAction(title: PopulationFilter.lessThan5Million.stringValue, style: .default, handler: { action in
            self.filter(population: .lessThan5Million)
        }))
        
        alertController.addAction(UIAlertAction(title: PopulationFilter.lessThan10Million.stringValue, style: .default, handler: { action in
            self.filter(population: .lessThan10Million)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in 
            self.viewModel.resetPopulationFilter()
            alertController.dismiss(animated: true)
        }))
        
        self.present(alertController, animated: true)
    }
    
    private func filter(population: PopulationFilter) {
       self.viewModel.getCountryList(for: population)
    }
}
