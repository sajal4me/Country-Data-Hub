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
        setupDataSource()
        bindUI()
        viewModel.fetchCountryList()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonLabel)
        //imageView.image = UIImage(systemName: "line.3.horizontal.decrease.circle")
        
        navigationItem.rightBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill"), style: .plain, target: self, action:  #selector(rightButtonAction))
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
        viewModel.onSuccess = { [weak self] in
            guard let self = self else { return }
            
            self.updateDataSource(countryList: self.viewModel.countryList)
        }
        viewModel.onError = { error in
            // TODO
            // Add Error Handling
        }
    }
    
    private func updateDataSource(countryList: [CountryModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CountryModel>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(countryList)
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}
