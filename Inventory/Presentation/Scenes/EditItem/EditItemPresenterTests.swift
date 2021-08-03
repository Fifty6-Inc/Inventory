//
//  EditItemPresenterTests.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import XCTest
@testable import Inventory

class EditItemPresenterTests: XCTestCase {
    
    // System under test
    var presenter: EditItem.Presenter!
    
    // MARK: - Test
    
    func testPresentSomething() throws {
        // Call presentSomething() on the presenter.
        // Then assert that the state of presenter.viewModel
        // matches your expectations
    }
    
    func testPresentDefaultError() throws {
        // When
        presenter.presentDefaultError()
        
        // Then
        XCTAssertEqual(presenter.viewModel.error?.title, DisplayError.default.title)
        XCTAssertEqual(presenter.viewModel.error?.body, DisplayError.default.body)
        XCTAssertEqual(presenter.viewModel.error?.dismissButtonTitle, DisplayError.default.dismissButtonTitle)
    }
    
    // MARK: - Setup
    
    override func setUp() {
        presenter = .init()
    }
}
