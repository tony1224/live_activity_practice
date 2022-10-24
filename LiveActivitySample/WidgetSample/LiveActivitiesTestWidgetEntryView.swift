//
//  LiveActivitiesTestWidgetEntryView.swift
//  WidgetSampleExtension
//
//  Created by Jun Morita on 2022/10/24.
//

import SwiftUI
import Intents
import ActivityKit
import WidgetKit

struct LiveActivitiesTestWidgetEntryView: View {
    @State var attribute: TripAppAttributes
    @State var state: TripAppAttributes.ContentState
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Label("Ship number", systemImage: "moon.stars")
                Spacer()
                Text(attribute.shipNumber)
            }
            HStack {
                Label("Your stop", systemImage: "lanyardcard")
                Spacer()
                Text(state.userStopPlanetName)
            }
            
            switch TripAppAttributes.TripStatus(rawValue: state.tripStatus) {
            case .predeparture:
                HStack {
                    Label("Your cabin", systemImage: "person.fill")
                    Spacer()
                    Text(state.userCabinNumber)
                        .font(.title3.bold())
                }
            case .inflight:
                Label("Currently in trip", systemImage: "clock")
            case .landed:
                Label("Landed", systemImage: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title3)
                Text("Thakns for traveling with us!")
                    .font(.headline)
            default:
                Text("Unknown trip status")
            }
        }
        .padding()
    
    }
}
//
//struct LiveActivitiesTestWidgetEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        LiveActivitiesTestWidgetEntryView()
//    }
//}
