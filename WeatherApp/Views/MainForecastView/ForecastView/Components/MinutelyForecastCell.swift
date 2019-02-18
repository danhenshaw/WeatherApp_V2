//
//  MinutelyForecastCell.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 18/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

struct MinutelyForecastCellItem {
    let summary: String
    let cityName: String
    let barHeight: [Double]?
    let minutelyForecastAvailable: Bool
    let section: ForecastSection
}


class MinutelyForecastCell: UITableViewCell {
    
    lazy var stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.distribution = .fill
        stackview.axis = .horizontal
        return stackview
    }()
    
    lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.customFont(size: .medium, colour: .white, alignment: .center, weight: .light, fontName: .system, multiplier: GlobalVariables.sharedInstance.fontSizemultiplier)
        label.numberOfLines = 0
        return label
    }()
    
    
    lazy var chartView: PrecipChartBackgroundView = {
        let background = PrecipChartBackgroundView()
        return background
    }()

    
    
    var willPrecipInNext60mins = false
    var summaryString = ""
    var minutelyForecastUnavailable = ""
    
    var showSummaryLabel = true { didSet {
        if showSummaryLabel {
            summaryLabel.isHidden = false
            summaryLabel.text = summaryString
            chartView.isHidden = true
        } else if !showSummaryLabel && !willPrecipInNext60mins {
            summaryLabel.isHidden = false
            summaryLabel.text = minutelyForecastUnavailable
            chartView.isHidden = true
        } else if !showSummaryLabel && willPrecipInNext60mins {
            summaryLabel.isHidden = true
            chartView.isHidden = false
        }
        }}
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    override func layoutSubviews() {
        setupConstraints()
    }
    
    
    func setupView() {
        stackView.addArrangedSubview(summaryLabel)
        stackView.addArrangedSubview(chartView)
        addSubview(stackView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    func setupConstraints() {
        stackView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 4, left: 24, bottom: -4, right: -24), size: .init(width: 0, height: 0))
    }
    
    @objc func viewTapped() {
        if summaryString != "" {
            showSummaryLabel = !showSummaryLabel
        }
    }
    
    
    
    func bindWith(_ cellData: MinutelyForecastCellItem) {
        
        summaryString = cellData.summary
        showSummaryLabel = true
        
        if cellData.minutelyForecastAvailable {
            minutelyForecastUnavailable = NSLocalizedString("No precipatation forecasted for the next 60 mins", comment: "")
        } else {
            minutelyForecastUnavailable = NSLocalizedString("Minutely forecast unavailable for", comment: "") + " \(cellData.cityName)"
        }
        
        let itemCount = cellData.barHeight?.count ?? 0
        
        for index in 0 ..< itemCount {
            if cellData.barHeight?[index] != 0 {
                willPrecipInNext60mins = true
                showSummaryLabel = false
            }
            chartView.bars[index].height(constant: CGFloat(Double(chartView.barStackView.frame.size.height) * Double(cellData.barHeight?[index] ?? 0)))
        }
        
        if cellData.section != .currently {
            showSummaryLabel = true
        }
        
        chartView.layoutIfNeeded()
        chartView.layoutSubviews()

    }

    
}
