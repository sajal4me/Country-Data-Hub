//
//  MainCoordinator.swift
//  Country-Data-Hub
//
//  Created by Sajal Gupta on 07/02/24.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }

    func start()
}

final class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController
   
    func start() {
        makeCountryListViewControllerFactory()
    }
   
    init() {
        navigationController = UINavigationController()
    }
    
    private func makeCountryListViewControllerFactory() {
       
        let viewModel = makeCountryListViewModel()
        let viewController = CountryListViewController(viewModel: viewModel)
        navigationController = UINavigationController(rootViewController: viewController)
    }
    
    private func makeCountryListViewModel() -> CountryListViewModel {
        CountryListViewModel()
    }
    
}
