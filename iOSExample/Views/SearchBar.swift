import Foundation
import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text("Search")
                        .foregroundColor(Color.white.opacity(0.5))
                        .padding(.leading, 40)
                }
                TextField("", text: $text) { isEdit in
                    isEditing = isEdit
                }
                .autocapitalization(.none)
                .foregroundColor(.white)
                .padding(.vertical, 20)
                .padding(.leading, 40)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 15)
                        if isEditing {
                            Button {
                                text = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white)
                                    .padding(.trailing, 15)
                            }
                        }
                    }
                )
            }
        }
        .background(Color.blue)
    }
}


struct SearchBar_Previews: PreviewProvider {

    static var previews: some View {
        SearchBar(text: .constant(""))

    }
}
