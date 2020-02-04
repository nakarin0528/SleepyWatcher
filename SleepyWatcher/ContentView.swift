//
//  ContentView.swift
//  SleepyWatcher
//
//  Created by yiheng on 2019/12/29.
//  Copyright © 2019 nakarin. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                HeartRateView()
                SettingCardView()
            }
            .frame(width: 370, height: 500)
            .navigationBarTitle(Text("Sleepy Watcher"))
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.colorScheme, .dark)
    }
}
#endif


struct HeartRateRow: View {
    var pulse: Pulse

    var body: some View {
        HStack {
            Text(String(Int(pulse.pulse)))
            Text(Helper.formatter(date: pulse.date))
        }
    }
}

struct SettingCardView: View {
    @State var startTime: Date = UserSetting.startTime
    @State var endTime: Date = UserSetting.endTime
    @State var isVibrate: Bool = UserSetting.isVibrate
    @State var napTime: Int = UserSetting.napTime

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "gear").foregroundColor(.gray)
                        Text("Monitor Setting")
                            .font(.title)
                            .bold()
                            .foregroundColor(.primary)
                        Spacer()
                        NavigationLink(destination: SettingView(
                            startTime: startTime,
                            endTime: endTime,
                            isVibrate: isVibrate,
                            napTime: napTime)
                        ) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    Text("Start Time: \(Helper.formatter(date: startTime))")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("End Time: \(Helper.formatter(date: endTime))")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Send Vibration: \(isVibrate ? "true":"false")")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Nap Time: \(napTime)")
                        .font(.headline)
                        .foregroundColor(.primary)
                }.onAppear(perform: {
                    self.startTime = UserSetting.startTime
                    self.endTime = UserSetting.endTime
                    self.isVibrate = UserSetting.isVibrate
                    self.napTime = UserSetting.napTime
                })
                .padding()
                Spacer()
            }
            .background(Color(#colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1176470588, alpha: 1)))
            .cornerRadius(15)
            .padding()
            
        }
        .padding([.bottom])
    }
}

struct HeartRateView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject(initialValue: HeartRateModel()) var heartRateModel: HeartRateModel
    var body: some View {
        GeometryReader{ geometry in
            ZStack {
                LineView(
                    data: self.heartRateModel.hr,
                    title: "HR (\(Helper.formatter(date: Date() - 60*60*3)) - \(Helper.formatter(date: Date())))",
                    legend: "You are \(self.getUserStatus())", valueSpecifier: "%.0f").padding([.horizontal])
//                    .onAppear(perform: {
//                        self.heartRateModel.readHeartRate()
//                    })
                GeometryReader { geometry in
                    Button(action: {
                        self.heartRateModel.readHeartRate()
                    }) {
                        Image(systemName: "arrow.2.circlepath.circle")
                            .resizable()
                            .font(Font.title.weight(.medium))
                            .frame(width:25, height:25)
                            .foregroundColor(.orange)
                    }
                    .offset(x: geometry.frame(in: .local).width/2.45, y:-geometry.frame(in: .local).height/2.7)
                }
                //                Button(
                //                    action: self.heartRateModel.sendStartAlarm,
                //                    label: {
                //                        Text("start alarm").padding()
                //                })
                //                    .foregroundColor(Color.white)
                //                    .background(Color.red)
                //                    .cornerRadius(20)
            }
            .background(Color(#colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1176470588, alpha: 1)))
            .cornerRadius(15)
            .padding([.horizontal])
        }
    }

    private func getUserStatus() -> String {
        switch self.heartRateModel.estimateUserStatus() {
        case .fine:
            return "fine! 😇"
        case .sleepy:
            return "sleepy! 🥱"
        case .sleeping:
            return "sleeping! 😪"
        }
    }
}

enum UserStatus {
    case fine
    case sleepy
    case sleeping
}
