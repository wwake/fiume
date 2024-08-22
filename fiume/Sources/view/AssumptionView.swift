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

  var body: some View {
    HStack {
      Text(assumption.name)
      Text(": \(Int(value))%")
      Spacer()
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

      Spacer()
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
