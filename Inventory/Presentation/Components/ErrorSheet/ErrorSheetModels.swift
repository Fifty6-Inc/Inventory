//
//  ErrorSheetModels.swift
//  Elements
//
//  Created by Mikael Weiss on 5/12/21.
//  Copyright © 2021 Elements Advisors, LLC. All rights reserved.
//

import Foundation

extension ErrorSheet {
    struct ViewModel {
        let title: String
        let body: String
        let dismissButtonTitle: String
    }
}

extension ErrorSheet.ViewModel {
    static let `default` = ErrorSheet.ViewModel(
        title: "Something bad happened",
        body: "Something bad happened, and we're not exactly sure what. If the issue persists, please contact support.",
        dismissButtonTitle: "Okay")
    static let saveFailed = ErrorSheet.ViewModel(
        title: "Something bad happened",
        body: "Something bad happened, and we're not exactly sure what. If the issue persists, please contact support.",
        dismissButtonTitle: "Okay")
}
