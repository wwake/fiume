import fiume_model
import SwiftUI

struct AssumptionView: View {
  var assumption: PercentAssumption
  var updateAction: (PercentAssumption) -> Void
  var deleteAction: (String) -> Void

  @State var value: Double
  @State var isEditing: Bool = false

  init(
    assumption: PercentAssumption,
    updateAction: @escaping (PercentAssumption) -> Void = { _ in },
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

      Spacer()
      Text("\(Int(value))%")

      HStack {
        Text("[ \(assumption.min)")
        Slider(
          value: $value,
          in: Double(assumption.min)...Double(assumption.max),
          onEditingChanged: { stillDragging in
            if !stillDragging {
              updateAction(PercentAssumption(assumption, Int(value)))
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
  let assumption = PercentAssumption(type: AssumptionType.percent, name: "ROI", min: 0, max: 20, current: 5)
  return AssumptionView(assumption: assumption)
}
