//
//  ProfileTests.swift
//  Moments Tests
//
//  Created by Alexey Ponomarev on 18.11.2023.
//

import Foundation

@testable import Moments
import XCTest

final class ProfileTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenterSpy()
        profileViewController.configure(profilePresenter)
        
        _ = profileViewController.view
        
        XCTAssertTrue(profilePresenter.viewDidLoadCalled)
    }
}
