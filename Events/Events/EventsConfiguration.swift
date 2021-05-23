//
//  EventsConfiguration.swift
//  Events
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation

enum Enviornment {
    case dev
    case production
}

extension Enviornment {
    var basicToken: String {
        "Basic aDFFs87201jskfna818rfyeia917="
        /** We can add Different enviorment like below
        switch self {
        case .dev: return ""
        case .production: return ""
        }
         */
    }
    var domain: String {
        "https://private-anon-f81d95a6e6-gdsc.apiary-mock.com"
    }
}

struct EventsConfiguration {
    let version = "v1"
    let basicToken: String!
    let domain: String!
    private let enviornment: Enviornment

    init(enviornment: Enviornment) {
        self.enviornment = enviornment
        self.basicToken = enviornment.basicToken
        self.domain = enviornment.domain
    }
}

extension EventsConfiguration {
    var baseURL: String {
        self.domain + "/" + self.version
    }
    
    /// Setting current configuration
    /// This is be read from XCConfig or from a file
    /// hard code default enviornment to production
    static var current = EventsConfiguration(enviornment: .production)
}
