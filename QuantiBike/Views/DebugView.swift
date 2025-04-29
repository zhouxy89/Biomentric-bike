import SwiftUI

struct DebugView: View {
    @Binding var subjectId: String
    @Binding var debug: Bool
    @EnvironmentObject var logItemServer: LogItemServer

    var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State var startTime = Date()
    @State var runtime = 0.0

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "bicycle")
                Text("QuantiBike Debug").font(.largeTitle)
            }
            Spacer()

            List {
    ForEach(Array(logItemServer.logManagers.keys), id: \.self) { boardID in
        if let manager = logItemServer.logManagers[boardID] {
            Section(header: Text("Board: \(boardID)")) {
                Text("FSR1: \(manager.latestFSR1)")
                Text("FSR2: \(manager.latestFSR2)")
                Text("FSR3: \(manager.latestFSR3)")
                Text("FSR4: \(manager.latestFSR4)")
            }
        }
    }
}

            Spacer()

            Button("Save All CSVs", role: .destructive) {
                for (_, manager) in logItemServer.logManagers {
                    manager.saveCSV()
                }
                debug = false
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .onAppear {
            preventSleep()
            startTime = Date()
        }
        .onReceive(timer) { _ in
            runtime = Date().timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
        }
    }

    func preventSleep() {
        if UIApplication.shared.isIdleTimerDisabled == false {
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        if let server = try? LogItemServer(port: 12345) {
            DebugView(subjectId: .constant("test"), debug: .constant(true))
                .environmentObject(server)
        } else {
            Text("Failed to start preview.")
        }
    }
}
