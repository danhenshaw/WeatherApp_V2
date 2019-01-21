//
//  HourlyOrDailyForecastView.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 16/1/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import UIKit

protocol HourlyOrDailyForecastCellActionDelegate: class {
    func showSelectedForecastDetails(forecastSection: ForecastSection, index: Int)
}

class HourlyOrDailyForecastCell: UITableViewCell {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collection.isPagingEnabled = false
        collection.bounces = true
        collection.backgroundColor = .clear
        collection.allowsSelection = true
        collection.allowsMultipleSelection = false
        return collection
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        button.layer.cornerRadius = 8
        return button
    }()
    
    weak var actionDelegate: HourlyOrDailyForecastCellActionDelegate?
    fileprivate var forecastSection : ForecastSection = .daily
    
    var dailySectionData: [HourlyOrDailyForecastCellItem]?
    var hourlySectionData: [HourlyOrDailyForecastCellItem]?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupConstraints()
    }
    
    
    func setupView() {
        addSubview(collectionView)
        addSubview(button)
        button.isHidden = true
        let language = GlobalVariables.sharedInstance.language
        let translatedTitle = Translator().getString(forLanguage: language, string: "hourly").uppercased()
        button.setTitle(translatedTitle, for: .normal)
    }
    
    func setupConstraints() {
        
        button.anchor(top: nil, leading: nil, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: -8, right: -8), size: .init(width: 80, height: 25))
        
        collectionView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: button.topAnchor, trailing: self.trailingAnchor, padding: .init(top: 8, left: 8, bottom: -4, right: -8), size: .init(width: 0, height: 0))
        
    }
    
    @objc func buttonTapped() {
        let language = GlobalVariables.sharedInstance.language
        var buttonTitle = "daily"
        
        if forecastSection == .daily {
            forecastSection = .hourly
            buttonTitle = "daily"
        } else {
            forecastSection = .daily
            buttonTitle = "hourly"
        }
        let translatedTitle = Translator().getString(forLanguage: language, string: buttonTitle).uppercased()
        button.setTitle(translatedTitle, for: .normal)
        collectionView.reloadData()
    }
    
}



extension HourlyOrDailyForecastCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if forecastSection == .daily {
            return dailySectionData?.count ?? 0
        } else {
            return hourlySectionData?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        actionDelegate?.showSelectedForecastDetails(forecastSection: forecastSection, index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var itemSize = CGSize()
        
        if forecastSection == .daily {
            itemSize = CGSize(width: (collectionView.frame.size.width) / 8, height: collectionView.frame.size.height)
        } else {
            itemSize = CGSize(width: (collectionView.frame.size.width) / 8.5, height: collectionView.frame.size.height)
        }
        
        return itemSize
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell!
        
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? CollectionViewCell
        
        if forecastSection == .daily && dailySectionData != nil {
            button.isHidden = false
            let cellData = dailySectionData![indexPath.row]
            collectionViewCell?.bindWith(cellData)
            collectionViewCell?.configFor(cellData)
        } else if forecastSection == .hourly && hourlySectionData != nil {
            button.isHidden = false
            let cellData = hourlySectionData![indexPath.row]
            collectionViewCell?.bindWith(cellData)
            collectionViewCell?.configFor(cellData)
        }
        
        cell = collectionViewCell
        cell.backgroundColor = .clear
        
        return cell
    }
    
    
}
