//
//  UserDefaultsExtensions.swift
//  TodoList
//
//  Created by Michal Štembera on 10/10/2018.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import Foundation

extension UserDefaults {
    /// Encodes the given value to data using JSONEncoder and stores it under given key
    public func set<T: Encodable>(
        encodable: T?,
        forKey key: String,
        using encoder: JSONEncoder = JSONEncoder())
    {
        if let value = encodable, let data = try? encoder.encode(value) {
            set(data, forKey: key)
        } else {
            set(nil, forKey: key)
        }
    }

    /// Loads data under given key and decodes them using JSONDecoder
    public func value<T: Decodable>(
        forKey key: String,
        using decoder: JSONDecoder = JSONDecoder()) -> T?
    {
        if let loadedData = data(forKey: key) {
            return try? decoder.decode(T.self, from: loadedData)
        } else {
            return nil
        }
    }
}
