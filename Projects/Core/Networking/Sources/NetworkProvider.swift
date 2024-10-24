//
//  NetworkProvider.swift
//  Network
//
//  Created by Supermove on 6/21/24.
//  Copyright © 2024 kr.co.supermove.rush. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift
import Logger
import SMError

public class CompleteUrlLoggerPlugin: PluginType {
    public func willSend(_ request: RequestType, target: TargetType) {
        SMLogger.log(category: .api, level: .info, message: "REQUEST: \(request.request?.url?.absoluteString ?? "Something is wrong")")
    }
}

public class NetworkProvider<Target: TargetType>: MoyaProvider<Target> {
    private let decoder = JSONDecoder()
    
    public init() {
        let session = MoyaProvider<Target>.defaultAlamofireSession()
        session.sessionConfiguration.timeoutIntervalForRequest = 30
        super.init(session: session, plugins: [CompleteUrlLoggerPlugin()])
    }
    
    public func request(_ target: Target, shouldAuthorized: Bool = false) -> Completable {
        let requestString = "\(target.method.rawValue) \(target.path)"
        return Completable.create { completable in
            if shouldAuthorized {
                completable(.error(SMError.unauthorized))
            }
            
            self.request(target) { response in
                switch response {
                case let .success(response):
                    do {
                        switch response.statusCode {
                        case 200...299:
                            let message = "SUCCESS: \(requestString) (\(response.statusCode))"
                            let data = String(data: response.data, encoding: .utf8)!
                            SMLogger.log(category: .api, level: .info, message: "\(message)\n\(data)")
                            
                            guard let decodedResponse = try? JSONDecoder().decode(BaseResponse<AnyDecodable?>.self, from: response.data)
                            else { throw SMError.decodingFailed }
                            
                            if decodedResponse.resultCode == 0 {
                                completable(.completed)
                            } else if let guide = decodedResponse.guide, let title = guide.title {
                                throw SMError.failed(title: title, contents: guide.contents, isBack: guide.back == "Y")
                            } else {
                                throw SMError.failed(title: "요청한 정보가 전달되지 않았어요", contents: "새로고침 하거나, 이전으로 돌아가 다시 시도해주세요", isBack: true)
                            }
                            
                        case 401:       throw SMError.unauthorized
                        case 400...499: throw SMError.badRequest
                        case 500...599: throw SMError.internalServerError
                        default:        throw SMError.unknown
                        }
                    } catch {
                        let message = "FAILURE: \(requestString)\n\(error)"
                        SMLogger.log(category: .api, level: .info, message: "\(message)")
                        completable(.error(error))
                    }
                case .failure:
                    completable(.error(SMError.badRequest))
                }
            }
            return Disposables.create()
        }
    }
    
    public func request(_ target: Target, shouldAuthorized: Bool = false) -> Single<GuideDTO> {
        let requestString = "\(target.method.rawValue) \(target.path)"
        return Single<GuideDTO>.create { single in
            if shouldAuthorized {
                single(.failure(SMError.unauthorized))
                return Disposables.create()
            }
            
            self.request(target) { response in
                switch response {
                case let .success(response):
                    do {
                        switch response.statusCode {
                        case 200...299:
                            let message = "SUCCESS: \(requestString) (\(response.statusCode))"
                            let data = String(data: response.data, encoding: .utf8)!
                            SMLogger.log(category: .api, level: .info, message: "\(message)\n\(data)")
                            
                            guard let baseResponse = try? JSONDecoder().decode(BaseResponse<AnyDecodable>.self, from: response.data) else { throw SMError.decodingFailed }
                            
                            guard let guide = baseResponse.guide, let title = guide.title else {
                                let object = GuideDTO(
                                    display: "Y", back: "N",
                                    title: "요청한 정보가 전달되지 않았어요",
                                    contents: baseResponse.message ?? "새로고침 하거나, 이전으로 돌아가 다시 시도해주세요"
                                )
                                single(.success(object))
                                return
                            }
                            single(.success(guide))
                        case 401:       throw SMError.unauthorized
                        case 400...499: throw SMError.badRequest
                        case 500...599: throw SMError.internalServerError
                        default:        throw SMError.unknown
                        }
                    } catch {
                        let message = "FAILURE: \(requestString)\n\(error)"
                        SMLogger.log(category: .api, level: .info, message: "\(message)")
                        single(.failure(error))
                    }
                case .failure:
                    single(.failure(SMError.badRequest))
                }
            }
            
            return Disposables.create()
        }
    }
    
    public func request<M: Decodable>(_ target: Target, model: M.Type, shouldAuthorized: Bool = false) -> Single<M> {
        let requestString = "\(target.method.rawValue) \(target.path)"
        return Single<M>.create { single in
            if shouldAuthorized {
                single(.failure(SMError.unauthorized))
                return Disposables.create()
            }
            
            self.request(target) { response in
                switch response {
                case let .success(response):
                    do {
                        switch response.statusCode {
                        case 200...299:
                            let message = "SUCCESS: \(requestString) (\(response.statusCode))"
                            let data = String(data: response.data, encoding: .utf8)!
                            SMLogger.log(category: .api, level: .info, message: "\(message)\n\(data)")
                            
                            guard let baseResponse = try? JSONDecoder().decode(BaseResponse<AnyDecodable>.self, from: response.data) else { throw SMError.decodingFailed }
                            
                            if baseResponse.resultCode != 0 {
                                guard let guide = baseResponse.guide,
                                      let title = guide.title
                                else {
                                    throw SMError.failed(
                                        title: "요청한 정보가 전달되지 않았어요",
                                        contents: baseResponse.message ?? "새로고침 하거나, 이전으로 돌아가 다시 시도해주세요",
                                        isBack: false
                                    )
                                }
                                throw SMError.failed(title: title, contents: guide.contents, isBack: guide.back == "Y")
                            }
                            
                            let decodedResponse = try JSONDecoder().decode(BaseResponse<M>.self, from: response.data)
                            
                            if decodedResponse.resultCode == 0 {
                                single(.success(decodedResponse.data!))
                            } else if let guide = decodedResponse.guide, let title = guide.title {
                                throw SMError.failed(title: title, contents: guide.contents, isBack: guide.back == "Y")
                            } else {
                                throw SMError.failed(title: "요청한 정보가 전달되지 않았어요", contents: "새로고침 하거나, 이전으로 돌아가 다시 시도해주세요", isBack: true)
                            }
                            
                        case 401:       throw SMError.unauthorized
                        case 400...499: throw SMError.badRequest
                        case 500...599: throw SMError.internalServerError
                        default:        throw SMError.unknown
                        }
                    } catch {
                        let message = "FAILURE: \(requestString)\n\(error)"
                        SMLogger.log(category: .api, level: .info, message: "\(message)")
                        single(.failure(error))
                    }
                case .failure(let error):
                    let message = "FAILURE: \(requestString)\n\(error)"
                    SMLogger.log(category: .api, level: .info, message: "\(message)")
                    single(.failure(SMError.badRequest))
                }
            }
            return Disposables.create()
        }
    }
}
