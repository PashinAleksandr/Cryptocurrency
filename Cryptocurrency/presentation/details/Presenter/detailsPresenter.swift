//
//  detailsPresenter.swift
//  Cryptocurrency
//
//  Created by APashin on 15/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import Foundation

class detailsPresenter: NSObject, detailsModuleInput, detailsViewOutput {

    weak var view: detailsViewInput!
    var interactor: detailsInteractorInput!
    var router: detailsRouterInput!

    func viewIsReady() {
        view.setupInitialState()
    }
}

extension detailsPresenter: detailsInteractorOutput {
}