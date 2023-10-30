//
//  martketData.swift
//  market
//
//  Created by Admin on 27/10/2023.
//

import Foundation
struct MartketData: Codable {
    var data: [MartketItemData]?
}

struct MartketItemData: Codable {
    var id: Int?
    var icon: String?
    var miniChart: String?
    var name: String?
    var symbol: String?
    var slug: String?
    var totalSupply: Float?
    var cmcRank: Int?
    var createdAt: String?
    var quote: QuoteMartketData?
}
struct QuoteMartketData: Codable {
    var price: Float?
    var volume24h: Float?
    var volumeChange24h: Float?
    var percentChange1h: Float?
    var percentChange24h: Float?
    var percentChange7d: Float?
    var percentChange30d: Float?
    var percentChange60d: Float?
    var percentChange90d: Float?
    var marketCap: Float?
    var marketCapDominance: Float?
    var fullyDilutedMarketCap: Float?
}
struct QuotesChartData: Codable {
    var quotes: [QuotesChartItemData]?
}

struct QuotesChartItemData: Codable {
    var time: String?
    var value: Float?
}
