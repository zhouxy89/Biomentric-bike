import SwiftUI

@main
struct QuantiBikeApp: App {
    var logItemServer: LogItemServer?
    @State var logManager = LogManager()

    init() {
        LocationManager.shared.startTracking()
        do {
            let server = try LogItemServer(port: 12345)
            server.start()
            logItemServer = server
        } catch {
            logManager.saveCSV()
            print("An error occurred initializing LogItemServer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            if let server = logItemServer {
                ContentView().environmentObject(server)
            } else {
                // Provide an alternative view or handling if the server fails to initialize
                ContentView()
            }
        }
    }
}
