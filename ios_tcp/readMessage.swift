//
//  readMessage.swift
//  ios_tcp
//
//  Created by 阿騰 on 2020/11/13.
//

import SwiftUI
import Network
struct readMessage: View {
    @State var messageData:[Text] = []
    var tcp:NWConnection
   
    var body: some View {
        VStack{
            List {
                ForEach(0..<messageData.count, id: \.self, content: {
                    (data) in
                    messageData[data]
                })
            }
        }.onAppear(){
            for i in 1...10 {
                tcp.receive(minimumIncompleteLength: 1, maximumLength: 100) { (Data, ContentContext, Bool, NWError) in
                    messageData.append(Text(String(data: Data!, encoding: .utf8)!))
                }
            }
            
        }
    }
}


