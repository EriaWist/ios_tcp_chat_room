//
//  sendMessage.swift
//  ios_tcp
//
//  Created by 阿騰 on 2020/11/13.
//

import SwiftUI
import Network
struct sendMessage: View {
    @State var message=""
    var tcp:NWConnection
    var body: some View {
        HStack{
            TextField("  Placeholder", text: $message)
                .frame(height: 45.0)
                .border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/4/*@END_MENU_TOKEN@*/)
                .cornerRadius(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
                
                
            Button(action: {
                tcp.send(content: message.data(using: .utf8), completion: NWConnection.SendCompletion.idempotent)
                message=""
            }) {
                Text("發送")
            }
        }
        .padding(.horizontal, 35.0)
    }
}


