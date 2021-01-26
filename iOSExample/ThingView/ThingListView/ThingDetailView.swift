//
//  ThingDetailView.swift
//  iOSExample
//
//  Created by Frank Fleschner on 1/25/21.
//

import SwiftUI

struct ThingDetailView: View {

    @EnvironmentObject var viewModel: ThingListView.ViewModel

    var thing: Thing
    @State var isVisible = false

    var body: some View {
        VStack {
            Text(thing.name)
            Toggle("Is Visible", isOn: $isVisible)
            Button(action: { viewModel.updtateVisibility(thing: thing, visibility: isVisible) }, label: {
                Text("SAVE")
            })
        }.padding()
        .onAppear( perform: {
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
