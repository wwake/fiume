import fiume_model
import SwiftUI

struct AssumptionView: View {
  var assumption: Assumption
  var updateAction: (Assumption) -> Void
  var deleteAction: (String) -> Void

  @State var value: Double
  @State var isEditing: Bool = false

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

  func asString(_ value: Double) -> String {
    let suffix = assumption.type == .percent ? "%" : ""
    return "\(Int(value))\(suffix)"
  }

  var body: some View {
    HStack {
      Text(assumption.name)

      Spacer()
      Text(asString(value))

      HStack {
        Text("[ \(assumption.min)")
        Slider(
          value: $value,
          in: Double(assumption.min)...Double(assumption.max),
          onEditingChanged: { stillDragging in
            if !stillDragging {
              updateAction(Assumption(assumption, Int(value)))
            }
          }
        )
        .onChange(of: value) {
          /* triggers real-time updates */
        }
        Text("\(assumption.max) ]")
      }
      .frame(maxWidth: 400)

      Button(action: {
        deleteAction(assumption.name)
      }) {
        Image(systemName: "trash")
          .accessibilityLabel(Text("Delete"))
      }
      .buttonStyle(.plain)

      Button(action: {
        isEditing = true
      }) {
        Image(systemName: "square.and.pencil")
          .accessibilityLabel(Text("Edit"))
      }
      .buttonStyle(.plain)
    }
    .padding([.leading, .trailing])
    .sheet(isPresented: $isEditing) {
      EditAssumptionView(assumption: assumption, buttonName: "Update") { assumption in
        updateAction(assumption)
      }
    }
  }
}

#Preview {
  let assumption = Assumption(type: AssumptionType.percent, name: "ROI", min: 0, max: 20, current: 5)
  return AssumptionView(assumption: assumption)
}
