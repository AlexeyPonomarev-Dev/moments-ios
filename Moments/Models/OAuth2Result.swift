//
//  AuthResponseModel.swift
//  Moments
//
//  Created by Alexey Ponomarev on 02.10.2023.
//

import Foundation

struct OAuthTokenResult: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}
