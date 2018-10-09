//
//  DictionaryCoders.swift
//  TodoList
//
//  Created by Michal Štembera on 09/10/2018.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import Foundation

/// Encoder for encoding value of Codable type to dictionary or array
open class DictionaryEncoder {
    private let jsonEncoder = JSONEncoder()

    public init() { }

    /// Encodes given Encodable value into an array or dictionary
    public func encode<T>(_ value: T) throws -> Any where T: Encodable {
        let jsonData = try jsonEncoder.encode(value)
        return try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
    }
}

/// Decoder for decoding value of Decdable type from dictionary or array
open class DictionaryDecoder {
    private let jsonDecoder = JSONDecoder()

    public init() { }

    /// Decodes given Decodable type from given array or dictionary
    public func decode<T>(_ type: T.Type, from json: Any) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        return try jsonDecoder.decode(type, from: jsonData)
    }
}
