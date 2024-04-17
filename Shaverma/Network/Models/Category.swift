//
//  Category.swift
//  Shaverma
//
//  Created by Иван Копиев on 02.04.2024.
//

import Foundation

struct Category: Codable {
    let id: UUID
    let name: String
}
extension Category {
    static let categories: [Category] = [
        .init(id: .init(), name: "Шаурма"),
        .init(id: .init(), name: "Закуски"),
        .init(id: .init(), name: "Напитки"),
        .init(id: .init(), name: "Соусы")
    ]
}

