import SwiftUI

@main
struct SubTrackApp: App {
    private let container = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            RootView(container: container)
        }
    }
}
