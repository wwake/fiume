import fiume_model
import SwiftUI

struct EditAssumptionsView: View {
  @Environment(\.dismiss)
  var dismiss

  var assumption: Assumption
  var buttonName: String
  var action: (Assumption) -> Void

  @State var name: String
  @State var min: Int
  @State var max: Int
  @State var current: Int

  init(assumption: Assumption, buttonName: String, action: @escaping (Assumption) -> Void) {
    self.assumption = assumption
    self.buttonName = buttonName
    self.action = action

    _name = .init(wrappedValue: assumption.name)
    _min = .init(wrappedValue: assumption.min)
    _max = .init(wrappedValue: assumption.max)
    _current = .init(wrappedValue: assumption.current)
  }

  func valid() -> Bool {
    !name.isEmpty
  }

  var body: some View {
    Form {
      Text("\(buttonName) Assumption")
        .font(.title)
        .padding([.bottom], 4)

      RequiredTextField(name: "Name", field: $name)
      NumberField(label: "Min", value: $min)
      NumberField(label: "Max", value: $max)
      NumberField(label: "Current", value: $current)

      HStack {
        Spacer()
        Button(buttonName) {
          let assumption = Assumption(type: .percent, name: name, min: min, max: max, current: current)
          action(assumption)
          dismiss()
        }
        .disabled(!valid())
        Spacer()
      }
    }
  }
}

#Preview {
  let assumption = Assumption.null
  return EditAssumptionsView(assumption: assumption, buttonName: "Create") { _ in }
}
