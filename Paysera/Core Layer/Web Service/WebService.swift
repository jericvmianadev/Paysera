//
//  WebService.swift
//  Paysera
//
//  Created by Jeric Miana on 8/9/20.
//  Copyright © 2020 Jeric Miana. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class WebService<T: Decodable>: NSObject {
    
    var httpMethod: Alamofire.HTTPMethod {
        return Alamofire.HTTPMethod.get
    }
    
    var parameters: Alamofire.Parameters {
        return [:]
    }
    
    var paramEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var endpoint: String {
        return ""
    }
    
    var url: URLConvertible? {
        return URL(string: BaseURLs.apiBaseUrl + endpoint)
    }
    
    func request() -> Observable<T?> {
        return Observable<T?>.create({ (observer) -> Disposable in
            guard let url = self.url else {
                observer.onError(WebServiceError.invalidUrl)
                return Disposables.create {}
            }
            let request = AF.request(url,
                                     method: self.httpMethod,
                                     parameters: self.parameters,
                                     encoding: self.paramEncoding)
                .responseJSON { response in
                    debugPrint(response)
                    self.observeResponse(response, with: observer)
            }
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    func observeResponse<T: Decodable>(_ response: AFDataResponse<Any>, with observer: AnyObserver<T?>) {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        switch response.result {
        case .success(_):
            guard let data = response.data else {
                observer.onError(WebServiceError.invalidData)
                return
            }
            if let deserializedResponse = try? decoder.decode(T.self, from: data) {
                observer.onNext(deserializedResponse)
                observer.onCompleted()
            }
        case .failure(let error):
            observer.onError(error)
        }
    }
}
