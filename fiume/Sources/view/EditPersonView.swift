import fiume_model
import SwiftUI

struct EditPersonView: View {
  @Environment(People.self)
  var people: People

  @Environment(\.dismiss)
  var dismiss

  var person: Person
  var buttonName: String
  var action: (Person) -> Void

  @State private var name = ""
  @State private var born: MonthYear = 2024.jan

  init(person: Person, buttonName: String, action: @escaping (Person) -> Void) {
    self.person = person
    self.buttonName = buttonName
    self.action = action

    _name = .init(wrappedValue: person.name)
    _born = .init(wrappedValue: person.birth)
  }

  func valid() -> Bool {
    !name.isEmpty && !people.containsName(name)
  }

  var body: some View {
    Form {
      Text("\(buttonName) Person")
        .font(.title)
        .padding([.bottom], 4)

      RequiredTextField(name: "Name", field: $name)
      ErrorView(
        people.containsName(name),
        "The name '\(name)' is already used."
      )

      LabeledContent {
        MonthYearView(monthYear: $born)
          .frame(height: 200)
      } label: {
        Text("Born")
          .padding(.trailing, 50)
      }

      HStack {
        Spacer()
        Button(buttonName) {
          let person = Person(person.id, name: name, birth: born)
          action(person)
          dismiss()
        }
        .disabled(!valid())
        Spacer()
      }
    }
  }
}

#Preview {
  EditPersonView(person: Person.null, buttonName: "Create") { _ in }
}
