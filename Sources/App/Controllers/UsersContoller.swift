//
//  UsersContoller.swift
//
//
//  Created by Иван Копиев on 01.04.2024.
//

import Foundation
import Vapor
import VaporToOpenAPI

struct UsersContoller: RouteCollection {

    let tokenProtected: RoutesBuilder

    func boot(routes: RoutesBuilder) throws {
        let users = tokenProtected.grouped("users")
        users.get("me", use: me)
            .openAPI(
                tags: .init(name: "Users"),
                summary: "Профиль",
                description: "Данные профиля",
                headers: .all(of: .type(Headers.AccessToken.self)),
                contentType: .application(.json),
                response: .type(UserResponse.self),
                responseContentType: .application(.json),
                responseDescription: "Success response"
            )
        users.put("address", use: address)
            .openAPI(
                tags: .init(name: "Users"),
                summary: "Обновить адрес",
                description: "Изменить или добавить адрес",
                headers: .all(of: .type(Headers.AccessToken.self)),
                body: .all(of: .type(AddressResponse.self)),
                contentType: .application(.json),
                response: .type(AddressResponse.self),
                responseContentType: .application(.json),
                responseDescription: "Success response"
            )

        users.get("address", use: getAddress)
            .openAPI(
                tags: .init(name: "Users"),
                summary: "Адрес",
                description: "Получить текущий адресс",
                headers: .all(of: .type(Headers.AccessToken.self)),
                contentType: .application(.json),
                response: .type(AddressResponse.self),
                responseContentType: .application(.json),
                responseDescription: "Success response"
            )
    }

    func me(req: Request) async throws -> UserResponse {
        let user = try req.auth.require(User.self)
        return UserResponse(name: user.name, familyName: user.familyName, email: user.email, phone: user.phone)
    }

    func address(req: Request) async throws -> AddressResponse {
        let user = try req.auth.require(User.self)
        let requestAddress = try req.content.decode(AddressResponse.self)
        let addresses = try await Addresses.query(on: req.db).all()
        if let address = addresses.first(where: { $0.$user.id == user.id }) {
            try await address.delete(on: req.db)
        }
        let newAddress = try user.createAddress(requestAddress)
        try await newAddress.save(on: req.db)
        return newAddress.response
    }

    func getAddress(req: Request) async throws -> AddressResponse {
        let user = try req.auth.require(User.self)
        let addresses = try await Addresses.query(on: req.db).all()
        if let address = addresses.first(where: { $0.$user.id == user.id }) {
            return address.response
        } else {
            throw Abort(.custom(code: 404, reasonPhrase: "Не найден адрес"))
        }
    }
}
