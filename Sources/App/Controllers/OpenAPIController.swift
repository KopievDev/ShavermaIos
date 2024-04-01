//
//  OpenAPIController.swift
//  
//
//  Created by Иван Копиев on 31.03.2024.
//

import Vapor
import VaporToOpenAPI

struct OpenAPIController: RouteCollection {

    // MARK: Internal
    func boot(routes: RoutesBuilder) throws {
        routes.get("swagger", "swagger.json") { req in
            req.application.routes.openAPI(
                info: InfoObject(
                    title: "Swagger Шаурма на районе API - OpenAPI 3.0",
                    description: "ВКР Копиев ИВ ИЭоз-60а-19",
                    version: Version(1, 0, 0)
                )
            )
        }
        .excludeFromOpenAPI()
    }
}
