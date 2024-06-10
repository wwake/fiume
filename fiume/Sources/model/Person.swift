import Foundation

struct Person: Identifiable, Equatable {
  let id = UUID()
  let name: String
  let birth: MonthYear
  let death: MonthYear?
}

extension Person: Hashable {
  static func == (lhs: Person, rhs: Person) -> Bool {
    lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
      hasher.combine(id)
  }
}
