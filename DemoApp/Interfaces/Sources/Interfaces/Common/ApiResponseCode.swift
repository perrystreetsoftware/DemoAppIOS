public enum ApiResponseCode: Int, CaseIterable {
    case unknown = -1

    case success = 200

    case redirect = 302

    case badRequest = 400
    case notAuthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case methodNotAcceptable = 406
    case requestTimeout = 408
    case conflict = 409

    case serverError = 500
    case notImplemented = 501
    case badGateway = 502
    case loadBalancerError = 503
}
