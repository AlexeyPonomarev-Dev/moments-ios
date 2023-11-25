//
//  Photo.swift
//  Moments
//
//  Created by Alexey Ponomarev on 28.10.2023.
//

import Foundation

public struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
} 
