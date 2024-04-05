//
//  PreferencesKey.swift
//  Shaverma
//
//  Created by Иван Копиев on 05.04.2024.
//

import Foundation
public protocol PreferencesKey: CustomStringConvertible { }

public enum ApplicationPreferencesKey: PreferencesKey {
    ///Это первый вход в приложение
    case isFirstStart
    ///Дата получения токена авторизации
    case authToken

    public var description: String {
        switch self {
        case .isFirstStart:
            "isFirstStart"
        case .authToken:
            "authToken"
        }
    }
}
