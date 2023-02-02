//
//  ServerInfo.swift
//  Test Project
//
//  Created by TJ Hunter on 2/1/23.
//

import Foundation

struct ServerInfo: Codable {
    let klippyConnected: Bool
    let klippyState: String
    let components: [String]
    let failedComponents: [String]
    let registeredDirectories, warnings: [String]
    let websocketCount: Int
    let moonrakerVersion: String
    let apiVersion: [Int]
    let apiVersionString: String

    enum CodingKeys: String, CodingKey {
        case klippyConnected = "klippy_connected"
        case klippyState = "klippy_state"
        case components
        case failedComponents = "failed_components"
        case registeredDirectories = "registered_directories"
        case warnings
        case websocketCount = "websocket_count"
        case moonrakerVersion = "moonraker_version"
        case apiVersion = "api_version"
        case apiVersionString = "api_version_string"
    }
}
