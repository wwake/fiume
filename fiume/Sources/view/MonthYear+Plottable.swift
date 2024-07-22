import Charts
import Foundation

extension MonthYear: Plottable {
  public var primitivePlottable: Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM, yyyy"
    return dateFormatter.date(from: self.description)!
  }

  public init?(primitivePlottable: Date) {
    self.init(date: primitivePlottable)
  }
}
