import SwiftUI

struct CreatePersonView: View {
  @Environment(\.dismiss)
  var dismiss

  @Bindable var people: People

  @State private var name = ""
  @State private var born: MonthYear?
  @State private var died: MonthYear?

  func validDates() -> Bool {
    born == nil
      || died == nil
      || born! <= died!
  }

  func valid() -> Bool {
    !name.isEmpty
    && validDates()
  }

  var body: some View {
    Form {
      RequiredTextField(name: "Name", field: $name)

      LabeledContent {
        MonthYearView(monthYear: $born)
      } label: {
        Text("Born")
          .padding(.trailing, 50)
      }

      LabeledContent {
        MonthYearView(monthYear: $died)
      } label: {
        Text("Died")
          .padding(.trailing, 50)
      }

      Text("Date born must precede date died.")
        .foregroundStyle(Color.red)
        .opacity(validDates() ? 0.0 : 1.0)

      HStack {
        Spacer()
        Button("Create") {
          let person = Person(name: name, birth: born, death: died)
          people.people.append(person)
          dismiss()
        }
        .disabled(!valid())
        Spacer()
      }
    }
  }
}

#Preview {
  let people = People()
  return CreatePersonView(people: people)
}
