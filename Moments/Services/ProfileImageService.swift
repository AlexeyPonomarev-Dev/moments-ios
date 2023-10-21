//
//  ProfileImageService.swift
//  Moments
//
//  Created by Alexey Ponomarev on 16.10.2023.
//

import Foundation
import SwiftKeychainWrapper

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    
    init() {}

    func fetchProfileImage(
        _ userName: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let userName = ProfileService.shared.profile?.userName else { return }

        
        assert(Thread.isMainThread)
        self.task?.cancel()

        guard let token = KeychainWrapper.standard.string(forKey: Constants.token) else { return }

        var request = profileImageRequest(userName)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResponseBody ,Error>) in
        
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let body):
                    let profileUrl = body.profileImage.small
                    completion(.success(profileUrl))
                    self.avatarURL = profileUrl
                    NotificationCenter.default.post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": profileUrl]
                    )
                    self.task = nil
                case .failure(let error):
            
                    completion(.failure(error))
                    self.task = nil
                }
            }
        }

        task.resume()
        self.task = task

    }
}

extension ProfileImageService {
    private func profileImageRequest(_ userName: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "\(Constants.profilePublicPath)/\(userName)",
            httpMethod: "GET"
        )
    }
}

