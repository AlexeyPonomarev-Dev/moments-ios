//
//  ProfileViewController.swift
//  Moments
//
//  Created by Alexey Ponomarev on 09.09.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
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
        imageView.image = UIImage(named: "profile-avatar")
        
        return imageView
    }()
    
    private lazy var nameLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = UIColor.ypWhite
        
        return label
    }()
    
    private lazy var nikNameLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@ekaterina_nov"
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor.ypGray
        
        return label
    }()
    
    private lazy var descriptionLabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, world!"
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


        setupViewConstraints()
    }
    
    private func setupViewConstraints() {
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
        print("Logout button pressed")
    }
    
}
