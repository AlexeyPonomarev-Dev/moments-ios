//
//  ProfileViewController.swift
//  Moments
//
//  Created by Alexey Ponomarev on 09.09.2023.
//

import UIKit
import ProgressHUD
import Kingfisher
import SwiftKeychainWrapper

final class ProfileViewController: UIViewController {
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private enum Sizes {
        static let profileAvatarSize = CGFloat(70)
    }
    
    private lazy var horizontalStack: UIStackView = {
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .equalSpacing
        stack.alignment = .center
        
        return stack
    }()
    
    private lazy var verticalStack = {
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        
        return stack
    }()
    
    private lazy var avatarImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "avatar-placeholder")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Sizes.profileAvatarSize / 2
        
        return imageView
    }()
    
    private lazy var nameLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = UIColor.ypWhite
        
        return label
    }()
    
    private lazy var nikNameLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor.ypGray
        
        return label
    }()
    
    private lazy var descriptionLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor.ypWhite
        
        return label
    }()
    
    private lazy var logoutButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "logout"), for: .normal)
        button.tintColor = UIColor.ypRed
        button.addTarget(
            self, action: #selector(self.didTapedLogoutButton),
            for: UIControl.Event.touchUpInside
        )

        return button
    }()
    
    override func viewDidLoad() {

        horizontalStack.addArrangedSubview(avatarImageView)
        horizontalStack.addArrangedSubview(logoutButton)
    
        verticalStack.addArrangedSubview(nameLabel)
        verticalStack.addArrangedSubview(nikNameLabel)
        verticalStack.addArrangedSubview(descriptionLabel)

        updateProfileDetails()

        setupViewConstraints()
    }
    
    private func setupViewConstraints() {
        view.addSubview(horizontalStack)
        view.insertSubview(verticalStack, belowSubview: horizontalStack)

        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: Sizes.profileAvatarSize),
            avatarImageView.heightAnchor.constraint(equalToConstant: Sizes.profileAvatarSize),
            
            logoutButton.widthAnchor.constraint(equalToConstant: 48),
            logoutButton.heightAnchor.constraint(equalToConstant: 48),
            
            horizontalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            horizontalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            horizontalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            verticalStack.topAnchor.constraint(equalTo: horizontalStack.bottomAnchor, constant: 8),
            verticalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            verticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    

}

extension ProfileViewController {
    @objc
    private func didTapedLogoutButton() {
        print("Logout button pressed")
    }
    
    private func updateProfileDetails() {
        nameLabel.text = profileService.profile?.name
        nikNameLabel.text = profileService.profile?.loginName
        descriptionLabel.text = profileService.profile?.bio
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }

        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "avatar-placeholder"),
            options: [.transition(.fade(1))]
        )
    }
}
