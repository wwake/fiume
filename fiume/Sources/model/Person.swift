import Foundation
import SwiftUI

struct Person: Identifiable, Equatable, Codable {
  static var null: Person {
    Person(name: "", birth: 2000.jun, death: nil)
  }

  var id: UUID
  let name: String
  let birth: MonthYear
  let death: MonthYear?

  init(_ id: UUID = UUID(), name: String, birth: MonthYear, death: MonthYear?) {
    self.id = id
    self.name = name
    self.birth = birth
    self.death = death
  }
}

extension Person: Hashable {
  static func == (lhs: Person, rhs: Person) -> Bool {
    lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
      hasher.combine(id)
  }
}
