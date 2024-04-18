//
//  OrderController.swift
//
//
//  Created by Иван Копиев on 18.04.2024.
//

import Vapor
import Fluent
import Foundation
import VaporToOpenAPI

struct OrderController: RouteCollection {

    let tokenProtected: RoutesBuilder

    func boot(routes: RoutesBuilder) throws {
        let cart = tokenProtected.grouped("cart")
        cart.get(use: getCart)
            .openAPI(
                tags: .init(name: "Order"),
                summary: "Корзина",
                description: "Получить текущую корзину",
                headers: .all(of: .type(Headers.AccessToken.self)),
                contentType: .application(.json),
                response: .type(CartResponse.self),
                responseContentType: .application(.json),
                responseDescription: "Success response"
            )

        cart.put(use: putCart)
            .openAPI(
                tags: .init(name: "Order"),
                summary: "Добавить или удалить товар из корзины ",
                description: "Обновляет товар в корзине",
                headers: .all(of: .type(Headers.AccessToken.self)),
                body: .all(of: .type(CartRequest.self)),
                contentType: .application(.json),
                response: .type(CartResponse.self),
                responseContentType: .application(.json),
                responseDescription: "Success response"
            )
    }

    func getCart(req: Request) async throws -> CartResponse {
        let user = try req.auth.require(User.self)
        let carts = try await Cart.query(on: req.db)
            .with(\.$items) {
                $0.with(\.$product) {
                    $0.with(\.$category)
                }
            }
            .all()
        // Ищем корзину пользователя
        if let cart = carts.first(where: { $0.$user.id == user.id }) {
            return try cart.response()
        } else {
            let cart = Cart(
                id: .generateRandom(),
                userId: try user.requireID(),
                totalAmount: 0
            )
            try await cart.save(on: req.db)
            let cartFromBd = try await Cart.query(on: req.db)
                .filter(\.$user.$id == user.requireID())
                .with(\.$items) {
                    $0.with(\.$product) {
                        $0.with(\.$category)
                    }
                }
                .first()
            guard let cartFromBd else {
                throw Abort(.badRequest)
            }
            return try cartFromBd.response()
        }
    }


    func putCart(req: Request) async throws -> CartResponse {
        let user = try req.auth.require(User.self)
        let cartRequest = try req.content.decode(CartRequest.self)
        guard let product = try await Products.query(on: req.db)
            .filter(\.$id == cartRequest.id)
            .first() else {
            throw Abort(.custom(code: 404, reasonPhrase: "Продукт не найден"))
        }
        let cart = try await Cart.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .with(\.$items) {
                $0.with(\.$product) {
                    $0.with(\.$category)
                }
            }
            .first()
        if let cart {
            if let cartItem = cart.items.first(where: { $0.product.id == product.id }) {
                if cartRequest.quantity == 0 {
                    try await cartItem.delete(on: req.db)
                } else {
                    cartItem.quantity = cartRequest.quantity
                    cartItem.price = cartItem.product.price * Decimal(cartItem.quantity)
                    try await cartItem.save(on: req.db)
                }
                cart.totalAmount = cart.items.reduce(Decimal(0), { result, item in result + item.price })
                try await cart.save(on: req.db)
            } else {
                let cartItem = try CartItem(
                    id: .generateRandom(),
                    cartId: cart.requireID(),
                    productId: product.requireID(),
                    quantity: cartRequest.quantity,
                    price: product.price * Decimal(cartRequest.quantity)
                )
                try await cartItem.save(on: req.db)
            }
            let cartFromBd = try await Cart.query(on: req.db)
                .filter(\.$user.$id == user.requireID())
                .with(\.$items) {
                    $0.with(\.$product) {
                        $0.with(\.$category)
                    }
                }
                .first()
            guard let cartFromBd else {
                throw Abort(.badRequest)
            }
            return try cartFromBd.response()
        } else {
            let cart = Cart(
                id: .generateRandom(),
                userId: try user.requireID(),
                totalAmount: 0
            )
            try await cart.save(on: req.db)
            let cartItem = try CartItem(
                id: .generateRandom(),
                cartId: cart.requireID(),
                productId: product.requireID(),
                quantity: cartRequest.quantity,
                price: product.price * Decimal(cartRequest.quantity)
            )
            try await cartItem.save(on: req.db)
            let cartFromBd = try await Cart.query(on: req.db)
                .filter(\.$user.$id == user.requireID())
                .with(\.$items) {
                    $0.with(\.$product) {
                        $0.with(\.$category)
                    }
                }
                .first()
            guard let cartFromBd else {
                throw Abort(.badRequest)
            }
            return try cartFromBd.response()
        }
    }
}
