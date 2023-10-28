//
//  ProfileService.swift
//  Moments
//
//  Created by Alexey Ponomarev on 14.10.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let profileImageService = ProfileImageService.shared
    
    private init() {}

    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        
        assert(Thread.isMainThread)
        self.task?.cancel()
        
        let request = profileRequest(token)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResponseBody, Error>) in
        
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let body):
                    let profile = Profile(
                        userName: body.username,
                        name: "\(body.firstName) \(body.lastName ?? "")",
                        bio: body.bio ?? ""
                    )
                    completion(.success(profile))
                    self.profile = profile
                    self.task = nil
                    self.profileImageService.fetchProfileImage(profile.userName) { result in
                        
                    }
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


extension ProfileService {
    private func profileRequest(_ token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: Constants.profilePath,
            httpMethod: "GET"
        )
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
