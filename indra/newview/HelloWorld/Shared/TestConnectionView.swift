//
//  TestConnectionView.swift
//  HelloWorld
//
//  Test view for Finalviewer connection
//

import SwiftUI

struct TestConnectionView: View {
    @StateObject private var manager = FinalviewerManager.shared
    @State private var serverURL = "http://localhost:9000"
    @State private var username = "Test User"
    @State private var password = ""
    @State private var chatMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Connection status
            HStack {
                Circle()
                    .fill(manager.isConnected ? Color.green : Color.red)
                    .frame(width: 10, height: 10)
                Text(manager.isConnected ? "Connected" : "Disconnected")
            }
            
            // Viewer info
            VStack(alignment: .leading) {
                Text("Viewer: \(manager.viewerVersion)")
                Text("Grid: \(manager.gridName)")
            }
            .font(.caption)
            
            // Connection controls
            if !manager.isConnected {
                VStack {
                    TextField("Server URL", text: $serverURL)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Username (First Last)", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Connect") {
                        manager.connect(to: serverURL, username: username, password: password)
                    }
                }
                .padding()
            } else {
                // Agent info
                if let agentInfo = manager.agentInfo {
                    VStack(alignment: .leading) {
                        Text("Agent: \(agentInfo["fullName"] as? String ?? "Unknown")")
                        Text("Region: \(agentInfo["regionName"] as? String ?? "Unknown")")
                        
                        if let position = agentInfo["position"] as? [String: Double] {
                            Text("Position: (\(Int(position["x"] ?? 0)), \(Int(position["y"] ?? 0)), \(Int(position["z"] ?? 0)))")
                        }
                    }
                    .font(.caption)
                }
                
                // Chat controls
                HStack {
                    TextField("Chat message", text: $chatMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Send") {
                        manager.sendChatMessage(chatMessage)
                        chatMessage = ""
                    }
                }
                
                Button("Disconnect") {
                    manager.disconnect()
                }
            }
            
            // Last message
            if let lastMessage = manager.lastMessage {
                VStack(alignment: .leading) {
                    Text("Last Message:")
                        .font(.headline)
                    Text("\(lastMessage)")
                        .font(.caption)
                        .lineLimit(5)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
    }
}