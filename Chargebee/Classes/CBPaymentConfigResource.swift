//
// Created by Mac Book on 7/7/20.
//

import Foundation

class CBPaymentConfigResource: APIResource {
    typealias ModelType = CBWrapper

    private(set) var methodPath: String = "/internal/component/retrieve_config"
    var baseUrl: String = "https://test-ashwin1-test.chargebee.com/api"
    var authHeader: String = "test_1PDU9iynvhEcPMgWAJ0QZw90d2Aw92ah"
    var headers: [String: String] = [:]
}
