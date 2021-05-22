//
//  AccessToken.swift
//  Events
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation

// Object to be consumed internally
struct AccessToken: Codable {
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case scope
        case tokenType = "token_type"
    }
    
    var accessToken: String?
    var expiresIn: Int?
    var scope: String?
    var tokenType: String?
    var storeDate: Date?
}

extension AccessToken {
    var isValidToken: Bool {
        guard let token = self.accessToken, !token.isEmpty,
              let expire = self.expiresIn, expire > 0 else {
            return false
        }
        guard let lastStoredDate = self.storeDate else {
            // If no store date then, we are fetching first time, then save it
            return true
        }
        if lastStoredDate.seconds(from: Date()) > expire {
            // If Store date exeeds the expire time
            return false
        }
        return true
    }
}

extension Date {
/// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
}
