public struct DateRange {
  public var first: DateSpecifier
  public var last: DateSpecifier

  public static var null = DateRange(.unchanged, .unchanged)

  public init(_ first: DateSpecifier, _ last: DateSpecifier) {
    self.first = first
    self.last = last
  }
}
