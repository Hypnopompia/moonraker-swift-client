//
//  Test_ProjectApp.swift
//  Test Project
//
//  Created by TJ Hunter on 1/24/23.
//

import SwiftUI
import JsonRPC
import Serializable

// Need this in order to send an empty param json object instead of an empty array.
// the JsonRPC Params() function wraps everything (including nothing) in an array and moonraker wants a dict. boo
struct Empty: Encodable {
}

// This is to capture JsonRPC notification messages from the server. See the init() func below for details
class MyRpcDelegate: ConnectableDelegate, ServerDelegate, ErrorDelegate, NotificationDelegate {
    public init() {
        // probably pass in some type of global store here to keep updated with incoming data?
    }
    
    // Connectable Delegate. Will send connection updates
    public func state(_ state: ConnectableState) {
        print("Connection state: \(state)")
    }

    // Error delegate. Will send global errors (unknown response id, etc.)
    public func error(_ error: ServiceError) {
        print("Error: \(error)")
    }

    public func notification(method: String, params: Parsable) {
        switch(method) {
        case "notify_proc_stat_update":
            procStatUpdateNotification(params: params)
        //case "notify_gcode_response":
        //case "notify_history_changed":
        default:
            print("Unhandled Notification: " + method)
        }
    }
    
    private func procStatUpdateNotification(params: Parsable) {
        guard let procStat = try! params.parse(to: [ProcStat].self).get()!.first else {
            return
        }
        let date = NSDate(timeIntervalSince1970: procStat.moonrakerStats.time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY hh:mm:ss"
        
        print("Server Time: " + dateFormatter.string(from: date as Date))
    }
}

@main
struct Test_ProjectApp: App {
    let persistenceController = PersistenceController.shared
    var rpc: JsonRPC.Service<JsonRPC.ServiceCore<JsonRPC.WsConnectionFactory.Connection, AnyObject>>
    var myDelegate: MyRpcDelegate

    init() {
        print("hello!")
        
        // Don't auto connect yet, because we need to supply our own delegate handler for notications first.
        rpc = JsonRpc(.ws(url: URL(string: "ws://ender3.local/websocket")!, autoconnect: false), queue: .main)
        // However, in order to continue to listen for notification messages, we need to keep `rpc` around longer than this init() function will live,
        // So instead of declaring it in here with `let`, I made it a property of this struct, so it should exist for as long as the app is running.
        
        // Set delegate. Notification and statuses will be forwarded to it
        // JSON RPC allows for the server to send messages without having to explictly ask for them. For moonraker, this is the current
        // stats from the print server. CPU usage, time, etc. We need to capture those as well, so we give the rpc client a delegate
        // to capture them and decode them.
        // I had a problem with the delegate suddenly disapearing from the rpc object after I set it. After looking through the code
        // I noticed the delegate property on the RPC client was a `weak` type, which I learned can go away after the init() function finished
        // So I also made that a property of the main app struct so that it would stick around.

        myDelegate = MyRpcDelegate()
        rpc.delegate = myDelegate
                
        // Now we connect to the server
        rpc.connect()
  
        // Running async doesn't work anymore.
        // Since `rpc` is now a property of the struct, I get an error:
        // "Escaping closure captures mutating 'self' parameter"
        // I guess because the rpc property can change now, swift doesn't like using it in a Task.
        
//        Task.init {
//            let params = CallParam(Empty()) // Use an empty params obj
//            let websocketResponse = try await rpc.call(method: "server.websocket.id", params: params, ServerWebsocketId.self, String.self)
//            print("Websocket ID: " + String(websocketResponse.websocket_id)) // it works!!!
//
//            let serverInfoResponse = try await rpc.call(method: "server.info", params: params, ServerInfo.self, String.self)
//            print("Connected to moonraker version " + serverInfoResponse.moonrakerVersion)
//        }

        // However, I can still call it using callbacks, which isn't as cool.
        let params = CallParam(Empty()) // Use an empty params obj
        rpc.call(method: "server.websocket.id", params: params, ServerWebsocketId.self, String.self) { res in
            let websocketResponse = try! res.get()
            print("Websocket ID: " + String(websocketResponse.websocket_id))
        }
        rpc.call(method: "server.info", params: params, ServerInfo.self, String.self) { res in
            let serverInfoResponse = try! res.get()
            print("Connected to moonraker version " + serverInfoResponse.moonrakerVersion)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
