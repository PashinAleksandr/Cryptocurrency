//
//  detailsViewInput.swift
//  Cryptocurrency
//
//  Created by APashin on 15/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import Foundation
import Charts

protocol detailsViewInput: UIViewInput {
    func setupInitialState()
    func configure(with coin: Coin)
    func updateFavoriteState(_ isFavorite: Bool)
    func showLoading(_ isLoading: Bool)
    func updateChartData(entries: [ChartDataEntry])
}


