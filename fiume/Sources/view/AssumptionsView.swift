import SwiftUI

struct AssumptionsView: View {
  @State var isShowingCreateView = false
  @State var isEditPresented = false

  var header: some View {
    HStack {
      Image(systemName: "pyramid")
        .accessibilityLabel(Text("Assumptions"))
      Text("Assumptions")
      Spacer()
      Button {
        isShowingCreateView.toggle()
      } label: {
        Image( systemName: "plus")
          .accessibilityLabel(Text("Add"))
      }
    }
    .sheet(isPresented: $isShowingCreateView) {
      Text("Create an assumption")
//      EditAssumptionsView(person: Person.null, buttonName: "Create") { person in
//        people.add(person)
//      }
    }
  }

  var body: some View {
    List {
      Section(header: header) {
        Text("No assumptions yet")
      }
    }
  }
}

#Preview {
  AssumptionsView()
}
