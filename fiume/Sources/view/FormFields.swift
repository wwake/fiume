import SwiftUI

struct NumberField: View {
	var label: String
	@Binding var value: Int

	var body: some View {
		LabeledContent {
			TextField(label, value: $value, format: .number)
				.keyboardType(.decimalPad)
		} label: {
			Text(label)
		}
	}
}

struct PercentField: View {
  var label: String
  @Binding var value: Double

  var body: some View {
    LabeledContent {
      TextField(label, value: $value, format: .percent)
        .keyboardType(.decimalPad)
    } label: {
      Text(label)
    }
  }
}

struct RequiredTextField: View {
  var name: String
  @Binding var field: String

  var body: some View {
    VStack {
      LabeledContent {
        TextField(name, text: $field)
      } label: {
        Text(name)
      }
      ErrorView(field.isEmpty, "\(name) is required.")
    }
  }
}
