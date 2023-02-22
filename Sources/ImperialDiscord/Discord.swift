@_exported import ImperialCore
import Vapor

public class Discord: FederatedService {
    public var tokens: FederatedServiceTokens
    public var router: FederatedServiceRouter

    @discardableResult
    public required init(
        routes: RoutesBuilder,
        authenticate: String,
        authenticateCallback: ((Request) throws -> (EventLoopFuture<Void>))?,
        callback: String,
        scope: [String] = [],
        state: String?,
        completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
    ) throws {
        self.router = try DiscordRouter(callback: callback, completion: completion)
        self.tokens = self.router.tokens

        self.router.scope = scope
        self.router.state = state
        try self.router.configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)

        OAuthService.register(.discord)
    }
}
