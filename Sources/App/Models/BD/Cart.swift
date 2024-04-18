//
//  Cart.swift
//
//
//  Created by Иван Копиев on 17.04.2024.
//

import Foundation
import Fluent
import Vapor

final class Cart: Model, Content {
    static let schema = "carts"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User  // Ссылка на пользователя

    @Field(key: "total_amount")
    var totalAmount: Decimal

    @Children(for: \.$cart)
    var items: [CartItem]  // Связь с элементами корзины

    init() { }

    init(id: UUID? = nil, userId: User.IDValue, totalAmount: Decimal) {
        self.id = id
        self.$user.id = userId
        self.totalAmount = totalAmount
    }
}

extension Cart {
    struct Migration: AsyncMigration {
        var name: String { "CreateCart" }

        func prepare(on database: Database) async throws {
            try await database.schema(Cart.schema)
                    .id()
                    .field("user_id", .uuid, .references("users", "id"))
                    .field("total_amount", .double, .required)
                    .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Cart.schema).delete()
        }

    }
}

extension Cart {
    func response() throws -> CartResponse {
        try .init(
            id: requireID(),
            products: items.map { try $0.response() },
            totalAmount: items.reduce(Decimal(0), { result, item in result + item.price })
        )
    }
}

extension CartItem {
    func response() throws -> CartItemResponse {
        .init(
            id: try requireID(),
            product: .init(
                id: try product.requireID(),
                name: product.name,
                desc: product.desc,
                imageUrl: product.image,
                price: product.price,
                category: try product.category.requireID()
            ),
            quantity: quantity,
            price: Decimal(quantity) * product.price
        )
    }
}
