// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let product = try? newJSONDecoder().decode(Product.self, from: jsonData)

import Foundation

// MARK: - Product
struct Product: Codable {
    let id: Int
    let productName: String
    let settlePrice, officialPrice, diffPrice: Double
    let rebate: JSONNull?
    let img: String
    let specification: Specification
    let buyAmount: Int
    let supplyType, mcCafe, specialProduct, spikeStatus: JSONNull?
    let beforeGoingTips, limitNum, spikeStartTime, spikeEndTime: JSONNull?
    let sort: Int
    let customImg: String
}
