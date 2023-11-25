//
//  ProfilePresenter.swift
//  Moments
//
//  Created by Alexey Ponomarev on 18.11.2023.
//

import UIKit

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func logOut()
    func updateAvatar()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    private enum Constants {
        static let avatarPlaceholderName: String = "avatar-placeholder"
    }
    var view: ProfileViewControllerProtocol?
    private let profileServise = ProfileService.shared
    
    func viewDidLoad() {
        updateProfileDetails()
    }
    
    func logOut() {
        OAuth2TokenStorage().token = nil
        LogOutService.clean()
        ImagesListService.shared.resetPhotos()
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Something went wrong")
            return
        }
        
        view?.logOut(window: window)
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL),
            let placeholder = UIImage(named: Constants.avatarPlaceholderName)
        else { return }

        view?.updateAvatar(url: url, placeholder: placeholder)
    }
    
    func updateProfileDetails() {
        view?.updateProfileDetails(profile: profileServise.profile)
    }
    
    
}
