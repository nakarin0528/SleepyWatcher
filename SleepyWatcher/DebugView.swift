//
//  DebugView.swift
//  SleepyWatcher
//
//  Created by yiheng on 2020/02/05.
//  Copyright © 2020 nakarin. All rights reserved.
//

import SwiftUI

struct DebugView: View {
    @ObservedObject var model: HeartRateModel
    var body: some View {
        VStack {
            Button(
                action: self.model.sendStartAlarm,
                label: {
                    Text("Sleepy Detected!").padding()
            })
                .foregroundColor(Color.white)
                .background(Color.red)
                .cornerRadius(20)
        }.navigationBarTitle(Text("Debug"))
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView(model: HeartRateModel()).colorScheme(.dark)
    }
}
