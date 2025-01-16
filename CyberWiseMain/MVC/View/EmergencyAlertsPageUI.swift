import SwiftUI

struct EmergencyAlertsPageUI: View {
    @State private var notificationsEnabled: Bool = true // Toggle for alerts
    @State private var alertDetected: Bool = true // Simulate if there is a current alert
    @State private var alertType: String = "Data Breach" // Example: "Data Breach" or "Phishing Email"
    @State private var recentAlerts: [String] = [ // Recent alerts (can be empty for no recent alerts)
        "Phishing email detected",
        "Your password was leaked",
        "Suspicious login attempt"
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(hex: "F1FFF3")
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Top Section
                    topSection

                    // Alerts Summary (if `alertDetected`)
                    if alertDetected {
                        currentAlertView
                    } else {
                        noAlertView
                    }

                    // Toggle Notifications Section
                    notificationsToggle

                    // Recent Alerts Section (only if there are alerts)
                    if !recentAlerts.isEmpty {
                        recentAlertsSection
                    }

                    Spacer()
                }
            }
        }
    }

    // MARK: - Top Section
    var topSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .fill(Color(hex: "F5B7B1"))
                .frame(height: 150)
                .offset(y: -40)

            HStack {
                NavigationLink(destination: HomeScreenUI().navigationBarBackButtonHidden(true)) {
                    // Back Button
                    Image(systemName: "arrow.left")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                }

                Spacer()

                Text("Emergency Alerts")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Spacer()

                Button(action: {
                    // Notifications action
                }) {
                    // Notification Bell Icon
                    Image(systemName: "bell")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                }
            }
        }.offset(y: -40)
    }

    // MARK: - Current Alert View
    var currentAlertView: some View {
        VStack(spacing: 10) {
            Text("Current Alerts")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)

            Text("You have 1 high-priority alert.")
                .font(.subheadline)
                .foregroundColor(.black)

            HStack {
                Image(systemName: alertType == "Data Breach" ? "exclamationmark.triangle.fill" : "envelope.fill")
                    .font(.largeTitle)
                    .foregroundColor(alertType == "Data Breach" ? .red : .orange)

                Spacer()

                VStack(alignment: .leading, spacing: 5) {
                    Text(alertType == "Data Breach" ? "Data Breach Detected" : "Phishing Email Detected")
                        .font(.headline)
                        .foregroundColor(.black)

                    Text(alertType == "Data Breach" ? "A large-scale data breach has occurred. Secure your accounts." : "A phishing email has been detected. Be cautious.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)

                Button(action: {
                    // Action for viewing more details
                    print("View Alert Details")
                }) {
                    Text("Details")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color(hex: "6D8FDF"))
                        .cornerRadius(5)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 2)
        }
        .padding(.horizontal)
    }

    // MARK: - No Alert View
    var noAlertView: some View {
        VStack(spacing: 10) {
            Text("No Current Alerts")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)

            Text("All systems secure. You’re safe for now.")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 2)
        .padding(.horizontal)
    }

    // MARK: - Notifications Toggle
    var notificationsToggle: some View {
        VStack(spacing: 10) {
            Toggle(isOn: $notificationsEnabled) {
                Text("Enable Emergency Alerts")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .toggleStyle(SwitchToggleStyle(tint: Color(hex: "F5B7B1")))
            .padding()
            .background(Color(hex: "F5B7B1").opacity(0.3))
            .cornerRadius(15)
        }
        .padding(.horizontal)
    }

    // MARK: - Recent Alerts Section
    var recentAlertsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recent Alerts")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(recentAlerts.indices, id: \.self) { index in
                        HStack {
                            Image(systemName: "circle.fill")
                                .font(.title2)
                                .foregroundColor(.red)

                            Text(recentAlerts[index])
                                .font(.subheadline)
                                .foregroundColor(.black)

                            Spacer()

                            Text("2h ago")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 2)
                    }
                }
            }
            .frame(maxHeight: 200) // Adjust height as needed
        }
        .padding(.horizontal)
    }
}

#Preview {
    EmergencyAlertsPageUI()
}
