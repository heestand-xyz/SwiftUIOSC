//
//  ContentView.swift
//  Shared
//
//  Created by Anton Heestand on 2021-01-22.
//

import SwiftUI
import SwiftUIOSC

struct ContentView: View {
    
    @State private var osc: OSC = .shared
    
    @OSCState(name: "/test/float") private var testFloat: CGFloat = 0.0
    @OSCState(name: "/test/int") private var testInt: Int = 0
    @OSCState(name: "/test/string") private var testString: String = ""
    
    var body: some View {
        
        VStack {
            
            // Connection
            HStack {
                if osc.connection.isConnected {
                    Text("Connected on")
                } else {
                    Text("Connection is")
                }
                switch osc.connection {
                case .unknown:
                    Label("Unknown", systemImage: "wifi.exclamationmark")
                case .offline:
                    Label("Offline", systemImage: "wifi.slash")
                case .wifi:
                    Label("Wi-Fi", systemImage: "wifi")
                case .cellular:
                    Label("Cellular", systemImage: "antenna.radiowaves.left.and.right")
                }
            }
            
            Divider()
            
            // Test Float
            HStack {
                
                Text("Float")
                    .fontWeight(.bold)
                    .frame(width: 75, alignment: .trailing)
                
                Button {
                    testFloat = 0.0
                } label: {
                    Text("Zero")
                }
                .disabled(testFloat == 0.0)
                
                Slider(value: $testFloat)
                
                Text("\(testFloat, specifier: "%.2f")")
                
            }
            
            // Test Int
            HStack {
            
                Text("Int")
                    .fontWeight(.bold)
                    .frame(width: 75, alignment: .trailing)
                
                Picker("", selection: $testInt) {
                    Text("First").tag(0)
                    Text("Second").tag(1)
                    Text("Third").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
    
            }
            
            // Test String
            HStack {
            
                Text("String")
                    .fontWeight(.bold)
                    .frame(width: 75, alignment: .trailing)
                
                TextField("Text", text: $testString)
                
            }
            
            Divider()
            
            // Info
            VStack(alignment: .leading) {
                HStack {
                    Text("Client Address:")
                        .frame(width: 200, alignment: .trailing)
                    TextField("Address", text: $osc.clientAddress)
                }
                HStack {
                    Text("Client Port:")
                        .frame(width: 200, alignment: .trailing)
                    TextField("Port", text: Binding<String>(get: {
                        "\(osc.clientPort)"
                    }, set: { text in
                        guard let port = Int(text) else { return }
                        osc.clientPort = port
                    }))
                }
                HStack {
                    Text("Server Port:")
                        .frame(width: 200, alignment: .trailing)
                    TextField("Port", text: Binding<String>(get: {
                        "\(osc.serverPort)"
                    }, set: { text in
                        guard let port = Int(text) else { return }
                        osc.serverPort = port
                    }))
                }
            }
            
        }
        .font(.system(.body, design: .monospaced))
        .frame(minWidth: 300, maxWidth: 400)
        .padding()
        .onAppear {
            osc.clientAddress = "localhost"
            osc.clientPort = 8000
            osc.serverPort = 7000
        }
    }
}

#Preview {
    ContentView()
}
