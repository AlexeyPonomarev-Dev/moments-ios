//
//  ImagesListService.swift
//  Moments
//
//  Created by Alexey Ponomarev on 28.10.2023.
//

import Foundation
import SwiftKeychainWrapper

final class ImagesListService {
    static let shared = ImagesListService()
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private enum Keys {
        static let perPage = 10
    }
    
    private init() {}
    
    func fetchPhotosNextPage() {
        if self.task !== nil {
            return
        }
    
        assert(Thread.isMainThread)
        guard let token = KeychainWrapper.standard.string(forKey: Constants.token) else { return }
        guard let userName = ProfileService.shared.profile?.userName else { return }

        let nextPage = lastLoadedPage == nil
        ? 1
        : lastLoadedPage! + 1
    
        var request = imageListRequest(
            userName: userName,
            page: nextPage,
            perPage: Keys.perPage
        )

        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[ImagesListItem], Error>) in
        
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let body):
                    body.forEach { el in
                        let photo = Photo(
                            id: el.id,
                            size: CGSize(width: el.width, height: el.height),
                            createdAt: DateService.shared.dateFromString(str: el.createdAt),
                            welcomeDescription: el.description,
                            thumbImageURL: el.urls.thumb,
                            largeImageURL: el.urls.regular,
                            isLiked: el.likes > 0
                        )
                        self.photos.append(photo)
                    }
                    
                    NotificationCenter.default.post(
                        name: ImagesListService.DidChangeNotification,
                        object: self
                    )
                    self.lastLoadedPage = nextPage
                    self.task = nil
                case .failure(let error):
                    print(error.localizedDescription)
                    self.task = nil
                }
            }
        }

        task.resume()
        self.task = task
    }
}

extension ImagesListService {
    private func imageListRequest(userName: String, page: Int, perPage: Int) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "\(Constants.usersPath)/\(userName)\(Constants.photosPath)?page=\(page)&per_page=\(perPage)",
            httpMethod: "GET"
        )
    }
}
