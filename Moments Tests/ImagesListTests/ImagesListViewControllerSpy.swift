//
//  ImagesListViewControllerSpy.swift
//  Moments Tests
//
//  Created by Alexey Ponomarev on 18.11.2023.
//

import Moments
import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var nextPageFetched: Bool = false

    func configureImageList() {
        
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        if (oldCount < newCount){
            nextPageFetched = true
        }
    }
    
    func showError() {
        
    }
    
    
}
