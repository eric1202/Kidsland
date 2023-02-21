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
            SimpleEntry(date: Calendar.current.date(byAdding: .second, value: 1, to: Date())!, configuration: configuration),
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
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        
        if #available(iOSApplicationExtension 16.0, *) {
            switch family {
                //                case .accessoryRectangular:
                // Code to construct the view for the rectangular Lock Screen widget or watch complication.
            case .accessoryCircular:
                ZStack{
                    AccessoryWidgetBackground()
                    VStack {
                        Text("⏣").font(.title)
                        Text("LZJ").font(.caption)
                            
                    }
                }
            default:
                VStack(spacing:20){
                    Text("查阅全图")
                    Text(entry.date, style: .time).font(.largeTitle).bold()
                }.widgetURL(URL(string: "widget://img")!)
            }
        } else {
            // Fallback on earlier versions
            VStack(spacing:20){
                Text("查阅全图")
                Text(entry.date, style: .time).font(.largeTitle).bold()
            }.widgetURL(URL(string: "widget://img")!)
        }
        
    }
}


@main
struct WidgetBundle_widget: WidgetBundle {
    
    @WidgetBundleBuilder
    var body: some Widget {
        HealthQR()  //This is your Widget struct.
        HealthQRSecond()
    }
}

//@main
struct HealthQR: Widget {
    let kind: String = "HealthQR"
    
    var body: some WidgetConfiguration {
        var arr: [WidgetFamily] = [.systemSmall, .systemMedium]
        if #available(iOSApplicationExtension 16.0, *) {
            arr = [.accessoryCircular, .accessoryRectangular, .accessoryInline, .systemSmall, .systemMedium]
        }
        
        return
        
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            HealthQREntryView(entry: entry)
        }
        .configurationDisplayName("LZJ Widget")
        .description("This is an example widget.")
        .supportedFamilies(arr)
        
        
    }
}

struct CountryEntry: TimelineEntry {
    let date: Date
    let country: String
}

struct CountryProvider : TimelineProvider {
    func placeholder(in context: Context) -> CountryEntry {
        CountryEntry(date: Date(), country: "Hi")
    }
    func getSnapshot(in context: Context, completion: @escaping (CountryEntry) -> Void){
        let entry = CountryEntry(date: Date(), country: "country")
        completion(entry)
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<CountryEntry>) -> Void){
        var entries: [CountryEntry] = []
        
        let currentDate = Date()
        var dayOffset = 0

        while dayOffset < 5 {
          let entryDate = Calendar.current.date(byAdding: .day,
            value: dayOffset, to: currentDate)!
            let entry = CountryEntry(date: entryDate, country: String(dayOffset))
          entries.append(entry)
          dayOffset += 1
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
struct CountryWidgetEntryView : View {
  var entry: CountryEntry
    var body: some View {
        if #available(iOSApplicationExtension 16.0, *) {
            ZStack{
                AccessoryWidgetBackground()
                
                Text("技术实现\n\(entry.date.formatted())")
                    .font(.system(size: 8, weight: .light, design: .serif))
                    .italic()
                    .multilineTextAlignment(.center)
            }
        } else {
            VStack{
                Text("㉿").font(.title)
                Text("技术实现\(entry.date)").font(.footnote)
            }
        }
  }
}

struct HealthQRSecond: Widget {
    let kind: String = "HealthQR2"
    
    var body: some WidgetConfiguration {
        var arr: [WidgetFamily] = [.systemSmall, .systemMedium]
        if #available(iOSApplicationExtension 16.0, *) {
            arr = [.accessoryCircular, .accessoryRectangular]
        }
        
        return
        
        StaticConfiguration(kind: kind, provider: CountryProvider()) { entry in
            CountryWidgetEntryView(entry: entry )
        }
        .supportedFamilies(arr)
        .configurationDisplayName("LZJ 2Widget")
        .description("This is No.2 widget.")
        
    }
}

struct HealthQR_Previews: PreviewProvider {
    static var previews: some View {
        
        var wf: WidgetFamily = .systemSmall
        if #available(iOSApplicationExtension 16.0, *) {
            wf = .accessoryCircular
        }
        
        return CountryWidgetEntryView(entry: CountryEntry(date: Date(), country: "11"))
//        return HealthQREntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: wf))
    }
}
