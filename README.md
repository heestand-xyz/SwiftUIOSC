# SwiftUIOSC


## Install

In Xcode go to *File* /  *Swift Packages* / *Add Package Dependency...* and enter the repo url:
```
https://github.com/heestand-xyz/SwiftUIOSC
```

Import packages:

```swift
import SwiftUI
import SwiftUIOSC
import OSCTools2
```

Wrap a property with the `@OSCState` and give it an osc address name.

## TL;DR

```swift
struct ContentView: View {
    
    @State @OSCState(address: "/test") private var test: CGFloat = 0.0
    
    var body: some View {
        Slider(value: $test.osc)
            .onAppear {
                OSCManager.osc.settings.clientAddress = "localhost"
                OSCManager.osc.settings.clientPort = 8000
            }
    }
}
```

## Demo Project

Demo project available in repo.

<img src="https://github.com/heestand-xyz/SwiftUIOSC/blob/main/Assets/SwiftUIOSC-Screenshot-iOS.png?raw=true" width=300> <img src="https://github.com/heestand-xyz/SwiftUIOSC/blob/main/Assets/SwiftUIOSC-Screenshot-macOS.png?raw=true" width=400>

```swift
import SwiftUI
import SwiftUIOSC
import OSCTools2

struct ContentView: View {
    
    @StateObject private var oscSettings: OSCSettings = OSCManager.osc.settings
    @StateObject private var oscConnection: OSCConnection = OSCManager.osc.connection
    
    @State @OSCState(address: "/test/float") private var testFloat: CGFloat = 0.0
    @State @OSCState(address: "/test/int") private var testInt: Int = 0
    @State @OSCState(address: "/test/string") private var testString: String = ""
    
    var body: some View {
        
        VStack {
            
            // Connection
            HStack {
                if oscConnection.state != .offline {
                    Text("Connected over")
                } else {
                    Text("Connection is")
                }
                switch oscConnection.state {
                case .offline:
                    Label("Offline", systemImage: "wifi.slash")
                case .wifi:
                    Label("Wi-Fi", systemImage: "wifi")
                case .cellular:
                    Label("Cellular", systemImage: "antenna.radiowaves.left.and.right")
                }
            }
            
            Divider()
            
            // Float
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
                
                Slider(value: $testFloat.osc)
                
                Text("\(testFloat, specifier: "%.2f")")
                
            }
            
            // Int
            HStack {
            
                Text("Int")
                    .fontWeight(.bold)
                    .frame(width: 75, alignment: .trailing)
                
                Picker("", selection: $testInt.osc) {
                    Text("First").tag(0)
                    Text("Second").tag(1)
                    Text("Third").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
    
            }
            
            // String
            HStack {
            
                Text("String")
                    .fontWeight(.bold)
                    .frame(width: 75, alignment: .trailing)
                
                TextField("Text", text: $testString.osc)
                
            }
            
            Divider()
            
            // Info
            VStack(alignment: .leading) {
                HStack {
                    Text("Client Address:")
                        .frame(width: 200, alignment: .trailing)
                    TextField("Address", text: $oscSettings.clientAddress)
                }
                HStack {
                    Text("Client Port:")
                        .frame(width: 200, alignment: .trailing)
                    TextField("Port", text: Binding<String>(get: {
                        "\(oscSettings.clientPort)"
                    }, set: { text in
                        guard let port = Int(text) else { return }
                        oscSettings.clientPort = port
                    }))
                }
                HStack {
                    Text("Server Port:")
                        .frame(width: 200, alignment: .trailing)
                    TextField("Port", text: Binding<String>(get: {
                        "\(oscSettings.serverPort)"
                    }, set: { text in
                        guard let port = Int(text) else { return }
                        oscSettings.serverPort = port
                    }))
                }
            }
            
        }
        .font(.system(.body, design: .monospaced))
        .frame(minWidth: 300, maxWidth: 400)
        .padding()
        .onAppear {
            oscSettings.clientAddress = "localhost"
            oscSettings.clientPort = 8000
            oscSettings.serverPort = 7000
        }
    }
}

#Preview {
    ContentView()
}
```

## macOS Networking

> If you got a **macOS** target in your project make sure to enable **Networking** under "Signing & Capabilities" / "App Sandbox":
> Enable "Incoming Connections (Server)" and "Outgoing Connections (Client)"

## Testing

I recommend using [Protokol by Hexler](https://hexler.net/protokol) to test OSC.
