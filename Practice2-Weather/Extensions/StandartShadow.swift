//
//  StandartShadow.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 31.08.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    func setStandartShadow() {
        self.shadowColor = UIColor.black.cgColor
        self.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.shadowRadius = 16.0
        self.shadowOpacity = 0.310066
        self.masksToBounds = false
    }
}
