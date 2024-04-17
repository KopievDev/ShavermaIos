//
//  PromoResponse.swift
//  Shaverma
//
//  Created by Иван Копиев on 17.04.2024.
//

import Foundation

struct PromoResponse: Codable {
    let id: UUID
    let title: String
    let desc: String
    let imageUrl: String
}
