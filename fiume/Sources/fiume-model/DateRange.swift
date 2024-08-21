public struct DateRange: Equatable, Codable {
  public var first: DateSpecifier
  public var last: DateSpecifier

  public static var always = DateRange(.unchanged, .unchanged)

  public init(_ first: DateSpecifier, _ last: DateSpecifier) {
    self.first = first
    self.last = last
  }

  public func includes(_ month: MonthYear) -> Bool {
    first.leq(month) && last.geq(month)
  }

  public var description: String {
    if self == DateRange.always {
      return ""
    }
    return "\(first.description)-\(last.description)"
  }
}
