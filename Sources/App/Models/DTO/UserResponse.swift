//
//  UserResponse.swift
//
//
//  Created by Иван Копиев on 01.04.2024.
//

import Vapor
import Foundation
import SwiftOpenAPI
import VaporToOpenAPI

@OpenAPIDescriptable()
/// Профиль пользователя
struct UserResponse: Content, WithExample {
    /// Имя
    var name: String
    /// Фамилия
    var familyName: String?
    /// Почта
    var email: String
    /// Телефон
    var phone: String?

    static var example: UserResponse = .init(
        name: "Иван",
        familyName: "Копиев",
        email: "x@mustdev.ru",
        phone: "79684777959"
    )
}

