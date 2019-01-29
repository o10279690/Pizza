//
//  APIService.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/27/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import Foundation


let API_URL = "https://private-anon-63d6d2679c-pizzaapp.apiary-mock.com"
enum Endpoint: String {
    case restaurants = "/restaurants/"
    case restaurantsMenu = "/restaurants/%d/menu"
    case orders = "/orders/"
    case order = "/orders/%d"

    func url(with parameters: CVarArg...) -> URL {
        let path = String(format: self.rawValue, arguments: parameters)
        return URL(string: API_URL + path)!
    }
    var url: URL {
        return URL(string: API_URL + self.rawValue)!
    }

}

protocol NetworkEngine {
    typealias Handler = (Data?, URLResponse?, Error?) -> Void

    func performRequest(for request: URLRequest, completionHandler: @escaping Handler)
}

extension URLSession: NetworkEngine {
    typealias Handler = NetworkEngine.Handler

    func performRequest(for request: URLRequest, completionHandler: @escaping Handler) {
        let task = dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
}

class APIService {

    // MARK: Enumerations
    enum Result<Value> {
        case success(Value)
        case error(Error)
    }

    // MARK - Initializers
    init(engine: NetworkEngine = URLSession.shared) {
        self.engine = engine
    }

    // MARK - Public methods
    func get<Value: Codable>(from url: URL, completionHandler: @escaping (Result<Value>) -> Void) {

        let request = URLRequest(url: url)

        engine.performRequest(for: request) { (data, response, error) in
            if let error = error {
                return completionHandler(.error(error))
            }

            do {
                let data = try JSONDecoder().decode(Value.self, from: data!)
                completionHandler(.success(data))
            } catch let jsonErr {
                completionHandler(.error(jsonErr))
            }
        }
    }

    func post<Type: Codable, Value: Codable>(from url: URL, parameters: Type, completionHandler: @escaping (Result<Value>) -> Void) {

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        do {
            request.httpBody = try JSONEncoder().encode(parameters)
        } catch let encodingError {
            completionHandler(.error(encodingError))
            return
        }

        engine.performRequest(for: request as URLRequest) { (data, response, error) in
            if let error = error {
                return completionHandler(.error(error))
            }

            do {
                let data = try JSONDecoder().decode(Value.self, from: data!)
                completionHandler(.success(data))
            } catch let jsonErr {
                completionHandler(.error(jsonErr))
            }
        }
    }

    // MARK - Private properties
    private let engine: NetworkEngine
}
