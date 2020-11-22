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
    @State var messageData_arrary:[messageType]=[]
    
    var tcp:NWConnection
    
    var body: some View {
        VStack{
            List {
                ForEach(0..<messageData_arrary.count, id: \.self, content: {
                    (dataIndex) in
                    messageCellView(data: messageData_arrary[dataIndex])
                })
            }
            .rotationEffect(.radians(.pi))//把list倒轉180
            .scaleEffect(x: -1, y: 1, anchor: .center)
        }.onAppear(){
            getServerMessage()
        }
        
    }
    func getServerMessage() {
        //等待tcp回傳訊息 並放入陣列
        for i in 1...100 {
            tcp.receive(minimumIncompleteLength: 1, maximumLength: 100) { (Data, ContentContext, Bool, NWError) in
                if (Data != nil)
                {
                    messageData_arrary.insert(messageType(mainMessage: String(data: Data!, encoding: .utf8)!), at: 0)//最後將資料插入第0格
                }
                else
                {
                    messageData_arrary.insert(messageType(mainMessage:"伺服器關閉"), at: 0)//最後將資料插入第0格
                }
                
            }
        }
    }
    

}
struct messageCellView: View {
    var data:messageType
    var body:some View{
        Text(data.mainMessage).rotationEffect(.radians(.pi))//因為List180度翻轉所以文字是反的把text顯示倒轉180才會是正的
                    .scaleEffect(x: -1, y: 1, anchor: .center)
    }
    

}


