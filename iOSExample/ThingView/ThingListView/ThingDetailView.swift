import SwiftUI

struct ThingDetailView: View {

    @EnvironmentObject var viewModel: ThingListView.ViewModel
    @Environment(\.presentationMode) var presentation

    var thing: Thing
    @State var isVisible = false

    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("Item:")
                Spacer()
                Text(thing.name)
                    .font(.title)
                    .fontWeight(.bold)
            }
            HStack {
                Toggle("Visibility:", isOn: $isVisible)
                Image(systemName: isVisible ? "eye" : "eye.slash")
            }
            Button {
                viewModel.updtateVisibility(thing: thing, visibility: isVisible)
                presentation.wrappedValue.dismiss()
            } label: {
                Text("SAVE")
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
        }.padding(40)
        .onAppear(perform: {
            isVisible = thing.visible
        })
        .onDisappear(perform: {
            viewModel.updtateVisibility(thing: thing, visibility: isVisible)
        })
    }
}

struct ThingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ThingDetailView(thing: Thing(name: "ASDF", visible: true))
    }
}

