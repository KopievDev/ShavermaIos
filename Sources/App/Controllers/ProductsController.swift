//
//  ProductsController.swift
//
//
//  Created by Иван Копиев on 02.04.2024.
//

import Foundation
import Vapor
import VaporToOpenAPI

struct ProductsController: RouteCollection {

    let tokenProtected: RoutesBuilder

    func boot(routes: RoutesBuilder) throws {
        let users = tokenProtected.grouped("categories")
        users.get(use: categories)
            .openAPI(
                tags: .init(name: "Products"),
                summary: "Категории",
                description: "Список доступных категорий",
                headers: .all(of: .type(Headers.AccessToken.self)),
                contentType: .application(.json),
                response: .type([CategoriesResponse].self),
                responseContentType: .application(.json),
                responseDescription: "Success response"
            )

        func categories(req: Request) async throws -> [CategoriesResponse] {
            _ = try req.auth.require(User.self)
            let categories = try await Categoties.query(on: req.db).all()
            return categories.map { CategoriesResponse(id: $0.id ?? .generateRandom(), name: $0.name) }
        }
    }
}
