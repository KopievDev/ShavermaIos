//
//  UsersContoller.swift
//
//
//  Created by Иван Копиев on 01.04.2024.
//

import Foundation
import Vapor
import VaporToOpenAPI

struct UsersContoller: RouteCollection {

    let tokenProtected: RoutesBuilder

    func boot(routes: RoutesBuilder) throws {
        let users = tokenProtected.grouped("users")
        users.get("me", use: me)
            .openAPI(
                tags: .init(name: "Users"),
                summary: "Профиль",
                description: "Данные профиля",
                headers: .all(of: .type(Headers.AccessToken.self)),
                contentType: .application(.json),
                response: .type(UserResponse.self),
                responseContentType: .application(.json),
                responseDescription: "Success response"
            )

        func me(req: Request) async throws -> UserResponse {
            let user = try req.auth.require(User.self)
            return UserResponse(name: user.name, familyName: user.familyName, email: user.email, phone: user.phone)
        }
    }
}
