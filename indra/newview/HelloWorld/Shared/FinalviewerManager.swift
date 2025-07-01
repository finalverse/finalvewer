//
//  FinalviewerManager.swift
//  HelloWorld Shared
//
//  Manager class for interfacing with Finalviewer backend
//

import Foundation
import Combine

// Notification names for Finalviewer events
extension Notification.Name {
    static let finalviewerConnected = Notification.Name("FinalviewerConnected")
    static let finalviewerDisconnected = Notification.Name("FinalviewerDisconnected")
    static let finalviewerMessageReceived = Notification.Name("FinalviewerMessageReceived")
}

// Main manager class for Finalviewer integration
class FinalviewerManager: ObservableObject {
    
    // Singleton instance
    static let shared = FinalviewerManager()
    
    // Published properties for SwiftUI binding
    @Published var isConnected: Bool = false
    @Published var agentInfo: [String: Any]?
    @Published var lastMessage: [String: Any]?
    @Published var viewerVersion: String = ""
    @Published var gridName: String = ""
    
    // Timer for polling message updates
    private var messageTimer: Timer?
    
    private init() {
        // Initialize the message system
        if LLBridge_InitializeMessageSystem() {
            print("Finalviewer message system initialized successfully")
            
            // Get initial viewer info
            viewerVersion = LLBridge_GetViewerVersion()
            gridName = LLBridge_GetGridName()
            
            // Start polling for messages
            startMessagePolling()
        } else {
            print("Failed to initialize Finalviewer message system")
        }
    }
    
    // Connect to OpenSim/MutSea server
    func connect(to serverURL: String, username: String, password: String) {
        guard !username.isEmpty, username.contains(" ") else {
            print("Username must be in format 'FirstName LastName'")
            return
        }
        
        if LLBridge_ConnectToServer(serverURL, username, password) {
            // Connection initiated, wait for actual connection
            checkConnectionStatus()
        }
    }
    
    // Disconnect from server
    func disconnect() {
        LLBridge_Disconnect()
        isConnected = false
        agentInfo = nil
        
        NotificationCenter.default.post(name: .finalviewerDisconnected, object: nil)
    }
    
    // Send a message to the backend
    func sendMessage(name: String, parameters: [String: Any]) {
        let params = parameters as NSDictionary
        
        if LLBridge_SendMessage(name, params) {
            print("Message '\(name)' sent successfully")
        } else {
            print("Failed to send message '\(name)'")
        }
    }
    
    // Example: Send a chat message
    func sendChatMessage(_ message: String, channel: Int = 0) {
        let parameters: [String: Any] = [
            "Channel": channel,
            "Type": 1, // CHAT_TYPE_NORMAL
            "Message": message
        ]
        
        sendMessage(name: "ChatFromViewer", parameters: parameters)
    }
    
    // Example: Teleport to location
    func teleport(to regionName: String, position: (x: Float, y: Float, z: Float)) {
        let parameters: [String: Any] = [
            "RegionName": regionName,
            "PositionX": position.x,
            "PositionY": position.y,
            "PositionZ": position.z
        ]
        
        sendMessage(name: "TeleportLocationRequest", parameters: parameters)
    }
    
    // Check connection status
    private func checkConnectionStatus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            let connected = LLBridge_IsConnected()
            
            if connected != self?.isConnected {
                self?.isConnected = connected
                
                if connected {
                    self?.updateAgentInfo()
                    NotificationCenter.default.post(name: .finalviewerConnected, object: nil)
                }
            }
            
            // Continue checking if not connected yet
            if !connected {
                self?.checkConnectionStatus()
            }
        }
    }
    
    // Update agent information
    private func updateAgentInfo() {
        if let info = LLBridge_GetAgentInfo() as? [String: Any] {
            agentInfo = info
        }
    }
    
    // Start polling for incoming messages
    private func startMessagePolling() {
        messageTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.checkForNewMessages()
        }
    }
    
    // Check for new messages
    private func checkForNewMessages() {
        if let message = LLBridge_GetLastReceivedMessage() as? [String: Any] {
            // Check if this is a new message
            if !NSDictionary(dictionary: message).isEqual(to: lastMessage ?? [:]) {
                lastMessage = message
                
                NotificationCenter.default.post(
                    name: .finalviewerMessageReceived,
                    object: nil,
                    userInfo: message
                )
            }
        }
    }
    
    deinit {
        messageTimer?.invalidate()
    }
}