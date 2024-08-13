import SwiftUI

struct AssumptionView: View {
  var assumption: Assumption
  var action: (Int) -> Void

  @State var value: Double = 0.0

  var body: some View {
    HStack {
      Text(assumption.name)
      Text(": \(Int(value))")
      Spacer()
      Slider(
        value: $value,
        in: Double(assumption.min)...Double(assumption.max),
        onEditingChanged: { _ in
          action(Int(value))
        }
      )
      .onChange(of: value) { _, _ in
      }
    }
  }
}

#Preview {
  let assumption = Assumption(type: AssumptionType.percent, name: "ROI", min: 0, max: 20, current: 5)
  return AssumptionView(assumption: assumption) { _ in }
}
