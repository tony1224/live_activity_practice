//
//  TripAppAttributes.swift
//  live_activity_sample
//
//  Created by Jun Morita on 2022/10/29.
//

#if canImport(ActivityKit)
import Foundation
import ActivityKit

struct TripAppAttributes: ActivityAttributes {
    
    enum TripStatus: String {
        case predeparture
        case inflight
        case landed
    }

    public struct ContentState: Codable, Hashable {
        var tripStatus: String
        var userStopPlanetName: String
        var userCabinNumber: String
        var arrivalTime: Date
    }
    
    var shipNumber: String
    var departureTime: Date
    
}
#endif
