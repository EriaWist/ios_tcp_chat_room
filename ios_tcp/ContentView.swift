//
//  ContentView.swift
//  ios_tcp
//
//  Created by 阿騰 on 2020/11/13.
//

import SwiftUI
import Network
struct ContentView: View {
    init() {
            tcp.start(queue: .main)
    }
    var tcp = NWConnection(host: NWEndpoint.Host("127.0.0.1"), port: NWEndpoint.Port(rawValue: 5678)!, using: .tcp)
    var body: some View {
        VStack {
            settingBar()
            readMessage(tcp: tcp)
                .padding(.bottom, 10.0)
            sendMessage(tcp: tcp)
        }
        .padding(.bottom, 30.0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
