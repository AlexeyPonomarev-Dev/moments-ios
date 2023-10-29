//
//  PhotoListResponseBody.swift
//  Moments
//
//  Created by Alexey Ponomarev on 28.10.2023.
//

import Foundation

// MARK: - PhotoListItem
struct ImagesListItem: Codable {
    let id: String
    let createdAt: String?
    let width, height: Int
    let description: String?
    let likes: Int
    let urls: Urls

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height, description, likes, urls
    }
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small, thumb, smallS3: String

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}
