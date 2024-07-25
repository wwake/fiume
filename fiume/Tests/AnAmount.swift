@testable import fiume
import fiume_model
import Testing

struct AnAmount {
  @Test
  func knows_simple_amount() {
    let sut = Amount(100)
    #expect(sut.value() == 100)
  }
}
