//
//  Test_ProjectApp.swift
//  Test Project
//
//  Created by TJ Hunter on 1/24/23.
//

import SwiftUI
import Foundation
import JsonRPC
import Serializable

@main
struct Test_ProjectApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        print("hello!")
//        let rpc = JsonRpc(.ws(url: URL(string: "ws://ender3.local/websocket")!), queue: .main)
//
//        rpc.call(method: "server.connection.identify", params: Params(), String.self, String.self) { res in
//            print("back from command")
//            print(try! res.get())
//        }
        
        Task {
            let rpc = JsonRpc(.ws(url: URL(string: "ws://ender3.local/websocket")!), queue: .main)
            let res = try await rpc.call(method: "server.connection.identify", params: Params(), String.self, String.self)
            print(res)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
