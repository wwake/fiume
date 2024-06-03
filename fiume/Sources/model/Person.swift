import Foundation

struct Person: Identifiable, Equatable {
  let id = UUID()
  let name: String
  let birth: MonthYear?
  let death: MonthYear?
}
