//
//  ShavermaAPI.swift
//  Shaverma
//
//  Created by Иван Копиев on 02.04.2024.
//

import Foundation

struct ShavermaAPI {

    var token = "oRyL1YTgXcocQNE4WBPJJQ=="
    private var baseUrl: String { "http://45.82.153.105:8080/api/v1/" }

    private let network = BaseNetworkService(
        session: URLSession(configuration: .default)
    )
    private func request(endpoint: String) -> URLRequest? {
        guard let url = URL(string: baseUrl + endpoint) else { return nil }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }

    func categories() async throws -> [Category] {
        guard let request = request(endpoint: "categories") else {
            throw NSError(domain: "Bad request", code: -1)
        }
        return try await network.send(request)
    }
}
