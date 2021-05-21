//
//  TokenManager.swift
//  Events
//
//  Created by Amit Jangirh on 22/05/21.
//

import Foundation

struct TokenManager {
    let store = UserDefaults.standard
    enum StoreKey: String {
        case accessToken = "EventAPI_AccessToken"
    }
    
    var accessToken: AccessToken? {
        get {
            store.object(forKey: StoreKey.accessToken.rawValue) as? AccessToken
        }
        set {
            if var updatedToken = newValue {
                updatedToken.storeDate = Date() // Update the new token
                store.set(updatedToken, forKey: StoreKey.accessToken.rawValue)
            } else {
                store.removeObject(forKey: StoreKey.accessToken.rawValue)
            }
        }
    }
}
