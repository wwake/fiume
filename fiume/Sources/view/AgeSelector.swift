import fiume_model
import SwiftData
import SwiftUI

struct AgeSelector: View {
  static let unknownPersonId = UUID()

  @Environment(People.self)
  var people: People

  @Binding var dateSpec: DateSpecifier

  @State var selectedId: UUID
  @State var selectedAge: Int

  init(dateSpec: Binding<DateSpecifier>) {
    self._dateSpec = dateSpec

    selectedId = dateSpec.wrappedValue.ageId ?? Self.unknownPersonId
    selectedAge = dateSpec.wrappedValue.ageYears ?? 60
  }

  func updateValues() {
    dateSpec = DateSpecifier.age(selectedId, selectedAge)
  }

  func personAge() -> some View {
    GeometryReader { geometry in
      HStack {
        Picker("People", selection: $selectedId) {
          ForEach(people.sorted()) {
            Text($0.name)
              .tag($0.id)
          }
        }
        .halfSize(geometry.size)
        .onChange(of: selectedId, initial: true) {
          updateValues()
        }

        Picker("Age", selection: $selectedAge) {
          ForEach(1...100, id: \.self) {
            Text(verbatim: "\($0)")
              .tag($0)
          }
        }
        .halfSize(geometry.size)
        .onChange(of: selectedAge, initial: true) {
          updateValues()
        }
      }
    }
    .onAppear {
      if selectedId == Self.unknownPersonId {
        let person = people.people.sorted().first!
        selectedId = person.id
      }
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

#Preview {
  @State var dateSpec1 = DateSpecifier.unchanged
  @State var dateSpec2 = DateSpecifier.unchanged

  @State var people1 = People()
  people1.add(Person(name: "Bob", birth: 2000.jan))
  people1.add(Person(name: "Anny", birth: 1995.dec))
  people1.add(Person(name: "gil", birth: 1990.mar))

  let people2 = People()

  return VStack {
    AgeSelector(dateSpec: $dateSpec1)
      .environment(people1)
    Divider()
    AgeSelector(dateSpec: $dateSpec2)
      .environment(people2)
  }
}
