//
//  SettingView.swift
//  SleepyWatcher WatchKit Extension
//
//  Created by yiheng on 2020/01/27.
//  Copyright © 2020 nakarin. All rights reserved.
//

import SwiftUI
import WatchKit
import WatchConnectivity

struct SettingView: View {
    @ObservedObject var settingModel: SettingModel
    @State var isVibrate: Bool = UserSetting.isVibrate
    @State var napTime: Int = UserSetting.napTime

    var body: some View {
        VStack {
            List {
                Text("isVibrate: " + (settingModel.isVibrate ? "True":"False"))
                Text("napTime: \(settingModel.napTime)")
            }

            Button(
                action: self.syncronize,
                label: {
                    Text("syncronize")
            })
        }
        .navigationBarTitle("モニタリング設定")
    }

    private func syncronize() {
        settingModel.reflesh()
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(settingModel: SettingModel())
            .environment(\.colorScheme, .dark)
    }
}
