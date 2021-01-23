# SwiftUIOSC


## Install



```swift
import SwiftUI
import SwiftUIOSC
```

## TL;DR

```swift
struct ContentView: View {
    @OSCState(as: "test") var value: CGFloat = 0.0
    var body: some View {
        Slider(value: $value)
        .onAppear {
            OSC.shared.clientAddress = "localhost"
            OSC.shared.clientPort = 8000
        }
    }
}
```

## Example

```swift
struct ContentView: View {
    @ObservedObject var osc: OSC = .shared
    @OSCState(as: "test") var value: CGFloat = 0.0
    var body: some View {
        VStack {
            HStack {
                Text("Connection is")
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
            HStack {
                Slider(value: $value)
                Text("\(value, specifier: "%.2f")")
            }
            VStack(alignment: .leading) {
                Text("server address: \(osc.serverAddress ?? "unknown")")
                Text("server port: \(osc.serverPort)")
                Text("client address: \(osc.clientAddress)")
                Text("client port: \(osc.clientPort)")
            }
        }
        .font(.system(.body, design: .monospaced))
        .padding()
        .onAppear {
            osc.serverPort = 7000
            osc.clientAddress = "127.0.0.1"
            osc.clientPort = 8000
        }
    }
}
```

## macOS Networking

> If you got a **macOS** target in your project make sure to enable **Networking** under "Signing & Capabilities" / "App Sandbox":
> Enable "Incoming Connections (Server)" and "Outgoing Connections (Client)"
