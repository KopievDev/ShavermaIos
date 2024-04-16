//
//  ShavermaAPI.swift
//  Shaverma
//
//  Created by Иван Копиев on 02.04.2024.
//

import Foundation

final class ShavermaAPI {

    enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    ///"oRyL1YTgXcocQNE4WBPJJQ=="
    @PreferencesStored(key: ApplicationPreferencesKey.authToken)
    var token: String = ""

    static let shared = ShavermaAPI()

    private var baseUrl: String { "http://45.82.153.105:8080/api/v1/" }

    private let network = BaseNetworkService()

    private func request(
        endpoint: String,
        basic: String? = nil,
        method: Method = .get,
        body: Encodable? = nil
    ) -> URLRequest? {
        guard let url = URL(string: baseUrl + endpoint) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if !token.isEmpty {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let basic, let base = basic.data(using: .utf8)?.base64EncodedString() {
            request.addValue("Basic \(base)", forHTTPHeaderField: "Authorization")
        }
        if let body, let data = try? JSONEncoder().encode(body) {
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }

    func logout() {
        Task {
            do {
                token = ""
                _ = try await logout()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct TokenResponse: Codable {
    let token: String
}

struct MessageResponse: Codable {
    let message: String
}

// MARK: - Requests -

extension ShavermaAPI {
    /// Авторизация
    func login(email: String, password: String) async throws -> TokenResponse {
        guard let request = request(endpoint: "login", basic: "\(email):\(password)") else {
            throw NSError(domain: "Bad request", code: -1)
        }
        return try await network.send(request)
    }

    /// Выход
    func logout() async throws -> MessageResponse {
        guard let request = request(endpoint: "logout") else {
            throw NSError(domain: "Bad request", code: -1)
        }
        return try await network.send(request)
    }
    /// Список категорий
    func categories() async throws -> [Category] {
        guard let request = request(endpoint: "categories") else {
            throw NSError(domain: "Bad request", code: -1)
        }
        return try await network.send(request)
    }

    /// Список продуктов категории
    func products(category: Category) async throws -> [Product] {
        guard let request = request(endpoint: "products/\(category.id.uuidString)") else {
            throw NSError(domain: "Bad request", code: -1)
        }
        return try await network.send(request)
    }

    /// Обновить адрес
    func saveAdrress(_ model: AddressResponse) async throws -> AddressResponse {
        guard let request = request(endpoint: "users/address", method: .put, body: model) else {
            throw NSError(domain: "Bad request", code: -1)
        }
        return try await network.send(request)
    }

    /// Обновить адрес
    func getAdrress() async throws -> AddressResponse {
        guard let request = request(endpoint: "users/address", method: .get) else {
            throw NSError(domain: "Bad request", code: -1)
        }
        return try await network.send(request)
    }
}
