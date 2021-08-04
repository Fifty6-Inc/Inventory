//
//  ViewProjectsOverviewInteractorTests.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import XCTest
@testable import Inventory

class ViewProjectsOverviewInteractorTests: XCTestCase {
    
    // System under test
    var interactor: ViewProjectsOverview.Interactor!
    
    // Dependencies
    var serviceDouble: ServiceDouble!
    var presenterDouble: PresenterDouble!
    var routerDouble: RouterDouble!
    
    // MARK: - Test
    
    func testDismiss() {
        // When
        interactor.dismiss()
        
        // Then
        XCTAssertEqual(routerDouble.routeToPreviousCalled, true)
    }
    
    func testCreateDefaultError() {
        // When
        interactor.createDefaultError()
        
        // Then
        XCTAssertEqual(presenterDouble.presentDefaultErrorCalled, true)
    }
    
    // MARK: - Setup
    
    override func setUp() {
        serviceDouble = ServiceDouble()
        presenterDouble = PresenterDouble()
        routerDouble = RouterDouble()
        interactor = .init(
            service: serviceDouble,
            presenter: presenterDouble,
            router: routerDouble)
    }
    
    // MARK: - Helpers
    
    // MARK: - Doubles
    
    class ServiceDouble: ViewProjectsOverviewService {
        
    }
    
    class PresenterDouble: ViewProjectsOverviewPresenting {
        var presentErrorCalled: Bool?
        var presentDefaultErrorCalled: Bool?
        
        func present(error: ViewProjectsOverview.ServiceError) {
            presentErrorCalled = true
        }
        
        func presentDefaultError() {
            presentDefaultErrorCalled = true
        }
    }
    
    class RouterDouble: ViewProjectsOverviewRouting {
        var routeToPreviousCalled: Bool?
        
        func routeToPrevious() {
            routeToPreviousCalled = true
        }
    }
}
