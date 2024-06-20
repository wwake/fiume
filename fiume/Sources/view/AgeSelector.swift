import SwiftData
import SwiftUI

struct AgeSelector: View {
  @Environment(People.self)
  var people: People

  @Binding var dateSpec: DateSpecifier

  @State var person = Person(name: "Unknown", birth: 2000.jan, death: nil)
  @State var age = 60

  func updateValues() {
    dateSpec = DateSpecifier.age(person.name, person.birth, age)
  }

  func personAge() -> some View {
    GeometryReader { geometry in
      HStack {
        Picker("People", selection: $person) {
          ForEach(people.people, id: \.id) {
            Text($0.name)
              .tag($0)
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
    .onAppear {
      person = people.people.first!
    }
  }

  var body: some View {
    Group {
      if people.count == 0 {
        ContentUnavailableView(
          "No People",
          systemImage: "exclamationmark.triangle",
          description: Text("Add people before using age to specify dates.")
        )
      } else {
        personAge()
      }
    }
  }
}

//#Preview {
//  @State var dateSpec1 = DateSpecifier.unchanged
//  @State var dateSpec2 = DateSpecifier.unchanged
//
//  let container1 = demoContainer(for: Person.self)
//  container1.mainContext.insert(Person(name: "Bob", birth: 2000.jan, death: nil))
//  container1.mainContext.insert(Person(name: "Anny", birth: 1995.dec, death: nil))
//  container1.mainContext.insert(Person(name: "gil", birth: 1990.mar, death: nil))
//
//  let container2 = demoContainer(for: Person.self)
//
//  return VStack {
//    AgeSelector(dateSpec: $dateSpec1)
//      .modelContainer(container1)
//    Divider()
//    AgeSelector(dateSpec: $dateSpec2)
//      .modelContainer(container2)
//  }
//}
