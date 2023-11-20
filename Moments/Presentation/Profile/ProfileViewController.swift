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

public protocol ProfileViewControllerProtocol: AnyObject {
    func didTapedLogoutButton()
    func showLogoutAlert()
    func logOut(window: UIWindow)
    func updateProfileDetails(profile: Profile?)
    func updateAvatar(url: URL, placeholder: UIImage)
}

final class ProfileViewController: UIViewController {
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenter? = nil
    private var presenter: ProfilePresenterProtocol?
    
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
        static let logoutIconName: String = "logout"
        static let avatarPlaceholderName: String = "avatar-placeholder"
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
        label.accessibilityIdentifier = "NameLabel"
        
        return label
    }()
    
    private lazy var nikNameLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.fontSizeSmall, weight: .medium)
        label.textColor = UIColor.ypGray
        label.accessibilityIdentifier = "NikNameLabel"
        
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
        button.accessibilityIdentifier = "LogOutButton"

        return button
    }()
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    override func viewDidLoad() {

        horizontalStack.addArrangedSubview(avatarImageView)
        horizontalStack.addArrangedSubview(logoutButton)
    
        verticalStack.addArrangedSubview(nameLabel)
        verticalStack.addArrangedSubview(nikNameLabel)
        verticalStack.addArrangedSubview(descriptionLabel)

        presenter?.viewDidLoad()
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

extension ProfileViewController: ProfileViewControllerProtocol {
    @objc
    func didTapedLogoutButton() {
        showLogoutAlert()
    }
    
    func updateProfileDetails(profile: Profile?) {
        nameLabel.text = profile?.name
        nikNameLabel.text = profile?.loginName
        descriptionLabel.text = profile?.bio
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.updateAvatar()
        }
        presenter?.updateAvatar()
    }
    
    func updateAvatar(url: URL, placeholder: UIImage) {
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [.transition(.fade(1))]
        )
    }
    
    func logOut(window: UIWindow) {
        window.rootViewController = SplashScreenViewController()
    }
    
    func showLogoutAlert() {
        let alert = AlertModel(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            buttonText: "Нет",
            completion: nil,
            secondButtonText: "Да",
            secondCompletion: { [weak self] in
                guard let self = self else { return }
                self.presenter?.logOut()
            }
        )
        alertPresenter?.show(alert)
    }
}
