//
//  UserResponseBody.swift
//  Moments
//
//  Created by Alexey Ponomarev on 16.10.2023.
//

import Foundation

struct UserResponseBody: Codable {
    let profileImage: ProfileImage

    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small, medium, large: String
}
