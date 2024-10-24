import Foundation

public enum SMError: Error, Equatable {
    case badRequest
    case forbidden
    case notFound
    case timedOut
    case unauthorized
    case decodingFailed
    case internalServerError
    case notConnectedToHost
    case notConnectedToInternet
    case unknown
    case failed(title: String, contents: String?, isBack: Bool)
    
    public init(statusCode: Int) {
        switch statusCode {
        case 400: self = .badRequest
        case 401: self = .unauthorized
        case 403: self = .forbidden
        case 404: self = .notFound
        case 500: self = .internalServerError
        default: self = .internalServerError
        }
    }
    
    public var title: String {
        switch self {
        case let .failed(title, _, _): return title
        default: return "요청한 정보가 전달되지 않았어요"
        }
    }
    
    public var contents: String? {
        switch self {
        case let .failed(_, contents, _): return contents
        default: return "새로고침 하거나, 이전으로 돌아가 다시 시도해주세요"
        }
    }
    
    public var isBack: Bool {
        switch self {
        case let .failed(_, _, isBack): return isBack
        default: return true
        }
    }
}
