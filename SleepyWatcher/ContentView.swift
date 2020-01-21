//
//  ContentView.swift
//  SleepyWatcher
//
//  Created by yiheng on 2019/12/29.
//  Copyright © 2019 nakarin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
//    @ObservedObject var healthReader = HealthReader()
    @State var bool: Bool = false
    var body: some View {
        VStack() {
            Image("univerce")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .mask(Takadama(bool: self.bool))
//                    .mask(Takadama(bool: self.bool))
            Button(action:{self.bool = !self.bool}) {
                Text("Animate!")
            }
        }

//        Text(String(healthReader.getHR()))
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

struct Takadama: View {
    var bool: Bool
    var body: some View {
        if self.bool {
//            return AnyView(Capsule())
            return AnyView(Image("takadamalab"))
//            .resizable()
//            .aspectRatio(contentMode: .fit))

        } else {
            return AnyView(Circle())
        }
//        Image("takadamalab")
//        .resizable()
//        .aspectRatio(contentMode: .fit)
    }
}
