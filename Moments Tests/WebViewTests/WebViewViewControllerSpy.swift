//
//  WebViewViewControllerSpy.swift
//  Moments Tests
//
//  Created by Alexey Ponomarev on 18.11.2023.
//

import Moments
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: Moments.WebViewPresenterProtocol?
    var loadRequestCalled = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) { 
    }
    
    func setProgressHidden(_ isHidden: Bool) {
    }
    
    
}
