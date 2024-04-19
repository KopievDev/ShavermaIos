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

    @Field(key: "address")
    var address: String  // Строковый параметр адреса

    @Field(key: "order_number")
    var orderNumber: Int  // Числовой параметр номера заказа

    init() { }

    init(id: UUID? = nil, userId: User.IDValue, totalAmount: Decimal, address: String, orderNumber: Int) {
        self.id = id
        self.$user.id = userId
        self.totalAmount = totalAmount
        self.address = address
        self.orderNumber = orderNumber
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
                .field("address", .string, .required)
                .field("order_number", .int, .required)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Order.schema).delete()
        }
    }

//    struct UpdateOrderAddFields: AsyncMigration {
//        var name: String { "UpdateOrderAddFields" }
//
//        func prepare(on database: Database) async throws {
//            try await database.schema(Order.schema)
//                .field("address", .string, .required)
//                .field("order_number", .int, .required)
//                .update()
//        }
//
//        func revert(on database: Database) async throws {
//            try await database.schema(Order.schema)
//                .deleteField("address")
//                .deleteField("order_number")
//                .update()
//        }
//    }
}


extension Order {
    
    func response() throws -> OrderResponse {
        try .init(
            id: try requireID(),
            numberOrder: orderNumber,
            address: address,
            products: items.map { try $0.response() },
            totalAmount: totalAmount
        )
    }
}

extension OrderItem {
    func response() throws -> OrderItemResponse {
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
