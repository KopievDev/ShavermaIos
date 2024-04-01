import Fluent
import Vapor
import VaporToOpenAPI

func routes(_ app: Application) throws {
    /// Token check
    let tokenProtected = app.grouped(UserToken.authenticator()).grouped("api", "v1")
    try app.register(collection: OpenAPIController())
    try app.register(collection: AuthController(app: app))
    try app.register(collection: UsersContoller(tokenProtected: tokenProtected))
}
