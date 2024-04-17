//
//  ErrorResponse.swift
//  Shaverma
//
//  Created by Иван Копиев on 16.04.2024.
//

import Foundation

/// Protocol to support incremental changes in enum
public protocol UnsupportedCase: RawRepresentable, CaseIterable where RawValue: Equatable & Decodable {
    static var unsupportedCase: Self { get }
}

extension UnsupportedCase {
    public init(rawValue: RawValue) {
        self = Self.allCases.first { $0.rawValue == rawValue } ?? Self.unsupportedCase
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(RawValue.self)
        self = Self(rawValue: rawValue) ?? Self.unsupportedCase
    }
}

struct ErrorResponse: Error, Codable {
    let error: Bool
    let reason: Reason

    enum Reason: String, Codable {
        case unauthorized = "Unauthorized"
        case forbidden = "Forbidden"
        case notFound = "NotFound"
        case unknown = "Unknown"
        case badRequest = "Bad Request"
        case methodNotAllowed = "Method Not Allowed"
        case notAcceptable = "Not Acceptable"
        case internalServerError = "Internal Server Error"
        case notImplemented = "Not Implemented"
        case badGateway = "Bad Gateway"
        case serviceUnavailable = "Service Unavailable"
        case gatewayTimeout = "Gateway Timeout"
    }
}

struct ErrorRowResponse: Error, LocalizedError, Codable {
    let error: Bool
    let reason: String

    var errorDescription: String? {
        reason
    }
}
