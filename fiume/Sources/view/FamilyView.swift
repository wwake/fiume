import SwiftUI

struct FamilyView: View {
  @Bindable var family: Family
  @State var isShowingCreateView = false

  var header: some View {
    HStack {
      Image(systemName: "person.2.fill")
        .accessibilityLabel(Text("Family"))
      Text("Family")
      Spacer()
      Button {
        isShowingCreateView.toggle()
      } label: {
        Image( systemName: "plus")
          .accessibilityLabel(Text("Add"))
      }
    }
    .sheet(isPresented: $isShowingCreateView) {
      CreatePersonView(family: family)
    }
  }

  var body: some View {
    List {
      Section(header: header) {
        ForEach(family.people) { person in
          Text(person.name)
        }
      }
    }
  }
}

#Preview {
  FamilyView(family: Family())
}
