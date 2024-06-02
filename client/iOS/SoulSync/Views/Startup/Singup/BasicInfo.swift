//
//  BasicInfo.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/2/24.
//

import SwiftUI
import PhoneNumberKit
import iPhoneNumberField
import Combine

struct SignUpInfoView: View {
    @Binding var isSignUpSuccessful: Bool
    @Binding var fullPhoneNumber: String
    @Binding var token: String
    @State private var phoneNumber = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var textBoxPadding: Double = 4
    @State private var selectedCountryCodeIndex = 0
    @State private var isPhoneValid = false
    @State private var showReqs = false
    @State private var showAlert = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var birthdate = Date()
    @State private var deviceToken: String?
    @State private var displayPhoneNumber = ""
    
    let dateFormatter = DateFormatter()
    let phoneNumberKit = PhoneNumberKit()
    
    var isOver13: Bool {
        return Calendar.current.dateComponents([.year], from: birthdate, to: Date()).year ?? 0 >= 13
    }
    
    var isPasswordValid: Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*[^a-zA-Z\\d]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    var isPasswordLengthValid: Bool {
        return password.count >= 8
    }
    
    var isPasswordContainsDigit: Bool {
        let digitRegex = ".*\\d.*"
        return NSPredicate(format: "SELF MATCHES %@", digitRegex).evaluate(with: password)
    }
    
    var isPasswordContainsLowercase: Bool {
        let lowercaseRegex = ".*[a-z].*"
        return NSPredicate(format: "SELF MATCHES %@", lowercaseRegex).evaluate(with: password)
    }
    
    var isPasswordContainsUppercase: Bool {
        let uppercaseRegex = ".*[A-Z].*"
        return NSPredicate(format: "SELF MATCHES %@", uppercaseRegex).evaluate(with: password)
    }
    
    var isPasswordContainsSpecialCharacter: Bool {
        let specialCharRegex = ".*[^a-zA-Z\\d].*"
        return NSPredicate(format: "SELF MATCHES %@", specialCharRegex).evaluate(with: password)
    }
    
    var isSignUpButtonEnabled: Bool {
        return !fullName.isEmpty
        && isPhoneValid
        && isPasswordValid
        && password == confirmPassword
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
    
    var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Calculate the minimum date for a person to be 13 years old
        let minDate = calendar.date(byAdding: .year, value: -113, to: currentDate) ?? currentDate
        let maxDate = calendar.date(byAdding: .year, value: -13, to: currentDate) ?? currentDate
        
        return minDate...maxDate
    }
    
    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.title)
                .padding()
            
            TextField("Full Name", text: $fullName)
                .padding(textBoxPadding)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.name)
            
            HStack {
                Text("Birthdate: ")
                
                DatePicker("Birthdate", selection: $birthdate, in: dateRange, displayedComponents: .date)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .labelsHidden()
            }
            .padding(textBoxPadding)
            
            HStack {
                Picker("Country Code", selection: $selectedCountryCodeIndex) {
                    ForEach(0..<countryCodes.count, id: \.self) {
                        Text(countryCodes[$0])
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
                .textContentType(.newPassword)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding(textBoxPadding)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.newPassword)
            
            Button(action: {
                signUp()
            }) {
                Text("Sign Up")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isSignUpButtonEnabled ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .disabled(!isSignUpButtonEnabled)
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
            
            Button(action: {
                showReqs.toggle()
            }, label: {
                Text("View Requirements")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(16)
            })
            .padding()
            .padding(.bottom, 45.0)
            .fullScreenCover(isPresented: $showReqs, content: {
                VStack {
                    Spacer()
                    
                    VStack {
                        
                        IsCompleteCheckOrX(isComplete: !fullName.isEmpty, field: "Full Name")
                        IsCompleteCheckOrX(isComplete: isOver13, field: "Over 13 years of age")
                        IsCompleteCheckOrX(isComplete: isPhoneValid, field: "Valid Phone")
                        IsCompleteCheckOrX(isComplete: isPasswordLengthValid, field: "Password is at least 8 characters")
                        IsCompleteCheckOrX(isComplete: isPasswordContainsDigit, field: "Password contains a digit")
                        IsCompleteCheckOrX(isComplete: isPasswordContainsLowercase, field: "Password contains a lowercase letter")
                        IsCompleteCheckOrX(isComplete: isPasswordContainsUppercase, field: "Password contains an uppercase letter")
                        IsCompleteCheckOrX(isComplete: isPasswordContainsSpecialCharacter, field: "Password contains a special character")
                        IsCompleteCheckOrX(isComplete: password == confirmPassword, field: "Matching Password")
                        
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        showReqs.toggle()
                    }, label: {
                        Text("Close")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    })
                }.padding().background(.black)
            })
        }.padding()
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
    
    func signUp() {
        // Implement your sign-up logic here
        // You can use the values of `fullName`, `phoneNumber`, `password`, and `confirmPassword`
        // to perform the sign-up process, such as sending a request to a server.
        
        dateFormatter.dateFormat = "dd/MM/yy"
        
        let parameters: [String: Any] = [
            "username": fullName,
            "phoneNumber": fullPhoneNumber,
            "password": password,
            "confirmPassword": confirmPassword,
            "birthdate": dateFormatter.string(from: birthdate),
            "deviceID": UserDefaults.standard.string(forKey: "deviceToken") ?? ""
        ]
        
        NetworkManager.shared.post(to: apiURL, with: parameters) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    DispatchQueue.main.async {
                        showAlert(title: "Error", message: !error.localizedDescription.isEmpty ? error.localizedDescription : "No message")
                    }
                    return
                }

                guard let data = data else {
                    print("Data is nil")
                    DispatchQueue.main.async {
                        showAlert(title: "Error data nil/null", message: "No message")
                    }
                    return
                }

                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                    // Handle the response from the server
                    if let success = jsonResponse?["success"] as? Bool, success {
                        // Navigate to the verification page
                        // Set the flag to trigger navigation
                        self.token = jsonResponse?["token"] as? String ?? ""
                        self.isSignUpSuccessful = true
                    } else if let error = jsonResponse?["error"] as? String {
                        // Handle specific errors
                        DispatchQueue.main.async {
                            switch error {
                            case "phone_exists":
                                showAlert(title: "Phone Number Already Exists", message: "A user with this phone number already exists.")
                            default:
                                showAlert(title: "Server Error", message: "Unexpected server response: \(error)")
                            }
                        }
                    } else {
                        // Handle unsuccessful sign-up
                        DispatchQueue.main.async {
                            if let error = jsonResponse?["error"] as? String {
                                print("Server error: \(error)")
                                showAlert(title: "Server error", message: "There was an error with the server")
                            } else {
                                print("Unexpected server response")
                                showAlert(title: "Error", message: "Unexpected output from server")
                            }
                        }
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                    DispatchQueue.main.async {
                        showAlert(title: "Error decoding JSON", message: !error.localizedDescription.isEmpty ? error.localizedDescription : "No message")
                    }
                }
            }
    }
}

struct IsCompleteCheckOrX: View {
    @State var isComplete: Bool
    @State var field: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isComplete ? "checkmark.circle" : "xmark.circle")
                .resizable()
                .foregroundColor(isComplete ? Color.green : Color.gray)
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60) // Adjust the size as needed
            
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    Text(field)
                        .font(.title)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
                }
            }
            .frame(height: 60) // Match the height of the icon
            
            Spacer()
        }
        .fixedSize(horizontal: false, vertical: true) // Allow the text to expand vertically
    }
}
