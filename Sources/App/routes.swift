import Fluent
import Vapor
import VaporToOpenAPI

func routes(_ app: Application) throws {
    try app.register(collection: OpenAPIController())
    try app.register(collection: AuthController(app: app))
}
