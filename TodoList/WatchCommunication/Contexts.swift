//
//  WatchManager.swift
//  TodoList
//
//  Created by Michal Štembera on 09/10/2018.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import Foundation

protocol Versionable {
    /// Unique identifier of current version
    var version: String { get }
    /// Date of the change if available. Otherwise date of creation of the versionable object.
    var changeDate: Date { get }
}

extension Versionable {
    func isSameVersion(as other: Self) -> Bool {
        return self.version == other.version
    }

    static func generateVersion() -> (String, Date) {
        return (UUID().uuidString, Date())
    }
}

/// Context sent by iOS app to the watchOS app
struct WatchContext: Codable, Versionable {
    let version: String
    let changeDate: Date
    var items: [Item]
}

/// Context sent by watchOS app to the iOS app
struct IOSContext: Codable, Versionable {
    let version: String
    let changeDate: Date
    var refreshRate: TimeInterval
    var items: [Item]
}
