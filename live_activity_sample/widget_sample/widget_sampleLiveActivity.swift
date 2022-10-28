//
//  widget_sampleLiveActivity.swift
//  widget_sample
//
//  Created by Jun Morita on 2022/10/29.
//
#if canImport(ActivityKit)
import ActivityKit
import WidgetKit
import SwiftUI

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

struct widget_sampleLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TripAppAttributes.self) { context in
            LiveActivitiesTestWidgetEntryView(
                attribute: context.attributes,
                state: context.state
            )
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("🚀")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.arrivalTime, style: .timer)
                        .font(.caption2)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("次の目的地は\(context.state.userStopPlanetName)です。")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Button("宇宙機アクセスバッジ") {
                        return
                    }.buttonStyle(.borderedProminent)
                }
            } compactLeading: {
                Text("🚀 - \(context.attributes.shipNumber)")
            } compactTrailing: {
                Text(context.state.arrivalTime, style: .relative)
                                    .frame(width: 50)
                                    .monospacedDigit()
                                    .font(.caption2)
            } minimal: {
                ViewThatFits {
                    Text("🚀")
                    Text("context.state.arrivalTime, style: .relative")
                }
            }
        }
    }
}
#endif
