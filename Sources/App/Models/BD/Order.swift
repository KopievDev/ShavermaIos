//
//  File.swift
//  
//
//  Created by Иван Копиев on 18.04.2024.
//

import Vapor
import Fluent
import Foundation

final class Order: Model, Content {
    static let schema = "orders"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User  // Ссылка на пользователя

    @Field(key: "total_amount")
    var totalAmount: Decimal

    @Children(for: \.$order)
    var items: [OrderItem]

    init() { }

    init(id: UUID? = nil, userId: User.IDValue, totalAmount: Decimal) {
        self.id = id
        self.$user.id = userId
        self.totalAmount = totalAmount
    }
}

extension Order {
    struct Migration: AsyncMigration {
        var name: String { "CreateOrder" }

        func prepare(on database: Database) async throws {
            try await database.schema(Order.schema)
                .id()
                .field("user_id", .uuid, .references("users", "id", onDelete: .cascade))
                .field("cart_id", .uuid, .references("carts", "id", onDelete: .cascade))
                .field("product_id", .uuid, .references("products", "id", onDelete: .cascade))
                .field("total_amount", .double, .required)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Order.schema).delete()
        }
    }
}
