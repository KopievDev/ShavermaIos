//
//  AuthRequest.swift
//
//
//  Created by Иван Копиев on 31.03.2024.
//

import Vapor
import Foundation
import SwiftOpenAPI
import VaporToOpenAPI

@OpenAPIDescriptable()
/// Запрос на авторизацию
struct AuthRequest: Content, WithExample {
    /// Почта
    let email: String
    /// Хэш пароля
    let password: String

    static var example: AuthRequest = .init(email: "x@mustdev.ru", password: "23d3njknwefkwwfw")
}

@OpenAPIDescriptable()
/// Сообщение
struct MessageResponse: Content, WithExample {
    /// Сообщение
    let message: String

    static var example: MessageResponse = .init(message: "Ok")
}

@OpenAPIDescriptable()
/// Сообщение
struct ForgotRequest: Content, WithExample {
    /// Сообщение
    let email: String

    static var example: ForgotRequest = .init(email: "x@mustdev.ru")
}
