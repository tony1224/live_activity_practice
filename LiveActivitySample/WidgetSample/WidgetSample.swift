//
//  WidgetSample.swift
//  WidgetSample
//
//  Created by Jun Morita on 2022/10/24.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct WidgetSampleEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

@main
struct WidgetSample: Widget {
    let kind: String = "WidgetSample"

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TripAppAttributes.self) { context in
            LiveActivitiesTestWidgetEntryView(attribute: context.attributes, state: context.state)
        } dynamicIsland: { context in
            // Todo
            DynamicIsland {
                // 左上(ごく短いテキスト)
                DynamicIslandExpandedRegion(.leading) {
                    Text("🚀")
                }
                // 右上(ごく短いテキスト)
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.arrivalTime, style: .timer)
                        .font(.caption2)
                }
                // 中央(一文程度のテキスト, スコアボード
                DynamicIslandExpandedRegion(.center) {
                    Text("次の目的地は\(context.attributes.userStopPlanetName)です。")
                }
                // 下(ボタン配置くらい)
                DynamicIslandExpandedRegion(.bottom) {
                    Button("宇宙機アクセスバッジ") {
                        return
                    }.buttonStyle(.borderedProminent)
                }
            } compactLeading: {
                // コンパクト版(左)
                Text("🚀 - \(context.attributes.shipNumber)")
            } compactTrailing: {
                // コンパクト版(右)
                Text(context.state.arrivalTime, style: .relative)
                    .frame(width: 50)
                    .monospacedDigit()
                    .font(.caption2)
            } minimal: {
                // 2つ以上のウィジェットが開いている場合はこれが表示される
                Text("🚀")
            }
            
        }
    }
}

struct WidgetSample_Previews: PreviewProvider {
    static var previews: some View {
        WidgetSampleEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
