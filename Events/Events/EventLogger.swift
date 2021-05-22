//
//  EventLogger.swift
//  Events
//
//  Created by Amit Jangirh on 22/05/21.
//

import Foundation

struct EventLogger {
    static func log(object: Any...) {
        #if DEBUG
        print(object)
        #endif
    }
}
