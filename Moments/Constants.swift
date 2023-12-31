//
//  Constants.swift
//  Moments
//
//  Created by Alexey Ponomarev on 25.09.2023.
//

import Foundation

public enum Constants {
    static let accessKey: String = "JPBCjXwBf--olSEDpG9yJXLCBJ5dG8yANm0gfEKRmfE"
    static let secretKey: String = "zsMImgvlgWzFGhpJi9SUAGCCH7I5jEQ7OedEXANRRoU"
    static let redirectUri: String = "urn:ietf:wg:oauth:2.0:oob"
    static let defaultBaseURL: URL = URL(string: "https://api.unsplash.com")!
    static let accessScope: String = "public+read_user+write_likes"
    static let unsplashAuthorizeURLString: String = "https://unsplash.com/oauth/authorize"
    static let unsplashTokenURLString: String = "https://unsplash.com/oauth/token"
    static let profilePath: String = "/me"
    static let usersPath: String = "/users"
    static let photosPath: String = "/photos"

    
    static let token = "Auth token"
    static let main = "Main"
    
    static let tabBarIdentifier = "TabBarViewController"
    static let authIdentifier = "AuthViewController"
    static let imageListItentifier = "ImagesListViewController"
}

public enum HttpMethods {
    static let get = "GET"
    static let post = "POST"
    static let delete = "DELETE"
}


