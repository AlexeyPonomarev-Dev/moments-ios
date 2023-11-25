//
//  ImagesListTests.swift
//  Moments Tests
//
//  Created by Alexey Ponomarev on 18.11.2023.
//

import Foundation

@testable import Moments
import XCTest

final class ImagesListTests: XCTestCase {
    func testImageListCallsViewDidLoad() {
        let imageListViewController = ImagesListViewController()
        let imagesListViewPresenter = ImagesListPresenterSpy()
        imageListViewController.configure(imagesListViewPresenter)
        
        _ = imageListViewController.view
        
        XCTAssertTrue(imagesListViewPresenter.configureImageListCalled)
    }
    
    func testUpdateTableViewAnimated() {
        let imageListViewController = ImagesListViewControllerSpy()
        
        imageListViewController.updateTableViewAnimated(oldCount: 1, newCount: 2)
        
        XCTAssertTrue(imageListViewController.nextPageFetched)
    
    }
}
