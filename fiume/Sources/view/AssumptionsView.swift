import fiume_model
import SwiftUI

struct AssumptionsView: View {
  @Environment(Assumptions.self)
  var assumptions: Assumptions

  @State var isShowingCreateView = false

  func header(_ section: AssumptionsSection) -> some View {
    HStack {
      Image(systemName: section.iconName)
        .accessibilityLabel(Text(section.name))
      Text(section.name)
      Spacer()
      Button {
        isShowingCreateView.toggle()
      } label: {
        Image( systemName: "plus")
          .accessibilityLabel(Text("Add"))
      }
    }
    .sheet(isPresented: $isShowingCreateView) {
      EditAssumptionView(
        assumption: Assumption.null(section.type),
        buttonName: "Create \(section.name)") { assumption in
          assumptions.add(assumption)
      }
    }
  }

  var body: some View {
    List {
      ForEach(assumptions.sections) { section in
        Section(header: header(section)) {
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
}

#Preview {
  @State var assumptions = Assumptions()
  assumptions.add(Assumption(type: .percent, name: "ROI", min: 1, max: 20, current: 7))

  return AssumptionsView()
    .environment(assumptions)
}
