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
