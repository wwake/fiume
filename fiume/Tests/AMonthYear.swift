@testable import fiume
import fiume_model
import Foundation
import Testing

struct AMonthYear {
  @Test
  func can_be_written_from_int() {
    #expect(2024.oct == MonthYear(.oct, 2024))
  }

  @Test
  func compares_year_if_one_is_less() {
    let a = 2000.apr
    let b = 1999.jun
    #expect (a > b)
    #expect (b < a)
  }

  @Test
  func compares_month_if_months_differ_and_years_are_equal() {
    let a = 2020.apr
    let b = 2020.jun
    #expect (a < b)
    #expect (b > a)
  }

  @Test
  func is_same_only_if_month_and_year_are_the_same() {
    let a = 2020.apr
    let b = 2020.jun
    #expect((a) == a)
    #expect(a != b)
  }

  @Test
  func initializes_from_date() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM"
    dateFormatter.locale = Locale(identifier: "en_US")

    let date = dateFormatter.date(from: "2016-10")
    let sut = MonthYear(date: date!)
    #expect(sut == 2016.oct)
    #expect(sut.description == "Oct. 2016")
  }

  @Test
  func advances_by_months() {
    #expect(2022.dec.advanced(by: 1) == 2023.jan)
    #expect(2000.jan.advanced(by: -1) == 1999.dec)
  }

  @Test
  func advances_by_years() {
    #expect(1960.jan.advanced(byYears: 10) == 1970.jan)
    #expect(1970.dec.advanced(byYears: -10) == 1960.dec)
  }

  @Test
  func distance_in_months() {
    #expect(2000.apr.distance(to: 2000.apr) == 0)
    #expect(2000.apr.distance(to: 2002.mar) == 11 + 12)
    #expect(2002.apr.distance(to: 2001.dec) == -4)
  }
}
