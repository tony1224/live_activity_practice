//
//  TripAppAttributes.swift
//  WidgetSampleExtension
//
//  Created by Jun Morita on 2022/10/24.
//

import Foundation
import ActivityKit

// 宇宙船旅行
struct TripAppAttributes: ActivityAttributes {
    enum TripStatus: String {
        case predeparture
        case inflight
        case landed
    }
    
    // 変化するものをこの構造体に格納
    public struct ContentState: Codable, Hashable {
        var tripStatus: String // 旅行状況
        var userStopPlanetName: String // 目的地
        var userCabinNumber: String // ユーザーの客室番号
        var arrivalTime: Date  // 到着時刻
    }
    
    // 以下は固定
    var shipNumber: String // 船舶番号
    var departureTime: Date // 出発時刻
}
