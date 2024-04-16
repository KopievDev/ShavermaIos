import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(
        FileMiddleware(
            publicDirectory: app.directory.publicDirectory,
            defaultFile: "index.html"
        )
    )

    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(User.Migration())
    app.migrations.add(User.AddRoleMigration())
    app.migrations.add(UserToken.Migration())
    app.migrations.add(Categoties.Migration())
    app.migrations.add(Products.Migration())
    app.migrations.add(Products.AddImageMigration())
    app.migrations.add(Addresses.Migration())
//    app.migrations.add(User.AddAddressMigration())


    try await app.autoMigrate()

    let encoder = JSONEncoder()
    encoder.outputFormatting = .sortedKeys
    ContentConfiguration.global.use(encoder: encoder, for: .json)
    try routes(app)
}
