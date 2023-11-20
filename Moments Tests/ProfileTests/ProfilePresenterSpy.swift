//
//  ProfilePresenterSpy.swift
//  Moments Tests
//
//  Created by Alexey Ponomarev on 18.11.2023.
//

import Moments
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: Moments.ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var logOutCalled: Bool = false
    var updateAvatarCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func logOut() {
        logOutCalled = true
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
}
