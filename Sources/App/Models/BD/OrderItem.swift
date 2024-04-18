//
//  File.swift
//  
//
//  Created by Иван Копиев on 18.04.2024.
//

import Vapor
import Fluent
import Foundation

// Модель для связанных элементов заказа (позиции в заказе)
final class OrderItem: Model, Content {
    static let schema = "order_items"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "order_id")
    var order: Order

    @Parent(key: "product_id")
    var product: Products  // Ссылка на продукт

    @Field(key: "quantity")
    var quantity: Int

    @Field(key: "price")
    var price: Decimal

    init() { }

    init(id: UUID? = nil, orderId: Order.IDValue, productId: Products.IDValue, quantity: Int, price: Decimal) {
        self.id = id
        self.$order.id = orderId
        self.$product.id = productId
        self.quantity = quantity
        self.price = price
    }
}

extension OrderItem {
    struct Migration: AsyncMigration {
        var name: String { "CreateOrderItem" }

        func prepare(on database: Database) async throws {
            try await database.schema(OrderItem.schema)
                .id()
                .field("order_id", .uuid, .references("orders", "id", onDelete: .cascade))
                .field("product_id", .uuid, .references("products", "id", onDelete: .cascade))
                .field("quantity", .int, .required)
                .field("price", .double, .required)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(OrderItem.schema).delete()
        }
    }
}
