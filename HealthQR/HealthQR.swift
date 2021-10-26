//
//  HealthQR.swift
//  HealthQR
//
//  Created by 阳鸿 on 2021/8/11.
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
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }
        entries = [
            SimpleEntry(date: Date(), configuration: configuration),
            SimpleEntry(date: Calendar.current.date(byAdding: .minute, value: 1, to: Date())!, configuration: configuration),
        ]

        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct HealthQREntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing:20){
            Text("健康码")
            Text(entry.date, style: .time).font(.largeTitle).bold()
        }.widgetURL(URL(string: "widget://img")!)
        

        
    }
}

@main
struct HealthQR: Widget {
    let kind: String = "HealthQR"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            HealthQREntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct HealthQR_Previews: PreviewProvider {
    static var previews: some View {
        HealthQREntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
