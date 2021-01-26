import SwiftUI

struct ThingListView: View {

    @ObservedObject var viewModel: ThingListView.ViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.things) { thing in
                    ThingListItem(thing: thing)
                }

                Text("\(viewModel.things.count) Thing(s)").foregroundColor(.gray)
            }
            .navigationBarItems(leading: createErrorButton, trailing: createThingButton)
            .navigationTitle("Things")
        }
        .onAppear(perform: { viewModel.getThings() })
        .alert(isPresented: $viewModel.alertPresent, content: { createAlert() })
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ThingListView(viewModel: .init())
    }
}
