struct NetWorthData {
	let month: Int
	let amount: Dollar
}

class Plan {
	var streams = [Stream]()

	func add(_ stream: Stream) {
		streams.append(stream)
	}

	func project(_ months: Int) -> [NetWorthData] {
		var result = [NetWorthData]()
		var runningTotal = Dollar(0)
		(1...months).forEach { month in
			let net = streams.reduce(Dollar(0)) { result, item in
				result + item.monthlyAmount
			}
			runningTotal += net
			result.append(NetWorthData(month: month, amount: runningTotal))
		}
		return result
	}
}
