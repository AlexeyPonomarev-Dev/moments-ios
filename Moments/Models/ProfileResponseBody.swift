//
//  ProfileResponseBody.swift
//  Moments
//
//  Created by Alexey Ponomarev on 14.10.2023.
//

import Foundation


struct ProfileResponseBody: Decodable {
    let username, firstName: String
    let lastName, bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }

}
