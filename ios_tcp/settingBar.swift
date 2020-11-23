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
    @State var nextPage = true
    var body: some View {
        HStack {
            Spacer()
            Text("聊天室")
                .font(.title)
            Spacer()
            Button(action: {
                tcp.restart()
            }) {
                Image(systemName: "goforward")
                    .resizable()
                    .frame(width: 40.0, height: 40.0)
                    .scaledToFill()
                
            }
            Button(action: {nextPage=true}) {
                
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .frame(width: 40.0, height: 40.0)
                    .scaledToFill()
        
            }.sheet(isPresented: $nextPage){
                settingPage(tcp: $tcp)
            }
            
        }
        .padding(.horizontal, 30.0)
    }
}
struct settingPage :View {
    @Binding var tcp:NWConnection
    @State var ip=""
    @State var port=""
    var body: some View{
        VStack{
            HStack{
                Text("請輸入ip:")
                TextField("ip", text: $ip)
            }
            HStack{
                Text("請輸入port:")
                TextField("port", text: $port)
            }
            Button(action: {
                if UInt16(port) != nil && IPv4Address(ip) != nil
                {
                tcp.cancel()
                tcp = NWConnection(host: NWEndpoint.Host(ip), port: NWEndpoint.Port(rawValue: UInt16(port) ?? 0)!, using: .tcp)
                tcp.start(queue: .main)
                }
            }, label: {
                Text("設定")
                
            })
        }
    }
}



