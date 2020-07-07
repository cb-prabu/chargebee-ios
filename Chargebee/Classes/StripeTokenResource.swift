//
// Created by Mac Book on 7/7/20.
//

import Foundation

struct StripeCard: Codable {
    let number: String
    let expiryMonth: String
    let expiryYear: String
    let cvc: String

    enum CodingKeys: String, CodingKey {
        case number = "card[number]"
        case expiryMonth = "card[exp_month]"
        case expiryYear = "card[exp_year]"
        case cvc = "card[cvc]"
    }
}

class StripeTokenResource: APIResource {
    typealias ModelType = StripeToken

    private(set) var methodPath: String = "/tokens"
    var baseUrl: String = "https://api.stripe.com/v1"
    var authHeader: String = ""
    var headers: [String: String]

    init(_ apiKey: String) {
        self.headers = ["Authorization": "Bearer \(apiKey)"]
        let card: StripeCard = StripeCard(number: "4242424242424242", expiryMonth: "12", expiryYear: "2029", cvc: "123")
        let _: Data? = try? JSONEncoder().encode(card)
    }
}
