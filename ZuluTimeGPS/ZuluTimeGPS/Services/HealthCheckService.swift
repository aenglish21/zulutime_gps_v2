import Foundation
import Combine

class HealthCheckService: ObservableObject {
    @Published private(set) var isHealthy = false
    @Published private(set) var isChecking = true

    init() {
        Task {
            await checkHealth()
        }
    }

    private func checkHealth() async {
        let url = URL(string: "https://gridapi.addisonserver.com/health")!
        var request = URLRequest(url: url)
        request.timeoutInterval = 5

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let status = json["status"] as? String,
                       status == "ok" {
                        isHealthy = true
                    }
                } catch {
                    isHealthy = false
                }
            } else {
                isHealthy = false
            }
        } catch {
            isHealthy = false
        }

        isChecking = false
    }
}
