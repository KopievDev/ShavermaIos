//
//  File.swift
//  
//
//  Created by Иван Копиев on 17.04.2024.
//

import Vapor
import Fluent
import Foundation

final class CartItem: Model {
    static let schema = "cart_items"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "cart_id")
    var cart: Cart  // Ссылка на корзину

    @Parent(key: "product_id")
    var product: Products  // Ссылка на продукт

    @Field(key: "quantity")
    var quantity: Int

    @Field(key: "price")
    var price: Decimal

    init() { }

    init(id: UUID? = nil, cartId: Cart.IDValue, productId: Products.IDValue, quantity: Int, price: Decimal) {
        self.id = id
        self.$cart.id = cartId
        self.$product.id = productId
        self.quantity = quantity
        self.price = price
    }
}

extension CartItem {
    struct Migration: AsyncMigration {
        var name: String { "CreateCartItem" }
        
        func prepare(on database: Database) async throws {
            try await database.schema(CartItem.schema)
                .id()
                .field("cart_id", .uuid, .references("carts", "id", onDelete: .cascade))
                .field("product_id", .uuid, .references("products", "id"))
                .field("quantity", .int, .required)
                .field("price", .double, .required)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(CartItem.schema).delete()
        }
    }
}
