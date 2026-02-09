import Foundation
import Combine

class TimeService: ObservableObject {
    @Published private(set) var currentTime = Date()

    private var timer: AnyCancellable?

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss"
        return f
    }()

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    // UTC formatted strings
    var utcTimeFormatted: String {
        let f = Self.timeFormatter
        f.timeZone = TimeZone(identifier: "UTC")
        return f.string(from: currentTime)
    }

    var utcDateFormatted: String {
        let f = Self.dateFormatter
        f.timeZone = TimeZone(identifier: "UTC")
        return f.string(from: currentTime)
    }

    // Local formatted strings
    var localTimeFormatted: String {
        let f = Self.timeFormatter
        f.timeZone = .current
        return f.string(from: currentTime)
    }

    var localDateFormatted: String {
        let f = Self.dateFormatter
        f.timeZone = .current
        return f.string(from: currentTime)
    }

    // Timezone offset string (e.g. "+0500" or "-0300")
    var timezoneOffset: String {
        let seconds = TimeZone.current.secondsFromGMT(for: currentTime)
        let hours = seconds / 3600
        let minutes = abs(seconds / 60 % 60)
        let sign = hours >= 0 ? "+" : ""
        return String(format: "%@%02d%02d", sign, hours, minutes)
    }

    init() {
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] date in
                self?.currentTime = date
            }
    }
}
