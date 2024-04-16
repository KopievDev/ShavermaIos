//
//  AdminController.swift
//
//
//  Created by Иван Копиев on 16.04.2024.
//

import Foundation
import Vapor
import VaporToOpenAPI

struct AdminController: RouteCollection {

    let tokenProtected: RoutesBuilder

    func boot(routes: RoutesBuilder) throws {
        let admin = tokenProtected.grouped("admin")

        admin.get("telegram","bots", use: telegramData)
            .openAPI(
                tags: .init(name: "Admin"),
                summary: "Телеграмм боты",
                description: "Данные телеграмм ботов",
                headers: .all(of: .type(Headers.AccessToken.self)),
                contentType: .application(.json),
                response: .type([TelegramDataResponse].self),
                responseContentType: .application(.json),
                responseDescription: "Success response"
            )

        admin.post("telegram","bots", use: createTelegramData)
            .openAPI(
                tags: .init(name: "Admin"),
                summary: "Добавить телеграмм бота",
                description: "Добавление телеграмм бота для отправки в канал сообщений о новом заказе",
                headers: .all(of: .type(Headers.AccessToken.self)),
                body: .all(of: .type(TelegramDataResponse.self)),
                contentType: .application(.json),
                response: .type(TelegramDataResponse.self),
                responseContentType: .application(.json),
                responseDescription: "Success response"
            )

        admin.put("telegram","bots", use: updateTelegramData)
            .openAPI(
                tags: .init(name: "Admin"),
                summary: "Обновить телеграмм бота",
                description: "Обновление телеграмм бота для отправки в канал сообщений о новом заказе",
                headers: .all(of: .type(Headers.AccessToken.self)),
                body: .all(of: .type(TelegramDataResponse.self)),
                contentType: .application(.json),
                response: .type(TelegramDataResponse.self),
                responseContentType: .application(.json),
                responseDescription: "Success response"
            )
    }

    func telegramData(req: Request) async throws -> [TelegramDataResponse] {
        let user = try req.auth.require(User.self)
        guard user.role == .admin else {
            throw Abort(.forbidden)
        }
        let allDatas = try await TelegramData.query(on: req.db).all()
        for data in allDatas {
            try await req.sendTG(message: "TelegramData: \(data)")
        }
        return try allDatas.compactMap { try $0.response() }
    }

    func createTelegramData(req: Request) async throws -> TelegramDataResponse {
        let user = try req.auth.require(User.self)
        let request = try req.content.decode(TelegramDataResponse.self)

        guard user.role == .admin else {
            throw Abort(.forbidden)
        }
        let newTgBot = TelegramData(id: request.id, token: request.token, chatId: request.chatId)
        try await newTgBot.save(on: req.db)
        return try newTgBot.response()
    }

    func updateTelegramData(req: Request) async throws -> TelegramDataResponse {
        let user = try req.auth.require(User.self)
        let request = try req.content.decode(TelegramDataResponse.self)

        guard user.role == .admin else {
            throw Abort(.forbidden)
        }
        if let oldTgValue = try await TelegramData.query(on: req.db).all().first(where: { $0.id == request.id }) {
            oldTgValue.chatId = request.chatId
            oldTgValue.token = request.token
            try await oldTgValue.save(on: req.db)
            return try oldTgValue.response()
        } else {
            let newTgBot = TelegramData(id: request.id, token: request.token, chatId: request.chatId)
            try await newTgBot.save(on: req.db)
            return try newTgBot.response()
        }
    }
}

extension Request {
    func sendTG(message: String) async throws  {
        let allDatas = try await TelegramData.query(on: db).all()
        allDatas.forEach { data  in
            let apiUrl = "https://api.telegram.org/bot\(data.token)/sendMessage"
            let requestBody: [String: String] = ["chat_id": data.chatId, "text": message]
            _ = client.post(URI(string: apiUrl)) { request in
                try request.content.encode(requestBody, as: .json)
            }
        }
    }
}
