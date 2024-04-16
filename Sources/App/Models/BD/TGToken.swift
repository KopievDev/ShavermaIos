//
//  TGToken.swift
//  
//
//  Created by Иван Копиев on 16.04.2024.
//

import Fluent
import Vapor

final class TelegramData: Model, Content {
    static let schema = "telegram_bots"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "token")
    var token: String

    @Field(key: "chat_id")
    var chatId: String

    init() { }

    init(id: UUID? = nil, token: String, chatId: String) {
        self.id = id
        self.token = token
        self.chatId = chatId
    }
}

extension TelegramData {

    func response() throws -> TelegramDataResponse {
        try .init(id: requireID(), token: token, chatId: chatId)
    }

}

extension TelegramData {
    struct Migration: AsyncMigration {
        var name: String { "CreateTelegramData" }

        func prepare(on database: Database) async throws {
            try await database.schema(TelegramData.schema)
                .id()
                .field("token", .string, .required)
                .field("chat_id", .string, .required)
                .unique(on: "token")
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(TelegramData.schema).delete()
        }
    }
}
