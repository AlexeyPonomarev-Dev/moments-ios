//
//  Profile.swift
//  Moments
//
//  Created by Alexey Ponomarev on 14.10.2023.
//

import Foundation

struct Profile {
    let userName, name, bio: String
    var loginName: String {
        "@\(userName)"
    }
    
}
