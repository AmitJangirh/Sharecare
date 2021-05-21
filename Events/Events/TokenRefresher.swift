//
//  TokenRefresher.swift
//  Events
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation

protocol TokenRefreshable {
    static func refreshToken(completion: @escaping (Result<String, EventsError>) -> Void)
}

struct TokenRefresher: TokenRefreshable {
    static func refreshToken(completion: @escaping (Result<String, EventsError>) -> Void) {
        if let existingToken = TokenManager().accessToken, existingToken.isValidToken {
            completion(.success(existingToken.accessToken!))
            return
        }
        EventNetwork.getAccessToken { (result: Result<AccessToken, EventsError>) in
            switch result {
            case .success(let accessToken):
                if accessToken.isValidToken {
                    completion(.success(accessToken.accessToken!))
                } else {
                    completion(.failure(.invalidAccessToken))
                }
            case .failure(let eventsError):
                completion(.failure(eventsError))
            }
        }
    }
}
