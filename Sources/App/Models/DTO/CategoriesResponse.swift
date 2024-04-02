//
//  CategoriesResponse.swift
//  
//
//  Created by Иван Копиев on 02.04.2024.
//

import Vapor
import Foundation
import SwiftOpenAPI
import VaporToOpenAPI

@OpenAPIDescriptable()
/// Категории
struct CategoriesResponse: Content, WithExample {
    /// id
    let id: UUID
    let name: String

    static var example: CategoriesResponse = .init(id: .generateRandom(), name: "Шаурма")
}
