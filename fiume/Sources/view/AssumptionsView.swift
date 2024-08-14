import fiume_model
import SwiftUI

struct AssumptionsView: View {
  @Environment(Assumptions.self)
  var assumptions: Assumptions

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
      EditAssumptionsView(assumption: Assumption.null, buttonName: "Create") { _ in
       // people.add(person)
      }
    }
  }

  var body: some View {
    List {
      Section(header: header) {
        ForEach(assumptions.sorted()) { assumption in
          AssumptionView(
            assumption: assumption,
            updateAction: { revisedAssumption in
              assumptions.replace(revisedAssumption)
            },
            deleteAction: { name in
              assumptions.remove(name)
            }
          )
        }
      }
    }
  }
}

#Preview {
  AssumptionsView()
}
