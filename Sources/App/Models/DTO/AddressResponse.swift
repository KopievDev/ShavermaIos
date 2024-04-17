//
//  AddressResponse.swift
//  
//
//  Created by Иван Копиев on 16.04.2024.
//

import Vapor
import Foundation
import SwiftOpenAPI
import VaporToOpenAPI

@OpenAPIDescriptable()
/// Объект адреса
struct AddressResponse: Content, WithExample {
    ///Текстовое значение адреса
    let text: String
    ///широта
    let latitude: Double
    ///долгота
    let longitude: Double

    static var example: AddressResponse = .init(text: "Москва, Рязановское шоссе, 23к1, 387", latitude: 123, longitude: 123)
}

