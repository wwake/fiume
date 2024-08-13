import fiume_model
import SwiftUI

struct AssumptionView: View {
  var assumption: Assumption
  var action: (Assumption) -> Void

  @State var value: Double

  init(assumption: Assumption, action: @escaping (Assumption) -> Void) {
    self.assumption = assumption
    self.action = action
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
            action(Assumption(assumption, Int(value)))
          }
        }
      )
      .onChange(of: value) { }
    }
  }
}

#Preview {
  let assumption = Assumption(type: AssumptionType.percent, name: "ROI", min: 0, max: 20, current: 5)
  return AssumptionView(assumption: assumption) { _ in }
}
