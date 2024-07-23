import Foundation

private let months = [
  "Jan", "Feb", "Mar",
  "Apr", "May", "Jun",
  "Jul", "Aug", "Sep",
  "Oct", "Nov", "Dec",
]

public enum Month: Int, Codable {
  case jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
}

extension Month: Comparable {
  public static func < (left: Month, right: Month) -> Bool {
    left.rawValue < right.rawValue
  }
}

extension Month: CustomStringConvertible {
  public var description: String {
    if self.rawValue < Month.jan.rawValue || self.rawValue > Month.dec.rawValue {
      return "??? \(self.rawValue)"
    }
    return "\(months[self.rawValue])"
  }
}

extension Int {
  public var jan: MonthYear { MonthYear(.jan, self)}
  public var feb: MonthYear { MonthYear(.feb, self)}
  public var mar: MonthYear { MonthYear(.mar, self)}
  public var apr: MonthYear { MonthYear(.apr, self)}
  public var may: MonthYear { MonthYear(.may, self)}
  public var jun: MonthYear { MonthYear(.jun, self)}
  public var jul: MonthYear { MonthYear(.jul, self)}
  public var aug: MonthYear { MonthYear(.aug, self)}
  public var sep: MonthYear { MonthYear(.sep, self)}
  public var oct: MonthYear { MonthYear(.oct, self)}
  public var nov: MonthYear { MonthYear(.nov, self)}
  public var dec: MonthYear { MonthYear(.dec, self)}
}

public struct MonthYear: Equatable, Codable {
  public let month: Month
  public let year: Int

  public init(_ month: Month, _ year: Int) {
    self.month = month
    self.year = year
  }

  public init(date: Date) {
    let calendar = Calendar.current
    self.year = calendar.component(.year, from: date)
    self.month = Month(rawValue: calendar.component(.month, from: date) - 1) ?? .jan
  }
}

extension MonthYear: Comparable {
  public static func < (left: MonthYear, right: MonthYear) -> Bool {
    if left.year == right.year {
      return left.month < right.month
    }
    return left.year < right.year
  }
}

extension MonthYear: CustomStringConvertible {
  public var description: String {
    "\(month) \(year)"
  }
}

extension MonthYear: Strideable {
  private func toMonthCount() -> Int {
    year * 12 + month.rawValue
  }

  private func toMonthYear(_ months: Int) -> MonthYear {
    MonthYear(Month(rawValue: months % 12)!, months / 12)
  }

  public func advanced(by n: Int) -> MonthYear {
    toMonthYear(self.toMonthCount() + n)
  }

  public func advanced(byYears n: Int) -> MonthYear {
    toMonthYear(self.toMonthCount() + 12 * n)
  }

  public func distance(to other: MonthYear) -> Int {
    other.toMonthCount() - self.toMonthCount()
  }

  public func range(_ numberOfMonths: Int) -> ClosedRange<MonthYear> {
    self...(self.advanced(by: numberOfMonths - 1))
  }
}
