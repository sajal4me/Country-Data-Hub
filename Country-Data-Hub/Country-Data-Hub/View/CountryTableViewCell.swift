//
//  CountryTableViewCell.swift
//  Country-Data-Hub
//
//  Created by Sajal Gupta on 07/02/24.
//

import UIKit

final class CountryTableViewCell: UITableViewCell {
    private let posterSize = CGSize(width: 50, height: 60)
    private let countryLabel: UILabel = {
        let countryLabel = UILabel()
        countryLabel.numberOfLines = 2
        countryLabel.font = UIFont.systemFont(ofSize: 14)
        return countryLabel
    }()
    
    private let capitalLabel: UILabel = {
        let capitalLabel = UILabel()
        capitalLabel.textAlignment = .right
        capitalLabel.font = UIFont.systemFont(ofSize: 14)
        return capitalLabel
    }()
    
    private let currencyLabel: UILabel = {
        let currencyLabel = UILabel()
        currencyLabel.textAlignment = .right
        currencyLabel.font = UIFont.systemFont(ofSize: 14)
        return currencyLabel
    }()
    
    private let populationLabel: UILabel = {
        let populationLabel = UILabel()
        populationLabel.textAlignment = .right
        populationLabel.font = UIFont.systemFont(ofSize: 14)
        return populationLabel
    }()
    
    private let countryImageView: UIImageView = {
        let countryImageView = UIImageView()
        countryImageView.contentMode = .scaleAspectFit
        countryImageView.image = UIImage(systemName: "flag.checkered.circle")
        return countryImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addArrangeViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addArrangeViews() {
        let flagStackView = UIStackView(arrangedSubviews: [
            countryImageView,
            countryLabel
        ])
        flagStackView.spacing = 5
        flagStackView.axis = .horizontal
        
        let rightStackView = UIStackView(arrangedSubviews: [
            capitalLabel,
            currencyLabel,
            populationLabel
        ])
        rightStackView.spacing = 5
        rightStackView.axis = .vertical
        rightStackView.distribution = .fillEqually
        
        let mainVStack = UIStackView(arrangedSubviews: [
            flagStackView,
            rightStackView
        ])
        
        mainVStack.axis = .horizontal
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        mainVStack.distribution = .fillProportionally
        addSubview(mainVStack)
        
        NSLayoutConstraint.activate([
            countryImageView.widthAnchor.constraint(equalToConstant: posterSize.width),
            countryImageView.heightAnchor.constraint(equalToConstant: posterSize.height),
            mainVStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            mainVStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mainVStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8),
            mainVStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
        ])
    }
    
    func populate(with model: CountryModel) {
        
        countryImageView.dm_setImage(posterPath: model.media.flag)
        countryLabel.text = model.name
        capitalLabel.text = "Capital: \(model.capital)"
        currencyLabel.text = "Currency: \(model.currency)"
       
        if let population = model.population {
            populationLabel.text = "Population: \(population)"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        countryLabel.text = nil
        capitalLabel.text = nil
        currencyLabel.text = nil
        populationLabel.text = nil
        
        // set placeholder
        countryImageView.image = UIImage(systemName: "flag.checkered.circle")
    }
}

