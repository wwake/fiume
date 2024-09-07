import fiume_model
import SwiftUI

public struct AssumptionHeaderView: View {
  @Environment(Assumptions.self)
  var assumptions: Assumptions

  @State var isShowingCreateView = false

  var section: AssumptionsSection

  public var body: some View {
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
}
