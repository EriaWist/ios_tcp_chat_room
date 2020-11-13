//
//  readMessage.swift
//  ios_tcp
//
//  Created by 阿騰 on 2020/11/13.
//
/*
 參考網址：https://www.coder.work/article/427566
 作法 把list倒轉180
 再把text顯示倒轉180
 最後將資料插入第0格
 這樣看起來就像下面往上推
 
*/

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
                        .rotationEffect(.radians(.pi))//再把text顯示倒轉180
                        .scaleEffect(x: -1, y: 1, anchor: .center)
                })
            }
            .rotationEffect(.radians(.pi))//把list倒轉180
            .scaleEffect(x: -1, y: 1, anchor: .center)
        }.onAppear(){
            for i in 1...100 {
                tcp.receive(minimumIncompleteLength: 1, maximumLength: 100) { (Data, ContentContext, Bool, NWError) in
                    messageData.insert(Text(String(data: Data!, encoding: .utf8)!), at: 0)//最後將資料插入第0格
                }
            }
            
        }
    }
}


