//
//  settingBar.swift
//  ios_tcp
//
//  Created by 阿騰 on 2020/11/22.
//

import SwiftUI
import Network
struct settingBar: View {
    @Binding var tcp:NWConnection
    var body: some View {
        HStack {
            Spacer()
            Text("聊天室")
                .font(.title)
                
            Spacer()
            Button(action: {
                tcp.restart()
            }) {
                Image(systemName: "goforward").resizable().frame(width: 40.0, height: 40.0).scaledToFill()
            
            }
            Button(action: {}) {
                Image(systemName: "slider.horizontal.3").resizable().frame(width: 40.0, height: 40.0).scaledToFill()
            
            }
            
        }
        .padding(.horizontal, 30.0)
    }
}


