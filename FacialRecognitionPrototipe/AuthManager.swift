//
//  AuthManager.swift
//  FacialRecognitionPrototipe
//
//  Created by formando on 18/12/2023.
//

import Foundation

class AuthManager {
    static let shared = AuthManager()

    private let userDefaults = UserDefaults.standard
    private let accessTokenKey = "accessToken"

    var accessToken: String? {
        get {
            return userDefaults.string(forKey: accessTokenKey)
        }
        set {
            userDefaults.set(newValue, forKey: accessTokenKey)
        }
    }

    func saveAccessToken(fromJson json: [String: Any]) {
        if let token = json["access_token"] as? String {
            accessToken = token
        } else {
            print("Access token not found in the response")
        }
    }

    func clearAccessToken() {
        userDefaults.removeObject(forKey: accessTokenKey)
    }
}
