import fiume_model
import SwiftUI

struct AssumptionsView: View {
  @Environment(PercentAssumptions.self)
  var assumptions: PercentAssumptions

  @State var isShowingCreateView = false

  func header(_ type: AssumptionType, _ iconName: String, _ name: String) -> some View {
    HStack {
      Image(systemName: iconName)
        .accessibilityLabel(Text(name))
      Text(name)
      Spacer()
      Button {
        isShowingCreateView.toggle()
      } label: {
        Image( systemName: "plus")
          .accessibilityLabel(Text("Add"))
      }
    }
    .sheet(isPresented: $isShowingCreateView) {
      EditAssumptionView(assumption: Assumption.null, buttonName: "Create") { assumption in
       assumptions.add(assumption)
      }
    }
  }

  var body: some View {
    List {
      Section(header: header(.percent, "percent", "Annual Percentage Rate")) {
        ForEach(assumptions.sorted()) { assumption in
          PercentAssumptionView(
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
  @State var assumptions = PercentAssumptions()
  assumptions.add(Assumption(type: .percent, name: "ROI", min: 1, max: 20, current: 7))

  return AssumptionsView()
    .environment(assumptions)
}
