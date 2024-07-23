import Charts
import fiume_model
import Foundation

extension MonthYear: Plottable {
  public var primitivePlottable: Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM, yyyy"
    return dateFormatter.date(from: self.description)!
  }

  public init?(primitivePlottable: Date) {
    self.init(date: primitivePlottable)
  }
}
