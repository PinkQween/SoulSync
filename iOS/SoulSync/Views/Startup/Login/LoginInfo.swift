//
//  LoginInfo.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/2/24.
//

import SwiftUI
import iPhoneNumberField
import PhoneNumberKit
import Combine

struct LoginInfoView: View {
    @Binding var isLoginSuccessful: Bool
    @State var fullPhoneNumber = ""
    @State var displayPhoneNumber = ""
    
    @State private var isPhoneValid = false
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var textBoxPadding: Double = 4
    @State private var selectedCountryCodeIndex = 0
    let phoneNumberKit = PhoneNumberKit()
    
    var isPasswordValid: Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*[^a-zA-Z\\d]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    var isLoginButtonEnabled: Bool {
        return isPasswordValid && isPhoneValid
    }
    
    var countryCodes: [String] {
        let uniqueCountryCodes = Set(phoneNumberKit.allCountries().compactMap { countryCode in
            return "+\(phoneNumberKit.countryCode(for: countryCode) ?? 0)"
        })
        
        return uniqueCountryCodes.sorted { code1, code2 in
            if let intCode1 = Int(code1), let intCode2 = Int(code2) {
                return intCode1 < intCode2
            }
            return false
        }
    }
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.title)
                .padding()
            
            HStack {
                Picker("Country Code", selection: $selectedCountryCodeIndex) {
                    ForEach(Array(countryCodes.enumerated()), id: \.offset) { index, code in
                        Text(code)
                    }
                }
                .pickerStyle(.menu)
                
                
                iPhoneNumberField("Phone Number", text: $displayPhoneNumber)
                    .padding(textBoxPadding)
                    .textContentType(.telephoneNumber)
                    .keyboardType(.phonePad)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onReceive(Just(displayPhoneNumber)) { newText in
                                    let filtered = newText.filter { $0.isNumber }
                                    if filtered != newText {
                                        self.displayPhoneNumber = filtered
                                    }
                                    
                                    // Enforce a maximum length for the phone number, adjust as needed
                                    let maxLength = 10 // Adjust this value based on your requirements
                                    if self.displayPhoneNumber.count > maxLength {
                                        self.displayPhoneNumber = String(self.displayPhoneNumber.prefix(maxLength))
                                    }
                                }
            }
            .onChange(of: displayPhoneNumber) { oldValue, newValue in
                fullPhoneNumber = formatPhone(phoneNumber: countryCodes[selectedCountryCodeIndex] + newValue)
                validatePhoneNumber()
            }
            .onChange(of: selectedCountryCodeIndex) { oldValue, newValue in
                validatePhoneNumber()
            }
            .border(Color(UIColor.quaternaryLabel))
            .cornerRadius(6)
            
            SecureField("Password", text: $password)
                .padding(textBoxPadding)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.password)
            
            Button(action: {
                login()
            }) {
                Text("Log In")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isLoginButtonEnabled ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .disabled(!isLoginButtonEnabled)
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
    
    func login() {
        // Implement your phone verification logic here
        // You can use the values of `verificationCode` and `phoneNumber`
        // to perform the verification process, such as sending a request to a server.
        
        guard let url = URL(string: "\(Env.ssEndpointURI)login") else {
            print("Invalid URL")
            return
        }
        
        let parameters: [String: Any] = [
            "phoneNumber": fullPhoneNumber,
            "password": password,
            "deviceID": UserDefaults.standard.string(forKey: "deviceToken") ?? ""
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
                    UserDefaults.standard.set((jsonResponse?["token"] as? String)!, forKey: "token")
                    
                    
                    self.isLoginSuccessful = true
                } else if let error = jsonResponse?["error"] as? String {
                    // Handle specific errors
                    switch error {
                    case "user_not_found":
                        showAlert(title: "No user was found", message: "With the inputted phone number no user was found.")
                    case "wrong_password":
                        showAlert(title: "Wrong password", message: "The password doesn't align with the password of the phone number inputted")
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
    
    func validatePhoneNumber() {
        isPhoneValid = phoneNumberKit.isValidPhoneNumber(fullPhoneNumber)
    }
    
    func formatPhoneForDisplay(phoneNumber: String) -> String {
        do {
            let parsedPhoneNumber = try phoneNumberKit.parse(phoneNumber)
            let formattedNumber = phoneNumberKit.format(parsedPhoneNumber, toType: .national)
            return formattedNumber
            //            return phoneNumber
        } catch {
            print("Error formatting phone number for display: \(error)")
            return phoneNumber
        }
    }
    
    func formatPhone(phoneNumber: String) -> String {
        do {
            let phoneNumber = try phoneNumberKit.parse(phoneNumber)
            
            print(phoneNumber)
            
            let formattedNumber = phoneNumberKit.format(phoneNumber, toType: .e164)
            
            print(phoneNumber)
            print("formatted: " + formattedNumber)
            
            return formattedNumber
        } catch {
            print("error")
            return phoneNumber
        }
    }
    
    func showAlert(title: String, message: String) {
        showAlert = true
        errorTitle = title
        errorMessage = message
    }
}

#Preview {
    LoginInfoView(isLoginSuccessful: .constant(false))
}
