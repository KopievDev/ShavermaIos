//
//  Products.swift
//
//
//  Created by Иван Копиев on 01.04.2024.
//

import Fluent
import Vapor

final class Products: Model, Content {
    static let schema = "products"

    @ID(key: .id)
    var id: UUID?
    @Field(key: "name")
    var name: String
    @Field(key: "desc")
    var desc: String
    @Field(key: "price")
    var price: Decimal
    @Parent(key: "category_id")
    var category: Categoties

    init() { }

    init(
        id: UUID? = .generateRandom(),
        name: String,
        desc: String,
        price: Decimal = 0,
        categoryID: Categoties.IDValue
    ) {
        self.id = id
        self.name = name
        self.desc = desc
        self.price = price
        self.$category.id = categoryID
    }
}

// MARK: - Migration -
extension Products {
    struct Migration: AsyncMigration {
        var name: String { "CreateProducts" }

        func prepare(on database: Database) async throws {
            try await database.schema(Products.schema)
                .id()
                .field("name", .string, .required)
                .field("desc", .string, .required)
                .field("price", .double)
                .field("category_id", .uuid, .required, .references("categories", "id"))
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Products.schema).delete()
        }
    }
}

