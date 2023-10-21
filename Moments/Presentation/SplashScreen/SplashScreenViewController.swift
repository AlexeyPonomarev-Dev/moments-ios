//
//  SplashScreenViewController.swift
//  Moments
//
//  Created by Alexey Ponomarev on 04.10.2023.
//

import UIKit
import SwiftKeychainWrapper

final class SplashScreenViewController: UIViewController {
    
    private let oAuth2Service = OAuth2Service()
    private let profileService = ProfileService.shared
    private var alertPresenter: AlertPresenter?
    private lazy var logoImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "LaunchScreen")
        
        return imageView
    }()
    
    private func setupViewConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(view: self)
        view.backgroundColor = UIColor.ypBlack
        view.addSubview(logoImageView)
        setupViewConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = oAuth2Service.authToken {
            fetchProfile(token)
        } else {
            switchToAuthController()
        }
    }
    
    private func switchToTabBarController() {
        // Получаем экземпляр `Window` приложения
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        // Cоздаём экземпляр нужного контроллера из Storyboard с помощью ранее заданного идентификатора.
        let tabBarController = UIStoryboard(name: Constants.main, bundle: .main)
            .instantiateViewController(withIdentifier: Constants.tabBarIdentifier)
           
        // Установим в `rootViewController` полученный контроллер
        window.rootViewController = tabBarController
    }
    
    private func switchToAuthController() {
        let storyboard = UIStoryboard(name: Constants.main, bundle: .main)
        let authViewController = storyboard.instantiateViewController(withIdentifier: Constants.authIdentifier) as? AuthViewController
        guard let authViewController  = authViewController else { return }

        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
    
        self.present(authViewController, animated: true)
    }
}

extension SplashScreenViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()

        oAuth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let token):
                self.fetchProfile(token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showError()
                break
            }
        }
    }
    
    func fetchProfile(_ token: String) {
        profileService.fetchProfile(
            token) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self.showError()
                    break
                }
            }
    }
}

extension SplashScreenViewController {
    private func showError() {
        alertPresenter?.show(data: AlertModel(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            buttonText: "ОК",
            completion: nil)
        )
    }
}
