//
//  Verifacation.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/2/24.
//

import SwiftUI
import Combine

struct PhoneVerificationView: View {
    @Binding var isCompleteSignUp: Bool
    @Binding var phoneNumber: String
    @Binding var token: String
    @State private var verificationCode = ""
    @State private var showAlert = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            Text("Phone Verification")
                .font(.title)
                .padding()
            
            TextField("Enter Verification Code", text: $verificationCode)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.oneTimeCode).keyboardType(.numberPad)
                .onReceive(Just(verificationCode)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.verificationCode = filtered
                    }
                    
                    // Ensure the verification code is exactly 6 digits
                    if filtered.count > 6 {
                        self.verificationCode = String(filtered.prefix(6))
                    }
                }
            
            Button(action: {
                // Implement verification logic here
                self.verifyPhoneNumber()
            }) {
                Text("Verify")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(verificationCode.count == 6 ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(verificationCode.count != 6)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(errorTitle),
                    message: Text(errorMessage),
                    dismissButton: .cancel()
                )
            }
            
            Spacer()
        }
        .padding()
    }
    
    func showAlert(title: String, message: String) {
        showAlert = true
        errorTitle = title
        errorMessage = message
    }
    
    func verifyPhoneNumber() {
        // Implement your phone verification logic here
        // You can use the values of `verificationCode` and `phoneNumber`
        // to perform the verification process, such as sending a request to a server.
        
        guard let url = URL(string: "\(Env.ssEndpointURI)verify") else {
            print("Invalid URL")
            return
        }
        
        let parameters: [String: Any] = [
            "verificationCode": verificationCode
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Error serializing JSON: \(error)")
            showAlert(title: "Error serializing JSON", message: !error.localizedDescription.isEmpty ? error.localizedDescription : "No message")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                showAlert(title: "Error", message: !error.localizedDescription.isEmpty ? error.localizedDescription : "No message")
                return
            }
            
            guard let data = data else {
                print("Data is nil")
                showAlert(title: "Data is nil/null", message: "No message")
                
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                // Handle the response from the server
                if let success = jsonResponse?["success"] as? Bool, success {
                    // Respond to successful verification (you can navigate to the next screen or perform other actions)
                    UserDefaults.standard.set(self.token, forKey: "token")
                    
                    
                    self.isCompleteSignUp = true
                } else if let error = jsonResponse?["error"] as? String {
                    // Handle specific errors
                    switch error {
                    case "phone_exists":
                        showAlert(title: "Phone Number Already Exists", message: "A user with this phone number already exists.")
                    case "wrong_code":
                        showAlert(title: "Wrong code", message: "The code you entered doesn't match the expected one")
                    default:
                        showAlert(title: "Server Error", message: "Unexpected server response: \(error)")
                    }
                } else {
                    // Handle unsuccessful verification
                    if let error = jsonResponse?["error"] as? String {
                        print("Server error: \(error)")
                        showAlert(title: "Server error", message: !error.isEmpty ? error : "No message")
                        
                    } else {
                        print("Unexpected server response")
                        showAlert(title: "Error", message: "Unexpected output from server")
                        
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
                
                showAlert(title: "Error decoding JSON", message: !error.localizedDescription.isEmpty ? error.localizedDescription : "No message")
            }
        }.resume()
    }
}
