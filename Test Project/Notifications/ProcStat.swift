//
//  ProcStatUpdate.swift
//  Test Project
//
//  Created by TJ Hunter on 2/1/23.
//

import Foundation

// MARK: - ServerInfoResponse
struct ProcStat: Codable {
    let moonrakerStats: MoonrakerStats
    let cpuTemp: Double
    let network: Network
    let systemCPUUsage: SystemCPUUsage
    let systemMemory: SystemMemory
    let websocketConnections: Int

    enum CodingKeys: String, CodingKey {
        case moonrakerStats = "moonraker_stats"
        case cpuTemp = "cpu_temp"
        case network
        case systemCPUUsage = "system_cpu_usage"
        case systemMemory = "system_memory"
        case websocketConnections = "websocket_connections"
    }
}

// MARK: - MoonrakerStats
struct MoonrakerStats: Codable {
    let time, cpuUsage: Double
    let memory: Int
    let memUnits: String

    enum CodingKeys: String, CodingKey {
        case time
        case cpuUsage = "cpu_usage"
        case memory
        case memUnits = "mem_units"
    }
}

// MARK: - Network
struct Network: Codable {
    let lo, eth0, wlan0: NetworkStats
}

struct NetworkStats: Codable {
    let rxBytes: Int64
    let txBytes: Int64
    let rxPackets: Int64
    let txPackets: Int64
    let rxErrs: Int64
    let txErrs: Int64
    let rxDrop: Int64
    let txDrop: Int64
    let bandwidth: Double
    
    enum CodingKeys: String, CodingKey {
        case rxBytes = "rx_bytes"
        case txBytes = "tx_bytes"
        case rxPackets = "rx_packets"
        case txPackets = "tx_packets"
        case rxErrs = "rx_errs"
        case txErrs = "tx_errs"
        case rxDrop = "rx_drop"
        case txDrop = "tx_drop"
        case bandwidth
    }
}

// MARK: - SystemCPUUsage
struct SystemCPUUsage: Codable {
    let cpu, cpu0: Double
    let cpu1, cpu2: Double
    let cpu3: Double
}

// MARK: - SystemMemory
struct SystemMemory: Codable {
    let total, available, used: Int
}
