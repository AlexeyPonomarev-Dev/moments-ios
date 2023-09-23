//
//  ProfileViewController.swift
//  Moments
//
//  Created by Alexey Ponomarev on 09.09.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        let horizontalStack = UIStackView()
        let verticalStack = UIStackView()
        let avatarImageView = UIImageView()
        let avataImage = UIImage(named: "profile-avatar")
        let nameLabel = UILabel()
        let nikNameLabel = UILabel()
        let descriptionLabel = UILabel()
        let logoutButton = UIButton()
        let logoutButtonImage = UIImage(systemName: "ipad.and.arrow.forward")
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nikNameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false;
        verticalStack.translatesAutoresizingMaskIntoConstraints = false;
        
        avatarImageView.image = avataImage
        logoutButton.setImage(logoutButtonImage, for: .normal)
        logoutButton.tintColor = UIColor.ypRed
        logoutButton.addTarget(
            self, action: #selector(self.didTapedLogoutButton),
            for: UIControl.Event.touchUpInside
        )
        
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = UIColor.ypWhite
        
        nikNameLabel.text = "@ekaterina_nov"
        nikNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        nikNameLabel.textColor = UIColor.ypGray
        
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        descriptionLabel.textColor = UIColor.ypWhite
        
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 20
        horizontalStack.distribution = .equalSpacing
        horizontalStack.alignment = .center
        horizontalStack.addArrangedSubview(avatarImageView)
        horizontalStack.addArrangedSubview(logoutButton)
    
        verticalStack.axis = .vertical
        verticalStack.spacing = 8
        verticalStack.addArrangedSubview(nameLabel)
        verticalStack.addArrangedSubview(nikNameLabel)
        verticalStack.addArrangedSubview(descriptionLabel)
        
        view.addSubview(horizontalStack)
        view.insertSubview(verticalStack, belowSubview: horizontalStack)

        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
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
    
    @objc
    private func didTapedLogoutButton() {
        print("logout button taped")
    }
}
