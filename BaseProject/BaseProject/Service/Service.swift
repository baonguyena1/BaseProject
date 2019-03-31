//
//  Service.swift
//  BaseProject
//
//  Created by Bao Nguyen on 3/31/19.
//  Copyright © 2019 Bao Nguyen. All rights reserved.
//

import UIKit

typealias JSON = [String: Any]

enum APIError: Error {
    case invalidUrl
    case responseUnsuccessfull
    case invalidData
    case cannotParse(String)
}

enum Result<T> {
    case success(T)
    case error(APIError)
}

struct Service<T: Codable> {
    
    fileprivate var session: URLSession!
    
    init() {
        self.init(configuration: .default)
    }
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    @discardableResult
    static func request(_ urlString: String, completion: ((Result<T>) -> Void)?) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else {
            completion?(.error(.invalidUrl))
            return nil
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if (response as? HTTPURLResponse)?.statusCode != 200 {
                completion?(.error(.responseUnsuccessfull))
                return
            }
            guard let data = data else {
                completion?(.error(.invalidData))
                return
            }
            do {
                let result: T = try JSONDecoder().decode(T.self, from: data)
                completion?(.success(result))
            } catch let error {
                completion?(.error(.cannotParse(error.localizedDescription)))
            }
        }
        task.resume()
        return task
    }
}
