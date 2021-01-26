import SwiftUI

@main
struct iOSExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ThingListView(viewModel: .init())
        }
    }
}
