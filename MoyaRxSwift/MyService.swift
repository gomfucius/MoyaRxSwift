//
//  MyService.swift
//  MoyaRxSwift
//
//  Created by Genki Mine on 7/28/17.
//  Copyright © 2017 Genki. All rights reserved.
//

import Foundation
import Moya

enum MyService {
    case hello
    case showUser(id: Int)
    case createUser(firstName: String, lastName: String)
    case updateUser(id:Int, firstName: String, lastName: String)
    case showAccounts
}

// MARK: - TargetType Protocol Implementation
extension MyService: TargetType {
    var baseURL: URL { return URL(string: "https://yookly.vapor.cloud")! }
    var path: String {
        switch self {
        case .hello:
            return "/hello"
        case .showUser(let id), .updateUser(let id, _, _):
            return "/users/\(id)"
        case .createUser(_, _):
            return "/users"
        case .showAccounts:
            return "/accounts"
        }
    }
    var method: Moya.Method {
        switch self {
        case .hello, .showUser, .showAccounts:
            return .get
        case .createUser, .updateUser:
            return .post
        }
    }
    var parameters: [String: Any]? {
        switch self {
        case .hello, .showUser, .showAccounts:
            return nil
        case .createUser(let firstName, let lastName), .updateUser(_, let firstName, let lastName):
            return ["first_name": firstName, "last_name": lastName]
        }
    }
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .hello, .showUser, .showAccounts:
            return URLEncoding.default // Send parameters in URL for GET, DELETE and HEAD. For other HTTP methods, parameters will be sent in request body
        case .updateUser:
            return URLEncoding.queryString // Always sends parameters in URL, regardless of which HTTP method is used
        case .createUser:
            return JSONEncoding.default // Send parameters as JSON in request body
        }
    }
    var sampleData: Data {
        switch self {
        case .hello:
            return "Half measures are as bad as nothing at all.".utf8Encoded
        case .showUser(let id):
            return "{\"id\": \(id), \"first_name\": \"Harry\", \"last_name\": \"Potter\"}".utf8Encoded
        case .createUser(let firstName, let lastName):
            return "{\"id\": 100, \"first_name\": \"\(firstName)\", \"last_name\": \"\(lastName)\"}".utf8Encoded
        case .updateUser(let id, let firstName, let lastName):
            return "{\"id\": \(id), \"first_name\": \"\(firstName)\", \"last_name\": \"\(lastName)\"}".utf8Encoded
        case .showAccounts:
            // Provided you have a file named accounts.json in your bundle.
            guard let url = Bundle.main.url(forResource: "accounts", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        }
    }
    var task: Task {
        switch self {
        case .hello, .showUser, .createUser, .updateUser, .showAccounts:
            return .request
        }
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}
