//
//  ErrorSheetModels.swift
//  Inventory
//
//  Created by Mikael Weiss on 5/12/21.
//  Copyright © 2021 Fifty6, Inc. All rights reserved.
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
    static let fetchFailed = ErrorSheet.ViewModel(
        title: "Something bad happened",
        body: "There was an issue fetching this value. If the issue persists, please contact support.",
        dismissButtonTitle: "Okay")
    static let saveFailed = ErrorSheet.ViewModel(
        title: "Something bad happened",
        body: "There was an issue saving this value. If the issue persists, please contact support.",
        dismissButtonTitle: "Okay")
    
    static func `default`(with message: String) -> ErrorSheet.ViewModel {
        ErrorSheet.ViewModel(
            title: "Something bad happened",
            body: message,
            dismissButtonTitle: "Okay")
    }
}
