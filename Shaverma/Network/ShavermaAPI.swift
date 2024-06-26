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

    private var baseUrl: String { "https://shavastreet.ru/api/v1/" }

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
        CartStorage.shared.logout()
        guard !token.isEmpty else { return }
        Task {
            do {
                _ = try await logout()
                token = ""
            } catch {
                token = ""
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

    /// Регистрация
    func register(model: RegisterRequest) async throws -> TokenResponse {
        guard let request = request(endpoint: "register", method: .post, body: model) else {
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
    func products(category: Category) async throws -> [ProductResponse] {
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

    /// Получить адрес
    func getAdrress() async throws -> AddressResponse {
        guard let request = request(endpoint: "users/address", method: .get) else {
            throw NSError(domain: "Bad request", code: -1)
        }
        return try await network.send(request)
    }
    
    /// Получить промо акции
    func getPromos() async throws -> [PromoResponse] {
        guard let request = request(endpoint: "promo", method: .get) else {
            throw NSError(domain: "Bad request", code: -1)
        }
        return try await network.send(request)
    }

    /// Получить профиль
    func getMe() async throws -> UserResponse {
        guard let request = request(endpoint: "users/me") else {
            throw NSError(domain: "Bad request", code: -1)
        }
        return try await network.send(request)
    }

    /// Получить промо акции
    func getCart() async throws -> CartResponse {
        guard let request = request(endpoint: "cart") else {
            throw NSError(domain: "Bad request", code: -1)
        }
        return try await network.send(request)
    }

    /// Получить промо акции
    func putCart(model: CartRequest) async throws -> CartResponse {
        guard let request = request(endpoint: "cart", method: .put, body: model) else {
            throw NSError(domain: "Bad request", code: -1)
        }
        return try await network.send(request)
    }

    /// Оформить заказ
    func order(model: OrderRequest) async throws -> OrderResponse {
        guard let request = request(endpoint: "cart/order", method: .post, body: model) else {
            throw NSError(domain: "Bad request", code: -1)
        }
        return try await network.send(request)
    }
    /// Получить список заказов
    func orders() async throws -> [OrderResponse] {
        guard let request = request(endpoint: "cart/orders") else {
            throw NSError(domain: "Bad request", code: -1)
        }
        return try await network.send(request)
    }
}
