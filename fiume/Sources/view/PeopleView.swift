import SwiftUI

struct PeopleView: View {
  @Bindable var family: Family
  @State var isShowingCreateView = false

  var header: some View {
    HStack {
      Image(systemName: "person.2.fill")
        .accessibilityLabel(Text("Family"))
      Text("People")
      Spacer()
      Button {
        isShowingCreateView.toggle()
      } label: {
        Image( systemName: "plus")
          .accessibilityLabel(Text("Add"))
      }
    }
    .sheet(isPresented: $isShowingCreateView) {
      CreatePersonView(family: family)
    }
  }

  var body: some View {
    List {
      Section(header: header) {
        ForEach(family.people) { person in
          HStack {
            Text(person.name)
            Text("  b. \(person.birth == nil ? "?" : "\(person.birth!)")")

            Text("  d. \(person.death == nil ? "?" : "\(person.death!)")")
          }
        }
      }
    }
  }
}

#Preview {
  let person1 = Person(name: "Bob", birth: MonthYear(month: 2, year: 1970), death: nil)
  let person2 = Person(name: "Chris", birth: MonthYear(month: 11, year: 1980), death: MonthYear(month: 3, year: 2025))
  let family = Family()
  family.add(person1)
  family.add(person2)
  return PeopleView(family: family)
}
