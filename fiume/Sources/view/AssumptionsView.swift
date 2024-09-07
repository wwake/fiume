import fiume_model
import SwiftUI

struct AssumptionsView: View {
  @Environment(Assumptions.self)
  var assumptions: Assumptions

  var body: some View {
    List {
      ForEach(assumptions.sections) { section in
        Section(header: AssumptionHeaderView(section: section)) {
          AssumptionTypeView(section)
        }
      }
    }
  }

  fileprivate func AssumptionTypeView(_ section: AssumptionsSection) -> some View {
    ForEach(assumptions.filter(section.type).sorted()) { assumption in
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

#Preview {
  @State var assumptions = Assumptions()
  assumptions.add(Assumption(type: .percent, name: "ROI", min: 1, max: 20, current: 7))

  return AssumptionsView()
    .environment(assumptions)
}
