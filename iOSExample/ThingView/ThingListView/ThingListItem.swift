import SwiftUI

struct ThingListItem: View {

    var thing: Thing
    var body: some View {
        NavigationLink(destination: ThingDetailView(thing: thing)) {
            HStack {
                Text(thing.name)
                Spacer()
                Image(systemName: thing.visible ? "eye" : "eye.slash")
            }
        }
    }
}

struct ThingListItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                ThingListItem(thing: Thing(name: "A Thing", visible: true))
            }
            List {
                ThingListItem(thing: Thing(name: "A Thing", visible: false))
            }
        }
    }
}
