//
//  Preferences.swift
//  Shaverma
//
//  Created by Иван Копиев on 05.04.2024.
//

import Foundation

public final class Preferences {

    private let storage: UserDefaults

    public init(storage: UserDefaults = .standard) {
        self.storage = storage
    }

    public func set<Value: Codable>(_ value: Value, for key: PreferencesKey) {
        if let dictionary = try? PropertyListEncoder().encode(value) {
            storage.set(dictionary, forKey: key.description)
        } else {
            storage.set(value, forKey: key.description)
        }
    }

    public func get<Value: Codable>(for key: PreferencesKey) -> Value? {
        if let data = storage.value(forKey: key.description) as? Data,
           let value = try? PropertyListDecoder().decode(Value.self, from: data) {
            return value
        } else {
            return storage.value(forKey: key.description) as? Value
        }
    }
}

@propertyWrapper
public struct PreferencesStored<Value: Codable> {

    private let defaultValue: Value
    private let key: PreferencesKey
    private let storage: Preferences

    public init(
        wrappedValue defaultValue: Value,
        key: PreferencesKey,
        storage: UserDefaults = .standard
    ) {
        self.defaultValue = defaultValue
        self.key = key
        self.storage = Preferences(storage: storage)
    }

    public var wrappedValue: Value {
        get {
            storage.get(for: key) ?? defaultValue
        }
        set {
            storage.set(newValue, for: key)
        }
    }
}
