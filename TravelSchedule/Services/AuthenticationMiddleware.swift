import OpenAPIRuntime
import Foundation
import HTTPTypes

struct AuthenticationMiddleware: ClientMiddleware {
    let apikey: String
    
    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @concurrent (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var modifiedRequest = request
        
        modifiedRequest.headerFields[.authorization] = apikey
        return try await next(modifiedRequest, body, baseURL)
    }
}
