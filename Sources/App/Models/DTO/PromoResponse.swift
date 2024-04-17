//
//  PromoResponse.swift
//
//
//  Created by Иван Копиев on 16.04.2024.
//

import Vapor
import Foundation
import SwiftOpenAPI
import VaporToOpenAPI

@OpenAPIDescriptable()
/// Объект промо
struct PromoResponse: Content, WithExample {
    /// id
    let id: UUID
    /// Заглавие
    let title: String
    /// Описание
    let desc: String
    /// Изображение
    let imageUrl: String

    static var example: PromoResponse = .init(id: .generateRandom(), title: "5ая шаурма в подарок", desc: "Описание", imageUrl: "someUrl")
}
