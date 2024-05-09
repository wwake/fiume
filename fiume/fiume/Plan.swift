class Plan {
	var streams = [Stream]()
	var netWorth = Dollar(0)

	func add(_ stream: Stream) {
		streams.append(stream)
	}

	func project(_ months: Int) {
		(0..<months).forEach { _ in
			streams.forEach { stream in
				netWorth += stream.monthlyAmount
			}
		}
	}
}
