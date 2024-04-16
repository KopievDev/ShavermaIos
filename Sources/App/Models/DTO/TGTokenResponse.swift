//
//  TGTokenResponse.swift
//
//
//  Created by Иван Копиев on 16.04.2024.
//

import Vapor
import Foundation
import SwiftOpenAPI
import VaporToOpenAPI

@OpenAPIDescriptable()
/// Токен телеграма
struct TelegramDataResponse: Content, WithExample {
    /// id
    let id: UUID
    /// Токен бота
    let token: String
    /// id чата
    let chatId: String

    static var example: TelegramDataResponse = .init(id: .generateRandom(), token: "some token", chatId: "Some id")
}