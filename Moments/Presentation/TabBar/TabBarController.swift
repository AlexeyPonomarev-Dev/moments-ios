//
//  TabBarController.swift
//  Moments
//
//  Created by Alexey Ponomarev on 21.10.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: Constants.main, bundle: .main)
        let imageListViewController = storyboard.instantiateViewController(withIdentifier: Constants.imageListItentifier) as? ImagesListViewController
        guard let imageListViewController = imageListViewController else { return }
        let imagesListPresenter = ImagesListPresenter()
        imageListViewController.configure(imagesListPresenter)
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter()
        profileViewController.configure(profilePresenter)
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tabbar-profile-icon"),
            selectedImage: UIImage(named: "tabbar-profile-icon-active"))
        
        self.viewControllers = [imageListViewController, profileViewController]
    }
}
