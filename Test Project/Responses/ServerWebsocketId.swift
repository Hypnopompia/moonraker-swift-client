//
//  ServerWebsocketId.swift
//  Test Project
//
//  Created by TJ Hunter on 2/1/23.
//

import Foundation

// This is needed in order for the decoder to know how to decode the response into something
// This is the most simple response I could find in the api to test with. not sure how to nest these yet, or if I need to.
// Server reponse comes back as: {"jsonrpc": "2.0", "result": {"websocket_id": 1728390640}, "id": 1}
struct ServerWebsocketId: Decodable {
    public let websocket_id: Int64
}
