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

        cart.post("order", use: orderCart)
            .openAPI(
                tags: .init(name: "Order"),
                summary: "Оформить заказ",
                description: "Оформление текущей корзины",
                headers: .all(of: .type(Headers.AccessToken.self)),
                body: .all(of: .type(OrderRequest.self)),
                contentType: .application(.json),
                response: .type(OrderResponse.self),
                responseContentType: .application(.json),
                responseDescription: "Success response"
            )
        cart.get("orders", use: getOrders)
            .openAPI(
                tags: .init(name: "Order"),
                summary: "Список заказов",
                description: "Список заказов пользователя",
                headers: .all(of: .type(Headers.AccessToken.self)),
                contentType: .application(.json),
                response: .type([OrderResponse].self),
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
            return try await getCartResponseFromBD(user: user, db: req.db)
        }
    }

    func getOrders(req: Request) async throws -> [OrderResponse] {
        let user = try req.auth.require(User.self)
        let orders = try await Order.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .with(\.$items) {
                $0.with(\.$product) {
                    $0.with(\.$category)
                }
            }
            .all()
        return try orders.map { try $0.response() }
    }

    func orderCart(req: Request) async throws -> OrderResponse {
        let user = try req.auth.require(User.self)
        let orderRequest = try req.content.decode(OrderRequest.self)
        // Ищем корзину и адрес пользователя
        guard
            let cart = try await getCartFromBD(user: user, db: req.db),
            let address = try await getAddress(user: user, db: req.db)
        else {
            throw Abort(.notFound)
        }
        // Получаем последний номер заказа
        let lastNumber = try await OrderSequence.query(on: req.db).all().last
        let currentOrder: OrderSequence
        if let lastNumber {
            let number = lastNumber.currentOrderNumber + 1
            currentOrder = .init(id: .generateRandom(), currentOrderNumber: number)
        } else {
            currentOrder = .init(id: .generateRandom(), currentOrderNumber: 1)
        }
        try await currentOrder.save(on: req.db)
        let order = try Order(
            id: .generateRandom(),
            userId: user.requireID(),
            totalAmount: cart.items.reduce(Decimal(0), { result, item in result + item.price }),
            address: address.text,
            orderNumber: currentOrder.currentOrderNumber
        )
        try await order.save(on: req.db)
        let items = try cart.items.map {
            OrderItem(
                id: .generateRandom(),
                orderId: try order.requireID(),
                productId: try $0.product.requireID(),
                quantity: $0.quantity,
                price: $0.price
            )
        }
        for item in items {
            try await item.save(on: req.db)
        }
        let orderResponse = try await getOrderResponse(id: order.requireID(), user: user, db: req.db)
        try await req.sendTG(message: orderResponse.orderMessage(payment: orderRequest.payment, user: user))
        try await cart.delete(on: req.db)
        return orderResponse
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
            return try await getCartResponseFromBD(user: user, db: req.db)
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
            return try await getCartResponseFromBD(user: user, db: req.db)
        }
    }

    func getCartResponseFromBD(user: User, db: Database) async throws -> CartResponse {
        let cartFromBd = try await Cart.query(on: db)
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

    func getCartFromBD(user: User, db: Database) async throws -> Cart? {
         try await Cart.query(on: db)
            .filter(\.$user.$id == user.requireID())
            .with(\.$items) {
                $0.with(\.$product) {
                    $0.with(\.$category)
                }
            }.first()
    }

    func getAddress(user: User, db: Database) async throws -> Addresses? {
        try await Addresses.query(on: db)
            .filter(\.$user.$id == user.requireID())
            .first()
    }

    func getOrderResponse(id: UUID, user: User, db: Database) async throws -> OrderResponse {
        let orderFromBd = try await Order.query(on: db)
            .filter(\.$user.$id == user.requireID())
            .filter(\.$id == id)
            .with(\.$items) {
                $0.with(\.$product) {
                    $0.with(\.$category)
                }
            }
            .first()
        guard let orderFromBd else {
            throw Abort(.badRequest)
        }
        return try orderFromBd.response()
    }
}
