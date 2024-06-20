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
    @Binding var email: String
    @Binding var token: String
    @State private var verificationCode = ""
    @State private var showAlert = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            Text("Email Verification")
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
                self.verify()
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
    
    func verify() {
        // Implement your phone verification logic here
        // You can use the values of `verificationCode` and `phoneNumber`
        // to perform the verification process, such as sending a request to a server.
        
        dump(token)
        
        let parameters: [String: Any] = [
            "verificationCode": verificationCode
        ]
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(token)",
        ]
        
//        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")", forHTTPHeaderField: "Authorization")
        
        NetworkManager.shared.put(to: URL(string: "\(apiURL)/verify")!, body: parameters, headers: headers) { data, response, error in
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
                
                dump(jsonResponse)
                
                // Handle the response from the server
                if let success = jsonResponse?["success"] as? Bool, success {
                    // Respond to successful verification (you can navigate to the next screen or perform other actions)
//                    UserDefaults.standard.set(self.token, forKey: "token")
                    let _ = KeychainManager.save(key: "token", value: self.token)
                    
                    
                    self.isCompleteSignUp = true
                } else if let error = ServerErrors(rawValue: jsonResponse?["error"] as? String ?? "") {
                    // Handle specific errors
                    switch error {
                    case .WRONG_CODE:
                        showAlert(title: "Wrong code", message: "The code you entered doesn't match the expected one")
                    case .NO_TOKEN:
                        showAlert(title: "No token", message: "The client forgot to send the token")
                    case .INVALID_TOKEN:
                        showAlert(title: "Invalid Token", message: "The client send a invlaid token")
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
        }
    }
}
