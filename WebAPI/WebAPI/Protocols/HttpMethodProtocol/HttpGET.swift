//
//  HttpGET.swift
//  WebAPI
//
//  Created by 劉柏賢 on 2016/8/6.
//  Copyright © 2016年 Bobson. All rights reserved.
//

import JSONParser
import PromiseKit

public protocol HttpGet: WebAPIProtocol {

}

extension HttpGet {
    public func invokeAsync(_ parameter: TParameter) -> Promise<TResult> {
        return get(parameter)
    }

    /// Http GET
    func get(_ parameter: TParameter) -> Promise<TResult> {
        let urlFullPath: URL
        if let parameter: URLPathProtocol = parameter as? URLPathProtocol {
            guard let urlWithPath: URL = String(format: urlString, arguments: parameter.path).url else {
                return Promise<TResult>(error: WebAPIError<TResult>.invalidUrl(url: urlString))
            }

            urlFullPath = urlWithPath
        } else {
            guard let urlUnwrapped: URL = urlString.url else {
                return Promise<TResult>(error: WebAPIError<TResult>.invalidUrl(url: urlString))
            }

            urlFullPath = urlUnwrapped
        }

        let stringSelf: String = "\(type(of: self))"
        print("\r\n\r\nurl(\(stringSelf)): \(urlFullPath.description)")

        guard var urlComponents: URLComponents = URLComponents(url: urlFullPath, resolvingAgainstBaseURL: false) else {
            print("\r\n\r\nurlComponentsError: \(urlFullPath.description)")

            return Promise<TResult>(error: WebAPIError<TResult>.invalidUrl(url: urlFullPath.absoluteString))
        }

        // Http Body
        let httpBody: String = parameter.getHttpBody(isSortByKey: false)
        if !httpBody.isEmpty {
            print("httpBody: \(httpBody)")

            urlComponents.query = httpBody
        }

        guard let urlWithQueryStringFullPath: URL = urlComponents.url else {

            print("\r\n\r\nurlError: \(urlFullPath.description)")

            return Promise<TResult>(error: WebAPIError<TResult>.invalidUrl(url: urlFullPath.absoluteString))
        }

        var request: URLRequest = URLRequest(url: urlWithQueryStringFullPath, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        request.httpMethod = "GET"
        print("httpMethod: \(request.httpMethod ?? "")")

        let start: DispatchTime = DispatchTime.now() // <<<<<<<<<< Start time

        #if FAKE
            return Promise<TResult>(resolver: { (resolver: Resolver) in
                DispatchQueue.global().async {

                    let response: HTTPURLResponse? = HTTPURLResponse(url: urlWithQueryStringFullPath, statusCode: 200, httpVersion: "", headerFields: nil)
                    print("\r\n\(stringSelf):\r\nresult http statusCode: \(response?.statusCode ?? -1)")

                    let end: DispatchTime = DispatchTime.now()   // <<<<<<<<<<   end time
                    let nanoTime: UInt64 = end.uptimeNanoseconds - start.uptimeNanoseconds
                    let timeInterval: TimeInterval = TimeInterval(nanoTime) / 1_000_000_000
                    print("response time: \(timeInterval) seconds")

                    do {
                        var result: TResult = try TParser().parse(urlWithQueryStringFullPath, data: nil, response: response, parameter: parameter as! TParser.TResult.TParameter, error: nil) as! TResult
                        result.parameter = parameter as? TResult.TParameter
                        result.response = response
                        result.responseData = nil
                        result.cache = nil

                        resolver.fulfill(result)
                    } catch let error {
                        resolver.reject(error)
                    }
                }
            })
        #else
            return Promise<TResult>(resolver: { (resolver: Resolver) in

                let task: URLSessionDataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in

                    let response: HTTPURLResponse? = response as? HTTPURLResponse
                    print("\r\n\(stringSelf):\r\nresult http statusCode: \(response?.statusCode ?? -1)")

                    let end: DispatchTime = DispatchTime.now()   // <<<<<<<<<<   end time
                    let nanoTime: UInt64 = end.uptimeNanoseconds - start.uptimeNanoseconds
                    let timeInterval: TimeInterval = TimeInterval(nanoTime) / 1_000_000_000
                    print("response time: \(timeInterval) seconds")

                    do {
                        var result: TResult = try TParser().parse(urlWithQueryStringFullPath, data: data, response: response, parameter: parameter as! TParser.TResult.TParameter, error: error) as! TResult
                        result.parameter = parameter as? TResult.TParameter
                        result.response = response
                        result.responseData = data

                        guard result.isSuccess else {
                            throw WebAPIError<TResult>.fail(result)
                        }

                        resolver.fulfill(result)

                    } catch let webAPIError {
                        
                        DispatchQueue.main.async {
                            resolver.reject(webAPIError)
                        }
                    }
                })

                task.resume()
            })
        #endif
    }
}
