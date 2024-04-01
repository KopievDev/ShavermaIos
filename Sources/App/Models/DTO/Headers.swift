//
//  File.swift
//  
//
//  Created by Иван Копиев on 01.04.2024.
//

import Foundation
import VaporToOpenAPI

public enum Headers {

    /// Basic authorization
    @OpenAPIDescriptable()
    public struct Authorization: Codable, WithExample {
        /// Basic base64(test:secret)
        public var authorization: String

        public enum CodingKeys: String, CodingKey {

            case authorization = "Authorization"
        }

        public static let example = Authorization(authorization: "Basic dGVzdDpzZWNyZXQ=")
    }

    /// Access token
    @OpenAPIDescriptable()
    public struct AccessToken: Codable, WithExample {
        /// token from login || register request
        public var authorization: String

        public enum CodingKeys: String, CodingKey {

            case authorization = "Authorization"
        }

        public static let example = AccessToken(authorization: "Bearer wfv9034fho4g34g4==")
    }
}
