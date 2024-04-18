import Fluent
import Vapor
import VaporToOpenAPI

func routes(_ app: Application) throws {
    /// Token check
    let tokenProtected = app.grouped(UserToken.authenticator()).grouped("api", "v1")
    try app.register(collection: OpenAPIController())
    try app.register(collection: AuthController(app: app))
    try app.register(collection: UsersContoller(tokenProtected: tokenProtected))
    try app.register(collection: ProductsController(tokenProtected: tokenProtected))
    try app.register(collection: AdminController(tokenProtected: tokenProtected))
    try app.register(collection: PromoController(tokenProtected: tokenProtected))
    try app.register(collection: OrderController(tokenProtected: tokenProtected))
}
