//
//  CountryListViewController.swift
//  Country-Data-Hub
//
//  Created by Sajal Gupta on 07/02/24.
//

import UIKit

final class CountryListViewController: UIViewController {
    
    private let viewModel: CountryListViewModel
    
    init(viewModel: CountryListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
