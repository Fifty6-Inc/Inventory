//
//  EditProjectInteractorTests.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import XCTest
@testable import Inventory

class EditProjectInteractorTests: XCTestCase {
    
    // System under test
    var interactor: EditProject.Interactor!
    
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
    
    class ServiceDouble: EditProjectService {
        
    }
    
    class PresenterDouble: EditProjectPresenting {
        var presentErrorCalled: Bool?
        var presentDefaultErrorCalled: Bool?
        
        func present(error: EditProject.ServiceError) {
            presentErrorCalled = true
        }
        
        func presentDefaultError() {
            presentDefaultErrorCalled = true
        }
    }
    
    class RouterDouble: EditProjectRouting {
        var routeToPreviousCalled: Bool?
        
        func routeToPrevious() {
            routeToPreviousCalled = true
        }
    }
}
