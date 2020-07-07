//
// Created by Mac Book on 6/7/20.
//

import Foundation

@available(macCatalyst 13.0, *)
protocol NetworkRequest {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func load(withCompletion completion: @escaping (ModelType?) -> Void)
//    func create<T: Codable>(body: T, withCompletion completion: @escaping (ModelType?) -> Void)
}

@available(macCatalyst 13.0, *)
extension NetworkRequest {
    func load(_ urlRequest: URLRequest, withCompletion completion: @escaping (ModelType?) -> Void) {
        makeRequest(urlRequest: urlRequest, completion: completion)
    }

//    func create(_ urlRequest: URLRequest, headers: [String: String], body: [String: String], withCompletion completion: @escaping (ModelType?) -> Void) {
//        let url: URL? = urlRequest.url
//        var request = URLRequest(url: url!)
//        headers.forEach { key, value in
//            request.addValue(value, forHTTPHeaderField: key)
//        }
//        request.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
//        request.httpMethod = "post"
//        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//
//        var bodyComponents = URLComponents()
//        bodyComponents.queryItems = body.map({ (key, value) -> URLQueryItem in
//            URLQueryItem(name: key, value: value)
//        })
//        request.httpBody = bodyComponents.query?.data(using: .utf8)
//
//        makeRequest(urlRequest: request, completion: completion)
//    }

    private func makeRequest(urlRequest: URLRequest, completion: @escaping (ModelType?) -> ()) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: urlRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                print("Empty")
//                error = try? JSONDecoder().decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: <#T##Data#>)
//                let error = CBError(message: "Something went wrong", type: "type", api_error_code: "", param: "", error_code: "", error_msg: "", error_param: "", http_status_code: 400)
                completion(nil)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let error = CBError(
//                        message: "Something went wrong",
                        type: "type12312"
//                        api_error_code: "",
//                        param: "",
//                        error_code: "",
//                        error_msg: "",
//                        error_param: "",
//                        http_status_code: 400
                )
//                print(response.h)
                do {
                    print("-=-==-=-=-")
                    let decoded = try JSONDecoder().decode([String: String].self, from: data)
                    print(decoded, "-=-==-=-=-")
                } catch {
                    print(error.localizedDescription)
                }
                let errorMessage: CBError = error
                print("********")
                print(errorMessage)
                completion(nil)
//                completion(errorMessage)
                return
            }
            print("valid value", data)
            completion(self.decode(data))
        })
        task.resume()
    }
}
