//
//  DataStore.swift
//  Events
//
//  Created by Amit Jangirh on 22/05/21.
//

import Foundation

/// Data store class,
/// Use is to set/get the value in User default
/// We can update the store class to store value in Keychain or DB
struct DataStore {
    let store = UserDefaults.standard
    
    enum StoreKey: String {
        /// Access token key, which is stored in DB
        case accessToken = "EventAPI_AccessToken"
    }
    
    func getValue<T: Codable>(for key: StoreKey) -> T? {
        do {
            guard let decodedValue = store.object(forKey: key.rawValue) as? Data else {
                return nil
            }
            return try JSONDecoder().decode(T.self, from: decodedValue)
        } catch {
            EventLogger.log(object: "Failed to decode saved data with error: \(error)")
            return nil
        }
    }
    
    mutating func saveValue<T: Codable>(_ value: T, key: StoreKey) {
        do {
            let encodedValue = try JSONEncoder().encode(value)
            store.set(encodedValue, forKey: key.rawValue)
        } catch {
            EventLogger.log(object: "Failed to save encoded data with error: \(error)")
        }
    }
    
    mutating func removeValue(for key: StoreKey) {
        store.removeObject(forKey: key.rawValue)
    }
}

extension DataStore {
    static var accessToken: AccessToken? {
        get {
            DataStore().getValue(for: .accessToken)
        }
        set {
            var dataStore = DataStore()
            if var updatedToken = newValue {
                updatedToken.storeDate = Date() // Update the new date of store
                dataStore.saveValue(updatedToken, key: .accessToken)
            } else {
                dataStore.removeValue(for: .accessToken)
            }
        }
    }
}
