import SwiftUI

struct AgeSelector: View {
  @Environment(People.self)
  private var people

  @Binding var dateSpec: DateSpecifier

  @State var person: Person?
  @State var age = 50

  func updateValues() {
    if person != nil {
      dateSpec = .age(person!, age)
    }
  }

  func personAge() -> some View {
    GeometryReader { geometry in
      HStack {
        Picker("People", selection: $person) {
          ForEach(people.people) {
            Text($0.name)
              .tag($0.id)
          }
        }
        .halfSize(geometry.size)
        .onChange(of: person) {
          updateValues()
        }

        Picker("Age", selection: $age) {
          ForEach(1...100, id: \.self) {
            Text(verbatim: "\($0)")
              .tag($0)
          }
        }
        .halfSize(geometry.size)
        .onChange(of: age) {
          updateValues()
        }
      }
    }
  }

  var body: some View {
    if people.count == 0 {
      ContentUnavailableView(
          "No People",
          systemImage: "exclamationmark.circle",
          description: Text("Add people before using age to specify dates.")
      )
    } else {
      personAge()
    }
  }
}

#Preview {
  @State var dateSpec1 = DateSpecifier.unchanged
  @State var dateSpec2 = DateSpecifier.unchanged
  
  let people1 = People()
  people1.add(Person(name: "Bob", birth: 2000.jan, death: nil))
  people1.add(Person(name: "Anny", birth: 1995.dec, death: nil))
  let people2 = People()

  return VStack {
    AgeSelector(dateSpec: $dateSpec1)
      .environment(people1)
    Divider()
    AgeSelector(dateSpec: $dateSpec2)
      .environment(people2)
  }
}
