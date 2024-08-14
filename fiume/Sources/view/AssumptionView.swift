import fiume_model
import SwiftUI

struct AssumptionView: View {
  var assumption: Assumption
  var updateAction: (Assumption) -> Void
  var deleteAction: (String) -> Void

  @State var value: Double

  init(
    assumption: Assumption,
    updateAction: @escaping (Assumption) -> Void = { _ in },
    deleteAction: @escaping (String) -> Void = { _ in }
  ) {
    self.assumption = assumption
    self.updateAction = updateAction
    self.deleteAction = deleteAction

    self.value = Double(assumption.current)
  }

  var body: some View {
    HStack {
      Text(assumption.name)
      Text(": \(Int(value))")
      Spacer()
      Slider(
        value: $value,
        in: Double(assumption.min)...Double(assumption.max),
        onEditingChanged: { _ in
          if assumption.current != Int(value) {
            updateAction(Assumption(assumption, Int(value)))
          }
        }
      )
      .onChange(of: value) { }

      Spacer()
      Button(action: {
        deleteAction(assumption.name)
      }) {
        Image(systemName: "trash")
          .accessibilityLabel(Text("Delete"))
      }
      .buttonStyle(.plain)
    }
  }
}

#Preview {
  let assumption = Assumption(type: AssumptionType.percent, name: "ROI", min: 0, max: 20, current: 5)
  return AssumptionView(assumption: assumption)
}
