//
//  File.swift
//  
//
//  Created by Иван Копиев on 31.03.2024.
//

import Vapor
import Foundation
import SwiftOpenAPI
import VaporToOpenAPI

extension User {
    @OpenAPIDescriptable
    /// Создание пользователя
    struct Create: Content, WithExample {
        /// Имя
        var name: String
        /// Фамилия
        var familyName: String
        /// Почта
        var email: String
        /// Пароль
        var password: String
        /// Телефон
        var phone: String

        static var example: User.Create = .init(
            name: "Иван",
            familyName: "Копиев",
            email: "x@mustdev.ru",
            password: "1321324124",
            phone: "79684777959"
        )
    }
}

extension User.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
        validations.add("phone", as: String.self, is: .count(11...11))
    }
}
