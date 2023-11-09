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
    private var alertPresenter: AlertPresenter? = nil
    
    private enum Constants {
        static let profileAvatarSize: CGFloat = 70
        static let logoutButtonSize: CGFloat = 48
        static let horizontalStackSpacing: CGFloat = 20
        static let verticalStackSpacing: CGFloat = 8
        static let horizontalStackTopAnchor: CGFloat = 32
        static let horiozontalPadding: CGFloat = 16
        static let horiozontalPaddingNegative: CGFloat = -16
        static let fontSizeLarge: CGFloat = 23
        static let fontSizeSmall: CGFloat = 13
        static let avatarPlaceholderName: String = "avatar-placeholder"
        static let logoutIconName: String = "logout"
    }
    
    private lazy var horizontalStack: UIStackView = {
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = Constants.horizontalStackSpacing
        stack.distribution = .equalSpacing
        stack.alignment = .center
        
        return stack
    }()
    
    private lazy var verticalStack = {
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.verticalStackSpacing
        
        return stack
    }()
    
    private lazy var avatarImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: Constants.avatarPlaceholderName)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.profileAvatarSize / 2
        
        return imageView
    }()
    
    private lazy var nameLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.fontSizeLarge, weight: .bold)
        label.textColor = UIColor.ypWhite
        
        return label
    }()
    
    private lazy var nikNameLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.fontSizeSmall, weight: .medium)
        label.textColor = UIColor.ypGray
        
        return label
    }()
    
    private lazy var descriptionLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.fontSizeSmall, weight: .medium)
        label.textColor = UIColor.ypWhite
        
        return label
    }()
    
    private lazy var logoutButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: Constants.logoutIconName), for: .normal)
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
        
        alertPresenter = AlertPresenter(view: self)
    }
    
    private func setupViewConstraints() {
        view.addSubview(horizontalStack)
        view.insertSubview(verticalStack, belowSubview: horizontalStack)

        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.profileAvatarSize),
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.profileAvatarSize),
            
            logoutButton.widthAnchor.constraint(equalToConstant: Constants.logoutButtonSize),
            logoutButton.heightAnchor.constraint(equalToConstant: Constants.logoutButtonSize),
            
            horizontalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.horizontalStackTopAnchor),
            horizontalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horiozontalPadding),
            horizontalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.horiozontalPaddingNegative),
            
            verticalStack.topAnchor.constraint(equalTo: horizontalStack.bottomAnchor, constant: Constants.verticalStackSpacing),
            verticalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horiozontalPadding),
            verticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.horiozontalPaddingNegative),
        ])
    }
    

}

extension ProfileViewController {
    @objc
    private func didTapedLogoutButton() {
        showLogoutAlert()
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
            placeholder: UIImage(named: Constants.avatarPlaceholderName),
            options: [.transition(.fade(1))]
        )
    }
    
    private func logout() {
        OAuth2TokenStorage().token = nil
        WebViewViewController.clean()
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Something went wrong")
            return
        }
        
        window.rootViewController = SplashScreenViewController()
    }
    
    private func showLogoutAlert() {
        let alert = AlertModel(
            title: "Выйти?",
            message: "Вы уверны что хотите выйти?",
            buttonText: "Остаться",
            completion: nil,
            secondButtonText: "Выйти",
            secondCompletion: { [weak self] in
                guard let self = self else { return }
                self.logout()
            }
        )
        alertPresenter?.show(alert)
    }
}
