//
//  ContextStorage.swift
//  TodoList
//
//  Created by Michal Štembera on 10/10/2018.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import Foundation

class ContextStorage {
    // Accessing UserDefaults
    private static let phoneContextKey = "context_storage.phone"
    private static let watchContextKey = "context_storage.watch"
    private let defaults = UserDefaults.standard
    // Coding to data
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    var phoneContext: IOSContext? {
        didSet { UserDefaults.standard.set(encodable: phoneContext, forKey: ContextStorage.phoneContextKey) }
    }
    var watchContext: WatchContext? {
        didSet { UserDefaults.standard.set(encodable: watchContext, forKey: ContextStorage.watchContextKey) }
    }

    init() {
        phoneContext = UserDefaults.standard.value(forKey: ContextStorage.phoneContextKey)
        watchContext = UserDefaults.standard.value(forKey: ContextStorage.watchContextKey)
    }
}
