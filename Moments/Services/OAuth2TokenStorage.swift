//
//  OAuth2TokenStorage.swift
//  Moments
//
//  Created by Alexey Ponomarev on 02.10.2023.
//

import Foundation
import SwiftKeychainWrapper

protocol OAuth2TokenStorageProtocol {
    var token: String? { get }
}

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    private enum Keys: String {
        case token
    }
    
    var token: String? {
        get { KeychainWrapper.standard.string(forKey: Constants.token) }
        set {
            guard let newValue = newValue else {
                KeychainWrapper.standard.removeObject(forKey: Constants.token)
                return
            }

            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: Constants.token)
            guard isSuccess else {
                fatalError("не удалось сохранить токен в безопасное хранилище")
            }
        }
    }

}
