//
//  ProductsResponse.swift
//  
//
//  Created by Иван Копиев on 03.04.2024.
//

import Vapor
import Foundation
import SwiftOpenAPI
import VaporToOpenAPI

@OpenAPIDescriptable()
/// Продукты
struct ProductsResponse: Content, WithExample {
    /// id
    let id: UUID
    /// Название продукта
    let name: String
    /// Описание продукта
    let desc: String
    /// Изображение продукта
    let imageUrl: String?
    /// Стоимость в копейках
    let price: Decimal
    /// Категория продукта
    let category: UUID

    static var example: ProductsResponse = .init(
        id: .generateRandom(),
        name: "Шаурма",
        desc: "Из котят",
        imageUrl: "https://mustdev.ru/vkr/sh1.png",
        price: 19900,
        category: .generateRandom()
    )
}

@OpenAPIDescriptable()
/// Создание продукта
struct ProductsRequest: Content, WithExample {
    /// Название продукта
    let name: String
    /// Описание продукта
    let desc: String
    /// Изображение продукта
    let imageUrl: String?
    /// Стоимость в копейках
    let price: Decimal
    /// Категория продукта
    let category: UUID

    static var example: ProductsRequest = .init(
        name: "Шаурма",
        desc: "Из котят",
        imageUrl: "https://mustdev.ru/vkr/sh1.png",
        price: 19900,
        category: .generateRandom()
    )
}
