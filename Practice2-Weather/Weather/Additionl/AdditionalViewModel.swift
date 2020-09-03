//
//  AdditionalViewModel.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 03.09.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import Foundation

class AdditionalViewModel {
    var itemName: String = "-"
    var itemDescription: String = "-"
    
    func update(itemName: String, itemDescription: String) {
        self.itemName = itemName
        self.itemDescription = itemDescription
    }
}
