//
//  RegisterRequest.swift
//  Shaverma
//
//  Created by Иван Копиев on 17.04.2024.
//

import Foundation

struct RegisterRequest: Codable {
    let email: String
    let familyName: String
    let name: String
    let password: String
    let phone: String
}
