//
//  ContentView.swift
//  live_activity_sample
//
//  Created by Jun Morita on 2022/10/29.
//

import SwiftUI
#if canImport(ActivityKit)
import ActivityKit
#endif

struct ContentView: View {
    @State private var isActivityEnabled: Bool = true
    @State private var currentActivity: Activity<TripAppAttributes>?

    var body: some View {
        
        Form {
            
            Section("Status") {
                Button("Check permission") {
                    let isEnabled = ActivityAuthorizationInfo().areActivitiesEnabled
                    self.isActivityEnabled = isEnabled
                }
                Label(isActivityEnabled ? "Activity enabled" : "Activity not enabled",
                      systemImage: isActivityEnabled ? "checkmark.circle.fill" : "xmark.circle.fill")
            }
            
            Button("Create live activity") {
                #if canImport(ActivityKit)
                prepareOrder()
                #endif
            }
            
            Button("Get on-going activity") {
                #if canImport(ActivityKit)
                let activities = Activity<TripAppAttributes>.activities
                self.currentActivity = activities.first
                #endif
            }
            
            Button("Trip arrival time +10 minutes") {
                #if canImport(ActivityKit)
                updateOrder()
                #endif
            }
            
            Button("End activity") {
                #if canImport(ActivityKit)
                endOrder()
                #endif
            }
            
        }
        
    }

    #if canImport(ActivityKit)
    private func prepareOrder() {
        let attributes = TripAppAttributes(shipNumber: "火星へ",
                                           departureTime: Calendar.current.date(byAdding: .minute, value: -2,
                                                                                to: Date()) ?? Date())
        let contentState = TripAppAttributes.ContentState(tripStatus: TripAppAttributes.TripStatus.inflight.rawValue,
                                                          userStopPlanetName: "火星",
                                                          userCabinNumber: "A12",
                                                          arrivalTime: Calendar.current.date(byAdding: .minute, value: 8, to: Date()) ?? Date())
        do {
            self.currentActivity = try Activity<TripAppAttributes>.request(
                attributes: attributes,
                contentState: contentState,
                pushType: nil)
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    private func updateOrder() {
        Task {
            guard let currentActivity else { return }
            let updatedState = TripAppAttributes.ContentState(tripStatus: TripAppAttributes.TripStatus.inflight.rawValue,
                                                              userStopPlanetName: "火星",
                                                              userCabinNumber: "火星へ",
                                                              arrivalTime: Calendar.current.date(byAdding: .minute, value: 10, to: currentActivity.contentState.arrivalTime) ?? Date())
            await currentActivity.update(using: updatedState)
        }
    }

    private func endOrder() {
        Task {
            guard let currentActivity else { return }
            let updatedState = TripAppAttributes.ContentState(tripStatus: TripAppAttributes.TripStatus.landed.rawValue,
                                                              userStopPlanetName: "火星",
                                                              userCabinNumber: "A12",
                                                              arrivalTime: currentActivity.contentState.arrivalTime)
            await currentActivity.end(using: updatedState, dismissalPolicy: .default)
        }
    }
    #endif
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
