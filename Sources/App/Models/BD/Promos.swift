//
//  File.swift
//  
//
//  Created by Иван Копиев on 16.04.2024.
//

import Fluent
import Vapor

final class Promos: Model, Content {
    static let schema = "promos"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String
    @Field(key: "desc")
    var desc: String
    @Field(key: "imageUrl")
    var imageUrl: String

    init() { }

    init(id: UUID? = nil, title: String, desc: String, imageUrl: String) {
        self.id = id
        self.title = title
        self.desc = desc
        self.imageUrl = imageUrl
    }
}


extension Promos {

    func response() throws -> PromoResponse {
         try .init(id: requireID(), title: title, desc: desc, imageUrl: imageUrl)
    }

    func update(with model: PromoResponse, on db: Database) async throws {
        title = model.title
        desc = model.desc
        imageUrl = model.imageUrl
        try await save(on: db)
    }
}


extension Promos {
    struct Migration: AsyncMigration {
        var name: String { "CreatePromos" }

        func prepare(on database: Database) async throws {
            try await database.schema(Promos.schema)
                .id()
                .field("title", .string, .required)
                .field("desc", .double, .required)
                .field("imageUrl", .double, .required)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Promos.schema).delete()
        }
    }
}

