//
//  AdditionalView.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 03.09.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class AdditionalView: UIView {
    var viewModel: AdditionalViewModel?
    
    lazy var itemName = UILabel()
    lazy var itemDescription = UILabel()
    
    override func didMoveToSuperview() {
        setupLabels()
        setupLayout()
    }
}

extension AdditionalView {
    func setup(with viewModel: AdditionalViewModel) {
        self.viewModel = viewModel
        update()
        setNeedsLayout()
    }
    
    func update() {
        self.itemName.text = self.viewModel?.itemName
        self.itemDescription.text = self.viewModel?.itemDescription
    }

    private func setupLayout() {
        self.addSubview(itemDescription)
        itemDescription.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom)
            make.leading.equalTo(16)
        }
        
        self.addSubview(itemName)
        itemName.snp.makeConstraints { make in
            make.bottom.equalTo(itemDescription.snp.top)
            make.leading.equalTo(15)
        }
    }
    
    private func setupLabels() {
        itemName.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        itemName.font = .systemFont(ofSize: 18)
        
        itemDescription.textColor = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1215686275, alpha: 1)
        itemDescription.font = .boldSystemFont(ofSize: 18)
    }
}
