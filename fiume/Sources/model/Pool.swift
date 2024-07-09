import Foundation

struct Pool: Identifiable, Codable {
  var id = UUID()
  var name: String
  var amount: Money
  var first: DateSpecifier
  var last: DateSpecifier
}
