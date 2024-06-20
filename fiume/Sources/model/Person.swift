import Foundation
import SwiftUI

struct Person: Identifiable, Equatable, Codable {
  var id = UUID()
  let name: String
  let birth: MonthYear
  let death: MonthYear?

  init(name: String, birth: MonthYear, death: MonthYear?) {
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
