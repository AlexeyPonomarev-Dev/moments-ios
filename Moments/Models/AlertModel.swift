//
//  AlertModel.swift
//  Moments
//
//  Created by Alexey Ponomarev on 19.10.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
    var secondButtonText: String? = nil
    var secondCompletion: () -> Void = {}
}
