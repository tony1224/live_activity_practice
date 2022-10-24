//
//  ContentView.swift
//  LiveActivitySample
//
//  Created by Jun Morita on 2022/10/24.
//

import SwiftUI
import ActivityKit

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
                Label(
                    isActivityEnabled ? "Activity enabled" : "Activity not enabled",
                    systemImage: isActivityEnabled ? "checkmark.circle.fill" : "xmark.circle.fill"
                )
            }
            
            Button("Create live activity") {
                // メインモジュールからアクティビティを作成する方法
                let attributes = TripAppAttributes(shipNumber: "火星号", departureTime: Calendar.current.date(byAdding: .minute, value: -2, to: Date()) ?? Date())
                // 初期状態を設定
                // 状態はライブアクティビティ・セッション中に変更可能
                let contentState = TripAppAttributes.ContentState(
                    tripStatus: TripAppAttributes.TripStatus.inflight.rawValue,
                    userStopPlanetName: "火星",
                    userCabinNumber: "A12",
                    arrivalTime: Calendar.current.date(byAdding: .minute, value: 8, to: Date()) ?? Date())
                
                do {
                    self.currentActivity = try Activity<TripAppAttributes>.request(
                        attributes: attributes,
                        contentState: contentState,
                        pushType: nil // リモート通知はここをどうにかする？
                    )
                } catch(let error) {
                    print(error.localizedDescription)
                }
            }
            
            Button("Trip arrival time + 10 minutes") {
                Task {
                    guard let currentActivity else { return }
                    let arrivalTime = Calendar.current.date(byAdding: .minute, value: 10, to: currentActivity.contentState.arrivalTime) ?? Date()
                    
                    let updateState = updateContentState(tripStatus: .inflight, arrivalTime: arrivalTime)
                    
                    
                    await currentActivity.update(using: updateState)
                }
            }
            
            Button("End activity") {
                Task {
                    guard let currentActivity else { return }
                    let updateState = updateContentState(tripStatus: .landed, arrivalTime: currentActivity.contentState.arrivalTime)
                    
                    await currentActivity.end(using: updateState, dismissalPolicy: .default)
                }
            }
        }

    }
    
    private func updateContentState(tripStatus: TripAppAttributes.TripStatus, arrivalTime: Date) -> TripAppAttributes.ContentState {
        TripAppAttributes.ContentState(
            tripStatus: tripStatus.rawValue,
            userStopPlanetName: "火星",
            userCabinNumber: "A12",
            arrivalTime: arrivalTime
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
