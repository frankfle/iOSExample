import SwiftUI

struct ThingListView: View {

    @EnvironmentObject var viewModel: ThingListView.ViewModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    filterButton
                        .padding(5)
                }
                SearchBar(text: $viewModel.searchText)
                listView
            }
            .navigationBarItems(leading: createErrorButton, trailing: createThingButton)
            .navigationTitle("Things")
            .padding(0)
        }
        .onAppear(perform: { viewModel.getThings() })
        .alert(isPresented: $viewModel.alertPresent, content: { createAlert() })
        .sheet(isPresented: $viewModel.filterPresent, content: { createFilter() })
    }

    @ViewBuilder
    var filterButton: some View {
        Button {
            viewModel.filterPresent = true
        } label: {
            Image(systemName: viewModel.visiblityFilter == .none ?
                    "line.horizontal.3.decrease.circle" :
                    "line.horizontal.3.decrease.circle.fill")
                .foregroundColor(Color.blue)
        }
        .buttonStyle(PlainButtonStyle())
    }

    @ViewBuilder
    var listView: some View {
        List {
            ForEach(viewModel.filteredThings) { thing in
                ThingListItem(thing: thing)
            }

            Text("\(viewModel.filteredThings.count) Thing(s)").foregroundColor(.gray)
        }
    }

    @ViewBuilder
    var createErrorButton: some View {
        Button(action: { viewModel.addThingError() }, label: {
                Text("Error")})
    }

    @ViewBuilder
    var createThingButton: some View {
        Button(action: { viewModel.addThing() }, label: {
                Text("Create")})
    }

    func createAlert() -> Alert {
        Alert(title: Text("Error"),
              message: Text("An Error was encountered.  Please try again later."),
              dismissButton: .cancel(Text("OK"), action: {
                viewModel.getThings()
                viewModel.clearAlert()
              }))
    }

    func createFilter() -> some View {
        VStack {
            Picker ("Visibility", selection: $viewModel.visiblityFilter) {
                Label("Visible", systemImage: "eye").tag(ViewModel.VisibilityFilter.visible)
                Label("Invisible", systemImage: "eye.slash").tag(ViewModel.VisibilityFilter.invisible)
                Label("None", systemImage: "slash.circle").tag(ViewModel.VisibilityFilter.none)
            }
            Button {
                viewModel.filterPresent = false
            } label: {
                Label("Close", systemImage: "xmark")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ThingListView().environmentObject(ThingListView.ViewModel())
    }
}
