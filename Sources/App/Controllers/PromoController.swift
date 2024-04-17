//
//  PromoController.swift
//
//
//  Created by Иван Копиев on 16.04.2024.
//

import Foundation
import Vapor
import VaporToOpenAPI

struct PromoController: RouteCollection {

    let tokenProtected: RoutesBuilder

    func boot(routes: RoutesBuilder) throws {
        let users = tokenProtected.grouped("promo")
        users.get(use: getPromos)
            .openAPI(
                tags: .init(name: "Promo"),
                summary: "Список доступных акций",
                description: "Список доступных акций",
                headers: .all(of: .type(Headers.AccessToken.self)),
                contentType: .application(.json),
                response: .type([PromoResponse].self),
                responseContentType: .application(.json),
                responseDescription: "Success response"
            )

        users.post(use: postPromo)
            .openAPI(
                tags: .init(name: "Promo"),
                summary: "Добавить акцию",
                description: "Добавить акцию",
                headers: .all(of: .type(Headers.AccessToken.self)),
                body: .all(of: .type(PromoResponse.self)),
                contentType: .application(.json),
                response: .type([PromoResponse].self),
                responseContentType: .application(.json),
                responseDescription: "Success response"
            )

        users.put(use: putPromo)
            .openAPI(
                tags: .init(name: "Promo"),
                summary: "Изменить акцию",
                description: "Изменить акцию",
                headers: .all(of: .type(Headers.AccessToken.self)),
                body: .all(of: .type(PromoResponse.self)),
                contentType: .application(.json),
                response: .type(PromoResponse.self),
                responseContentType: .application(.json),
                responseDescription: "Success response"
            )

        users.delete(":id", use: deletePromo)
            .openAPI(
                tags: .init(name: "Promo"),
                summary: "Удалить акцию",
                description: "Удалить промо по id",
                headers: .all(of: .type(Headers.AccessToken.self)),
                path: .schema(.uuid),
                contentType: .application(.json),
                response: .type(PromoResponse.self),
                responseContentType: .application(.json),
                responseDescription: "Success response"
            )
    }
    
    func getPromos(req: Request) async throws -> [PromoResponse] {
        let _ = try req.auth.require(User.self)
        return try await Promos.query(on: req.db).all().compactMap { try $0.response() }
    }

    func putPromo(req: Request) async throws -> PromoResponse {
        let user = try req.auth.require(User.self)
        guard user.role == .admin else {
            throw Abort(.forbidden)
        }
        let promoRequest = try req.content.decode(PromoResponse.self)
        let promos = try await Promos.query(on: req.db).all()
        guard let promo = promos.first(where: { $0.id == promoRequest.id }) else {
            throw Abort(.custom(code: 404, reasonPhrase: "Нет такой акции"))
        }
        try await promo.update(with: promoRequest, on: req.db)
        return try promo.response()
    }

    func postPromo(req: Request) async throws -> [PromoResponse] {
        let user = try req.auth.require(User.self)
        guard user.role == .admin else {
            throw Abort(.forbidden)
        }
        let promoRequest = try req.content.decode(PromoResponse.self)
        let promo = Promos(id: .generateRandom(), title: promoRequest.title, desc: promoRequest.desc, imageUrl: promoRequest.imageUrl)
        try await promo.save(on: req.db)

        return try await Promos.query(on: req.db).all().map { try $0.response() }
    }

    func deletePromo(req: Request) async throws -> PromoResponse {
        let user = try req.auth.require(User.self)
        guard user.role == .admin else {
            throw Abort(.forbidden)
        }
        guard let promoId = req.parameters.get("id"), let id = UUID(uuidString: promoId) else {
            throw Abort(.custom(code: 404, reasonPhrase: "Нет такой акции"))
        }
        let promos = try await Promos.query(on: req.db).all()
        guard let promo = promos.first(where: { $0.id == id }) else {
            throw Abort(.custom(code: 404, reasonPhrase: "Нет такой акции"))
        }

        try await promo.delete(on: req.db)
        return try promo.response()
    }
}
