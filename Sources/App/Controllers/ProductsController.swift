//
//  ProductsController.swift
//
//
//  Created by Иван Копиев on 02.04.2024.
//

import Foundation
import Vapor
import VaporToOpenAPI
import Fluent

struct ProductsController: RouteCollection {

    let tokenProtected: RoutesBuilder

    func boot(routes: RoutesBuilder) throws {
        let category = tokenProtected.grouped("categories")
        category.get(use: categories)
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

        let productRoute = tokenProtected.grouped("products")
        productRoute.get(use: products)
            .openAPI(
                tags: .init(name: "Products"),
                summary: "Список всех продуктов",
                description: "Список всех доступных продуктов",
                headers: .all(of: .type(Headers.AccessToken.self)),
                contentType: .application(.json),
                response: .type([ProductsResponse].self),
                responseContentType: .application(.json),
                responseDescription: "Success response"
            )

        productRoute.post(use: createProduct)
            .openAPI(
                tags: .init(name: "Products"),
                summary: "Добавить продукт",
                description: "Добавление продукта в БД",
                headers: .all(of: .type(Headers.AccessToken.self)),
                body: .type(ProductsRequest.self),
                contentType: .application(.json),
                response: .type(ProductsResponse.self),
                responseContentType: .application(.json),
                responseDescription: "Success response"
            )
        productRoute.get(":id", use: productForCategoryID)
            .openAPI(
                tags: .init(name: "Products"),
                summary: "Продукты категории",
                description: "Продукты опредененной категории",
                headers: .all(of: .type(Headers.AccessToken.self)),
                path: .schema(.uuid),
                contentType: .application(.json),
                response: .type([ProductsResponse].self),
                responseContentType: .application(.json),
                responseDescription: "Success response"
            )
    }

    func categories(req: Request) async throws -> [CategoriesResponse] {
        _ = try req.auth.require(User.self)
        let categories = try await Categoties.query(on: req.db).all()
        return categories.map { CategoriesResponse(id: $0.id ?? .generateRandom(), name: $0.name) }
    }

    func products(req: Request) async throws -> [ProductsResponse] {
        _ = try req.auth.require(User.self)
        let products = try await Products.query(on: req.db).all()
        for product in products {
            product.image = "https://mustdev.ru/vkr/sh1.png"
            try await product.save(on: req.db)
        }
        return products.map {
            ProductsResponse(
                id: $0.id ?? .generateRandom(),
                name: $0.name,
                desc: $0.desc,
                imageUrl: $0.image,
                price: $0.price,
                category: $0.$category.id
            )
        }
    }

    func productForCategoryID(req: Request) async throws -> [ProductsResponse] {
        let user = try req.auth.require(User.self)
        guard let categoryId = req.parameters.get("id"), let id = UUID(uuidString: categoryId) else {
            throw Abort(.custom(code: 404, reasonPhrase: "Нет такой категории"))
        }
        let products = try await Products
            .query(on: req.db)
            .filter(\.$category.$id == id)
            .all()

        return try products.map {
            ProductsResponse(
                id: try $0.requireID(),
                name: $0.name,
                desc: $0.desc,
                imageUrl: $0.image,
                price: $0.price,
                category: $0.$category.id
            )
        }
    }

    func createProduct(req: Request) async throws -> ProductsResponse {
        let user = try req.auth.require(User.self)
        guard user.role == .admin else {
            throw Abort(.forbidden)
        }
        let productRequest = try req.content.decode(ProductsRequest.self)

        let category = try await Categoties
            .query(on: req.db)
            .filter(\.$id == productRequest.category)
            .first()
        guard let category else {
            throw Abort(.custom(code: 404, reasonPhrase: "Нет такой категории"))
        }

        let product = try Products(
            id: .generateRandom(),
            name: productRequest.name,
            desc: productRequest.desc,
            price: productRequest.price,
            categoryID: category.requireID()
        )

        try await product.save(on: req.db)

        return try ProductsResponse(
            id: product.requireID(),
            name: product.name,
            desc: product.desc,
            imageUrl: product.image,
            price: product.price,
            category: category.requireID()
        )
    }

}
