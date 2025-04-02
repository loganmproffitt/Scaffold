import SwiftUI

struct ContentView: View {
    
    init() {
            RealmMigrationManager.configureMigration()
        }
    
    @StateObject private var viewModel = DayViewModel(
        dayService: DayService(),
        date: Date()
    )

    var body: some View {
        NavigationView {
            DayView(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}
