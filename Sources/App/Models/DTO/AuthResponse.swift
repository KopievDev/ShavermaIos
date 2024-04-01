//
//  AuthResponse.swift
//  
//
//  Created by Иван Копиев on 31.03.2024.
//

import Vapor
import Foundation
import SwiftOpenAPI
import VaporToOpenAPI

@OpenAPIDescriptable()
/// Успешная авторизация
struct AuthResponse: Content, WithExample {
    /// Токен
    let token: String

    static var example: AuthResponse = .init(token: "some token")
}
