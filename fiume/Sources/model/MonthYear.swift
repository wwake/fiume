import Foundation

private let months = [
  "January", "February", "March",
  "April", "May", "June",
  "July", "August", "September",
  "October", "November", "December",
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
    "\(months[self.rawValue])"
  }
}

extension Int {
  var jan: MonthYear { MonthYear(.jan, self)}
  var feb: MonthYear { MonthYear(.feb, self)}
  var mar: MonthYear { MonthYear(.mar, self)}
  var apr: MonthYear { MonthYear(.apr, self)}
  var may: MonthYear { MonthYear(.may, self)}
  var jun: MonthYear { MonthYear(.jun, self)}
  var jul: MonthYear { MonthYear(.jul, self)}
  var aug: MonthYear { MonthYear(.aug, self)}
  var sep: MonthYear { MonthYear(.sep, self)}
  var oct: MonthYear { MonthYear(.oct, self)}
  var nov: MonthYear { MonthYear(.nov, self)}
  var dec: MonthYear { MonthYear(.dec, self)}
}

public struct MonthYear: Equatable, Codable {
  let month: Month
  let year: Int

  init(_ month: Month, _ year: Int) {
    self.month = month
    self.year = year
  }

  init(date: Date) {
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
    "\(month), \(year)"
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

  func advanced(byYears n: Int) -> MonthYear {
    toMonthYear(self.toMonthCount() + 12 * n)
  }

  public func distance(to other: MonthYear) -> Int {
    other.toMonthCount() - self.toMonthCount()
  }

  func range(_ numberOfMonths: Int) -> ClosedRange<MonthYear> {
    self...(self.advanced(by: numberOfMonths - 1))
  }
}
