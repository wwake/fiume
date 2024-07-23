@testable import fiume
import fiume_model
import Testing

struct AMoneySpecifier {
  @Test
  func knows_simple_amount() {
    let sut = MoneySpecifier.amount(100)
    #expect(sut.value() == 100)
  }
}
