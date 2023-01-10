//
//  URLRequest + Ext.swift
//  GoodWeather
//
//  Created by Oleg Kirsanov on 25.11.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

struct Resource<T> {
    let url: URL
}

extension URLRequest {

    // New implementation

    static func load<T: Codable>(resource: Resource<T>) -> Observable<T> {
        Observable.just(resource.url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.response(request: request)
            }
            .map { response, data -> T in
                if 200..<300 ~= response.statusCode {
                    return try JSONDecoder().decode(T.self, from: data)
                } else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data) // we should also add catching this error in our View Controller
                }
            }
            .asObservable()
    }


    // Old implementation witount error handling

//    static func load<T: Codable>(resource: Resource<T>) -> Observable<T> {
//        Observable.from([resource.url])
//            .flatMap { url -> Observable<Data> in
//                let request = URLRequest(url: url)
//                return URLSession.shared.rx.data(request: request)
//            }
//            .map { data -> T in
//                return try JSONDecoder().decode(T.self, from: data)
//            }
//            .asObservable()
//    }
}
