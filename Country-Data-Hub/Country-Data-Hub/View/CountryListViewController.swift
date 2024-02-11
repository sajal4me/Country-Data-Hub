//
//  CountryListViewController.swift
//  Country-Data-Hub
//
//  Created by Sajal Gupta on 07/02/24.
//

import UIKit
import Combine

final class CountryListViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
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
    private var searchSubject = CurrentValueSubject<String, Never>("")
    private var poupulationFilterSubject = CurrentValueSubject<PopulationFilter?, Never>(nil)
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: String(describing: CountryTableViewCell.self))
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()
    
    init(viewModel: CountryListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, renamed: "init(viewModel:)")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = UIView()
        
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        tableView.addSubview(activityIndicatorView)
       
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            activityIndicatorView.centerXAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.centerYAnchor)
        ])
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        configureSearchBar()
        setupDataSource()
        bindUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchViewController.searchResultsUpdater = self
        
        navigationItem.searchController = searchViewController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
        activityIndicatorView.startAnimating()
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
        print("sender click")
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

        let input = CountryListViewModel
            .Input(
                searchBarText: searchSubject.eraseToAnyPublisher(),
                populationFilter: poupulationFilterSubject.eraseToAnyPublisher()
            )
        
        let output = viewModel.transform(input: input)
        
        output
            .title
            .sink(receiveValue: { [weak self] title in
                self?.title = title
            })
            .store(in: &cancellables)
        
        output
            .countryList
            .sink(receiveValue: applySnapshot)
            .store(in: &cancellables)
        
        output
            .filteredCountryList
            .sink(receiveValue: { [weak self] filteredList in
                if let controller = self?.searchViewController.searchResultsController as? SearchResultsViewController {
                    controller.countryList = filteredList
                }
            })
            .store(in: &cancellables)
    }
    
    private func applySnapshot(_ models: [CountryModel]) {
        self.activityIndicatorView.stopAnimating()
        var snapshot = NSDiffableDataSourceSnapshot<Section, CountryModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(models)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension CountryListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.searchSubject.value = searchController.searchBar.text ?? ""
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        presentPopulationFilter()
    }
    
    private func presentPopulationFilter() {
        let alertController = UIAlertController(title: "Population", message: "Filter Population based on the Selcted Field", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: PopulationFilter.lessThan1Million.stringValue, style: .default, handler: { action in
            self.poupulationFilterSubject.value = PopulationFilter.lessThan10Million
        }))
        
        alertController.addAction(UIAlertAction(title: PopulationFilter.lessThan5Million.stringValue, style: .default, handler: { action in
            self.poupulationFilterSubject.value = .lessThan5Million
        }))
        
        alertController.addAction(UIAlertAction(title: PopulationFilter.lessThan10Million.stringValue, style: .default, handler: { action in
            self.poupulationFilterSubject.value = .lessThan10Million
        }))
        
        alertController.addAction(UIAlertAction(title: "Reset", style: .cancel, handler: { action in
            self.poupulationFilterSubject.value = nil
            alertController.dismiss(animated: true)
        }))
        
        self.present(alertController, animated: true)
    }
}
