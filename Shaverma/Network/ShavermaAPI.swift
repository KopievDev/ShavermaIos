//
//  ShavermaAPI.swift
//  Shaverma
//
//  Created by Иван Копиев on 02.04.2024.
//

import Foundation

final class ShavermaAPI {

    ///"oRyL1YTgXcocQNE4WBPJJQ=="
    @PreferencesStored(wrappedValue: nil, key: ApplicationPreferencesKey.authToken)
    var token: String?

    static let shared = ShavermaAPI()

    private var baseUrl: String { "http://45.82.153.105:8080/api/v1/" }

    private let network = BaseNetworkService()

    private func request(endpoint: String, basic: String? = nil) -> URLRequest? {
        guard let url = URL(string: baseUrl + endpoint) else { return nil }
        var request = URLRequest(url: url)
        if let token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let basic, let base = basic.data(using: .utf8)?.base64EncodedString() {
            request.addValue("Basic \(base)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}

struct TokenResponse: Codable {
    let token: String
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
    /// Список категорий
    func categories() async throws -> [Category] {
        guard let request = request(endpoint: "categories") else {
            throw NSError(domain: "Bad request", code: -1)
        }
        return try await network.send(request)
    }
}
