//
//  NetworkService.swift
//  Shaverma
//
//  Created by Иван Копиев on 02.04.2024.
//

import Foundation

protocol NetworkService: AnyObject {
    func send(_ request: URLRequest) async throws
    func send(_ request: URLRequest) async throws -> Data
    func send<T: Decodable>(_ request: URLRequest) async throws -> T
}

final class BaseNetworkService: NetworkService {

    private let session: URLSession

    init(
        session: URLSession = URLSession(
            configuration: .default
        )
    ) {
        self.session = session
    }

    func send(_ request: URLRequest) async throws {
        _ = try await session.data(for: request)
    }

    func send(_ request: URLRequest) async throws -> Data {
        try await session.data(for: request).0
    }

    func send<T: Decodable>(_ request: URLRequest) async throws -> T {
        let data = try await session.data(for: request).0
        do {
            let resp = try JSONDecoder().decode(T.self, from: data)
            return resp
        } catch {
            if let error = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                switch error.reason {
                case .unauthorized:
                    DispatchQueue.main.async {
                        Navigator.shared.makeRoot(screen: AuthScreen())
                    }
                default: break
                }
                throw error
            } else {
                throw error
            }
        }
    }
}
