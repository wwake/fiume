import SwiftUI

struct CreatePersonView: View {
  @Environment(\.dismiss)
  var dismiss

  @Environment(People.self)
  var people: People

  @State private var name = ""
  @State private var born: MonthYear = 2024.jan

  func valid() -> Bool {
    !name.isEmpty
  }

  var body: some View {
    Form {
      Text("Add Person")
        .font(.title)
        .padding([.bottom], 4)

      RequiredTextField(name: "Name", field: $name)

      LabeledContent {
        MonthYearView(monthYear: $born)
          .frame(height: 200)
      } label: {
        Text("Born")
          .padding(.trailing, 50)
      }

      HStack {
        Spacer()
        Button("Create") {
          let person = Person(name: name, birth: born, death: nil)
          people.add(person)
          dismiss()
        }
        .disabled(!valid())
        Spacer()
      }
    }
  }
}

#Preview {
  @State var people = People()

  return CreatePersonView()
    .environment(people)
}
