//
// Created by Mac Book on 6/7/20.
//

import Foundation

protocol APIResource {
    associatedtype ModelType: Decodable
    var methodPath: String { get }
    var baseUrl: String { get set }
    var authHeader: String { get set }
    var url: URLRequest { get }
    var headers: [String: String] { get set }
}

@available(macCatalyst 13.0, *)
extension APIResource {
    var url: URLRequest {
        let url = URL(string: baseUrl + methodPath)!
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Basic " + authHeader, forHTTPHeaderField: "Authorization")
        urlRequest.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        return urlRequest
    }

    func create<T: Encodable>(body: T, isUrlEncoded: Bool = true) -> URLRequest {
        let url = URL(string: baseUrl)!
        var urlRequest = URLRequest(url: url)
        headers.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        urlRequest.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        print("checcking inside create \(self.url)")
        urlRequest.httpMethod = "post"
//        if isUrlEncoded {
//        }
//        urlRequest.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
//        urlRequest.addValue("Basic " + authHeader, forHTTPHeaderField: "Authorization")
//
        var bodyComponents = URLComponents()
//        bodyComponents.queryItems = body.map({ (key, value) -> URLQueryItem in
//            URLQueryItem(name: key, value: value)
//        })
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        urlRequest.httpBody = bodyComponents.query?.data(using: .utf8)
        print(body)
        print("-----------------------------------------------------------------")
        print(try? JSONEncoder().encode(body))
        print("-----------------------------------------------------------------")
        print(dump(urlRequest.httpBody))
        return urlRequest
    }
}

class APIRequest<Resource: APIResource> {
    let resource: Resource

    init(resource: Resource) {
        self.resource = resource
    }
}

@available(macCatalyst 13.0, *)
extension APIRequest: NetworkRequest {

    func decode(_ data: Data) -> Resource.ModelType? {
        return try? JSONDecoder().decode(Resource.ModelType.self, from: data)
    }

    func load(withCompletion completion: @escaping (Resource.ModelType?) -> Void) {
        print("got this url \(resource.url)")
        load(resource.url, withCompletion: completion)
    }

    func create<T: Codable>(body: T, withCompletion completion: @escaping (Resource.ModelType?) -> Void) {
        print("got this url \(resource.url)")
//        load(resource.create(body: body), withCompletion: completion)
        load(resource.create(body: body), withCompletion: completion)
    }
}

struct TempTokenBody: Codable {
    let paymentMethodType: String
    let token: String
    let gatewayId: String

    enum CodingKeys: String, CodingKey {
        case paymentMethodType = "payment_method_type"
        case token = "id_at_vault"
        case gatewayId = "gatewat_account_id"
    }
}

struct CBTempToken: Codable {
    let paymentMethodType: String
    let idAtVault: String
    let gatewayAccountId: String

    enum CodingKeys: String, CodingKey {
        case paymentMethodType = "payment_method_type"
        case idAtVault = "id_at_vault"
        case gatewayAccountId = "gateway_account_id"
    }
}

@available(macCatalyst 13.0, *)
class CBTokenResource: APIResource {
    var headers: [String: String]
    var authHeader: String
    var baseUrl: String = "https://test-ashwin1-test.chargebee.com/api/v2/tokens/create_using_temp_token"
    typealias ModelType = TokenWrapper
    let methodPath: String = ""

    init() {
        let changeMe = "test_uMJh75cuR3HwwuEAzDcs2ewJEhLjhIbWf".data(using: .utf8)?.base64EncodedString() ?? ""
        self.authHeader = "Basic " + changeMe
        self.headers = ["Authorization": "\(self.authHeader)"]
    }

//    func createTempToken(paymentMethodType: String, token: String, gatewayId: String) {
//        let body = [
//            ("payment_method_type", paymentMethodType),
//            ("id_at_vault", token),
//            ("gateway_account_id", gatewayId),
//        ]
//        let tempToken: CBTempToken = CBTempToken(paymentMethodType: paymentMethodType, idAtVault: token, gatewayAccountId: gatewayId)
//        self.create(body: tempToken)
//    }
}
