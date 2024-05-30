import Foundation

struct Person: Identifiable {
  let id = UUID()
  let name: String
  let birth: MonthYear?
  let death: MonthYear?
}
