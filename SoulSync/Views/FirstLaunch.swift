//
//  FirstLaunch.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 11/27/23.
//

import SwiftUI
import Combine
import PhoneNumberKit
import AVKit
import Foundation

struct FirstLaunchView: View {
    @State private var selectedTab = 0
    @State private var isSignUp = true

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            TabView(selection: $selectedTab) {
                LoginView(selectedTab: $selectedTab, isSignUp: $isSignUp)
                    .tag(0)
                    .transition(.slide)
                SignUpView(signUp: $isSignUp)                    .tag(1)
                    .transition(.slide)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .foregroundColor(Color.white)
    }
}

struct LoginView: View {
    @Binding var selectedTab: Int
    @Binding var isSignUp: Bool

    var body: some View {
        VStack {
            Spacer()
            Spacer()

            Text("Welcome to\nSoulSync")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)

            Spacer()

            Button(action: {
                isSignUp = false
                
                withAnimation {
                    selectedTab = 1
                }
            }, label: {
                Text("Login")
                    .font(.headline)
                    .frame(width: 300.0, height: 60.0)
                    .background(Color.white)
                    .foregroundColor(Color.black)
                    .cornerRadius(23)
            })

            Button(action: {
                isSignUp = true
                
                withAnimation {
                    selectedTab = 1
                }
            }, label: {
                Text("Sign Up")
                    .font(.headline)
                    .frame(width: 300.0, height: 60.0)
                    .cornerRadius(23)
                    .overlay(
                        RoundedRectangle(cornerRadius: 23)
                            .stroke(Color.white, lineWidth: 2)
                            .padding(2)
                    )
            })
            Spacer()
            Spacer()
            Spacer()
        }
    }
}

struct SignUpView: View {
    @State private var isSignUpSuccessful = false
    @Binding var signUp: Bool
    @State private var isCompleteSignUp = false
    @State private var phone = ""
    @State private var addedDetails = false
    @State private var addedPreferences = false

    var body: some View {
        Group {
            if !signUp {
                LoginInfoView()
            } else if !isSignUpSuccessful {
                InfoView(isSignUpSuccessful: $isSignUpSuccessful, fullPhoneNumber: $phone)
            } else if !isCompleteSignUp {
                PhoneVerificationView(isCompleteSignUp: $isCompleteSignUp, phoneNumber: $phone)
            } else if !addedDetails {
                DescriptorsView(addedDetails: $addedDetails, phoneNumber: $phone)
            } else if !addedPreferences {
                PreferencesView(addedPreferences: $addedPreferences, phoneNumber: $phone)
            } else {
                WelcomeView()
            }
        }
        .transition(.slide)
    }
}

struct LoginInfoView: View {
    var body: some View {
        Text("Login")
    }
}

struct InfoView: View {
    @Binding var isSignUpSuccessful: Bool
    @Binding var fullPhoneNumber: String
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
                
                TextField("Phone Number", text: $phoneNumber)
                    .textFieldStyle(PlainTextFieldStyle())
                    .keyboardType(.phonePad)
                    .textContentType(.telephoneNumber)
            }
            .onChange(of: phoneNumber, { oldValue, newValue in
                    print("full unformatted: " + countryCodes[selectedCountryCodeIndex] + String(newValue))
                    fullPhoneNumber = formatPhone(phoneNumber: countryCodes[selectedCountryCodeIndex] + String(newValue))
                    validatePhoneNumber()
            })
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
        
        guard let url = URL(string: "\(Env.ssEndpointURI)signup") else {
            print("Invalid URL")
            return
        }
        
        
        dateFormatter.dateFormat = "YY/MM/dd"
        
        let parameters: [String: Any] = [
            "username": fullName,
            "phoneNumber": fullPhoneNumber,
            "password": password,
            "confirmPassword": confirmPassword,
            "birthdate": dateFormatter.string(from: birthdate)
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
                showAlert(title: "Error data nil/null", message: "No message")
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                // Handle the response from the server
                if let success = jsonResponse?["success"] as? Bool, success {
                    // Navigate to the verification page
                    // Set the flag to trigger navigation
                    self.isSignUpSuccessful = true
                } else if let error = jsonResponse?["error"] as? String {
                    // Handle specific errors
                    switch error {
                    case "phone_exists":
                        showAlert(title: "Phone Number Already Exists", message: "A user with this phone number already exists.")
                    default:
                        showAlert(title: "Server Error", message: "Unexpected server response: \(error)")
                    }
                } else {
                    // Handle unsuccessful sign-up
                    if let error = jsonResponse?["error"] as? String {
                        print("Server error: \(error)")
                        
                        showAlert(title: "Server error", message: "There was a error with the server")
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

struct IsCompleteCheckOrX: View {
    @State var isComplete: Bool
    @State var field: String
    
    var body: some View {
        HStack {
            Image(systemName: isComplete ? "checkmark.circle" : "xmark.circle")
                .resizable()
                .foregroundColor(isComplete ? Color.green : Color.gray)
                .aspectRatio(contentMode: .fit)
            
            Text(field)
                .font(.title)
                .fontWeight(.semibold)
                .minimumScaleFactor(0.5)
                .lineLimit(2)
                .allowsTightening(true)
                .scaledToFit()
            
            Spacer()
        }
        
    }
}

struct PhoneVerificationView: View {
    @Binding var isCompleteSignUp: Bool
    @Binding var phoneNumber: String
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
                .textContentType(/*@START_MENU_TOKEN@*/.oneTimeCode/*@END_MENU_TOKEN@*/).keyboardType(.numberPad)
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
            "phoneNumber": phoneNumber,
            "verificationCode": verificationCode
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
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
                    print("Verification Successful")
                    self.isCompleteSignUp = true
                } else if let error = jsonResponse?["error"] as? String {
                    // Handle specific errors
                    switch error {
                    case "phone_exists":
                        showAlert(title: "Phone Number Already Exists", message: "A user with this phone number already exists.")
                    case "wrong_code":
                        showAlert(title: "Wrong code", message: "The code you entered doesn't match the expected one'")
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

struct PreferencesView: View {
    @State private var preferences: Preferences.PreferencesModel?
    @State private var preferencesOptions: Preferences.PreferencesOptionsModel?
    @State private var selectedGenderOptions: [String] = []
    @State private var selectedSexOptions: [String] = []
    @State private var selectedInterestsOptions: [String] = [] // Add more state variables for other options
    @State private var selectedSexualityOptions: [String] = []
    @State private var selectedRelationshipStatusOptions: [String] = []
    @State private var selectedAgeRangeOptions: [String] = []
    @Binding var addedPreferences: Bool
    @State private var showAlert = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @Binding var phoneNumber: String
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Select your preferences")
                    .font(.title)
                    .fontWeight(.medium)
                
                HStack {
                    Text("Gender:")
                        .padding([.top, .leading, .trailing], 6.0)

                    Spacer()
                }
                    
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(preferencesOptions?.genderOptions.options ?? [], id: \.self) { option in
                            PreferButton(option: option, selectedOptions: $selectedGenderOptions, multiple: preferencesOptions?.genderOptions.multiple)
                        }
                    }
                }
                
                HStack {
                    Text("Sex:")
                        .padding([.top, .leading, .trailing], 6.0)

                    Spacer()
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(preferencesOptions?.sexOptions.options ?? [], id: \.self) { option in
                            PreferButton(option: option, selectedOptions: $selectedSexOptions, multiple: preferencesOptions?.sexOptions.multiple)
                        }
                    }
                }
                
            HStack {
                Text("Interests:")
                    .padding([.top, .leading, .trailing], 6.0)

                Spacer()
            }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(preferencesOptions?.interestsOptions.options ?? [], id: \.self) { option in
                            ForEach(option.subInterests ?? [], id: \.self) { subInterest in
                                PreferButton(option: subInterest.option, selectedOptions: $selectedInterestsOptions, multiple: preferencesOptions?.interestsOptions.multiple)
                            }
                        }
                    }
                }
                
            HStack {
                Text("Sexuality:")
                    .padding([.top, .leading, .trailing], 6.0)

                Spacer()
            }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(preferencesOptions?.sexualityOptions.options ?? [], id: \.self) { option in
                            PreferButton(option: option, selectedOptions: $selectedSexualityOptions, multiple: preferencesOptions?.sexualityOptions.multiple)
                        }
                    }
                }
                
                
            
            HStack {
                Text("Relationship Status:")
                    .padding([.top, .leading, .trailing], 6.0)

                Spacer()
            }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(preferencesOptions?.relationshipStatusOptions.options ?? [], id: \.self) { option in
                            PreferButton(option: option, selectedOptions: $selectedRelationshipStatusOptions, multiple: preferencesOptions?.relationshipStatusOptions.multiple)
                        }
                    }
                }
                
                HStack {
                    Text("Age Range:")
                        .padding([.top, .leading, .trailing], 6.0)

                    Spacer()
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(preferencesOptions?.ageRange.options ?? [], id: \.self) { option in
                            PreferButton(option: option, selectedOptions: $selectedAgeRangeOptions, multiple: preferencesOptions?.ageRange.multiple)
                        }
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                addPrefs()
            }, label: {
                Text("Complete")
                    .font(.headline)
                    .frame(width: 300.0, height: 60.0)
                    .cornerRadius(23)
                    .overlay(
                        RoundedRectangle(cornerRadius: 23)
                            .stroke(Color.white, lineWidth: 2)
                            .padding(2)
                    )
            })
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
        .padding()
        .onAppear {
            Preferences.PreferencesOptionsModel.loadPreferences { loadedPreferences in
                preferencesOptions = loadedPreferences
                
                dump(loadedPreferences)
            }
        }.alert(isPresented: $showAlert) {
            Alert(
                title: Text(errorTitle),
                message: Text(errorMessage),
                dismissButton: .cancel()
            )
        }
    }
    
    func showAlert(title: String, message: String) {
        showAlert = true
        errorTitle = title
        errorMessage = message
    }
    
    private func addPrefs() -> Void {
        // Implement your sign-up logic here
        // You can use the values of `fullName`, `phoneNumber`, `password`, and `confirmPassword`
        // to perform the sign-up process, such as sending a request to a server.
        
        guard let url = URL(string: "\(Env.ssEndpointURI)prefs") else {
            print("Invalid URL")
            return
        }
        
        let parameters: [String: Any] = [
            "phoneNumber": phoneNumber,
            "gender": selectedGenderOptions,
            "sex": selectedSexOptions,
            "intrests": selectedInterestsOptions,
            "sexuality": selectedSexualityOptions,
            "relationshipStatus": selectedRelationshipStatusOptions,
            "ageRange": selectedAgeRangeOptions
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
                showAlert(title: "Error data nil/null", message: "No message")
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                // Handle the response from the server
                if let success = jsonResponse?["success"] as? Bool, success {
                    // Navigate to the verification page
                    // Set the flag to trigger navigation
                    self.addedPreferences = true
                } else if let error = jsonResponse?["error"] as? String {
                    // Handle specific errors
                    switch error {
                    case "phone_exists":
                        showAlert(title: "Phone Number Already Exists", message: "A user with this phone number already exists.")
                    default:
                        showAlert(title: "Server Error", message: "Unexpected server response: \(error)")
                    }
                } else {
                    // Handle unsuccessful sign-up
                    if let error = jsonResponse?["error"] as? String {
                        print("Server error: \(error)")
                        
                        showAlert(title: "Server error", message: "There was a error with the server")
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

struct DescriptorsView: View {
    @State private var preferencesOptions: Preferences.PreferencesOptionsModel?
    @State private var selectedGenderOptions: [String] = []
    @State private var selectedSexOptions: [String] = []
    @State private var selectedInterestsOptions: [String] = [] // Add more state variables for other options
    @State private var selectedSexualityOptions: [String] = []
    @State private var selectedRelationshipStatusOptions: [String] = []
    @Binding var addedDetails: Bool
    @State private var showAlert = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @Binding var phoneNumber: String
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Select who you are")
                    .font(.title)
                    .fontWeight(.medium)
                
                HStack {
                    Text("Gender:")
                        .padding([.top, .leading, .trailing], 6.0)

                    Spacer()
                }
                    
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(preferencesOptions?.genderOptions.options ?? [], id: \.self) { option in
                            PreferButton(option: option, selectedOptions: $selectedGenderOptions, multiple: preferencesOptions?.genderOptions.multiple)
                        }
                    }
                }
                
                HStack {
                    Text("Sex:")
                        .padding([.top, .leading, .trailing], 6.0)

                    Spacer()
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(preferencesOptions?.sexOptions.options ?? [], id: \.self) { option in
                            PreferButton(option: option, selectedOptions: $selectedSexOptions, multiple: preferencesOptions?.sexOptions.multiple)
                        }
                    }
                }
                
            HStack {
                Text("Interests:")
                    .padding([.top, .leading, .trailing], 6.0)

                Spacer()
            }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(preferencesOptions?.interestsOptions.options ?? [], id: \.self) { option in
                            ForEach(option.subInterests ?? [], id: \.self) { subInterest in
                                PreferButton(option: subInterest.option, selectedOptions: $selectedInterestsOptions, multiple: preferencesOptions?.interestsOptions.multiple)
                            }
                        }
                    }
                }
                
            HStack {
                Text("Sexuality:")
                    .padding([.top, .leading, .trailing], 6.0)

                Spacer()
            }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(preferencesOptions?.sexualityOptions.options ?? [], id: \.self) { option in
                            PreferButton(option: option, selectedOptions: $selectedSexualityOptions, multiple: preferencesOptions?.sexualityOptions.multiple)
                        }
                    }
                }
                
                
            
            HStack {
                Text("Relationship Status:")
                    .padding([.top, .leading, .trailing], 6.0)

                Spacer()
            }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(preferencesOptions?.relationshipStatusOptions.options ?? [], id: \.self) { option in
                            PreferButton(option: option, selectedOptions: $selectedRelationshipStatusOptions, multiple: preferencesOptions?.relationshipStatusOptions.multiple)
                        }
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                addDetails()
            }, label: {
                Text("Next")
                    .font(.headline)
                    .frame(width: 300.0, height: 60.0)
                    .cornerRadius(23)
                    .overlay(
                        RoundedRectangle(cornerRadius: 23)
                            .stroke(Color.white, lineWidth: 2)
                            .padding(2)
                    )
            })
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
        .padding()
        .onAppear {
            Preferences.PreferencesOptionsModel.loadPreferences { loadedPreferences in
                preferencesOptions = loadedPreferences
                
                dump(loadedPreferences)
            }
        }.alert(isPresented: $showAlert) {
            Alert(
                title: Text(errorTitle),
                message: Text(errorMessage),
                dismissButton: .cancel()
            )
        }
    }
    
    func showAlert(title: String, message: String) {
        showAlert = true
        errorTitle = title
        errorMessage = message
    }
    
    private func addDetails() -> Void {
        // Implement your sign-up logic here
        // You can use the values of `fullName`, `phoneNumber`, `password`, and `confirmPassword`
        // to perform the sign-up process, such as sending a request to a server.
        
        guard let url = URL(string: "\(Env.ssEndpointURI)details") else {
            print("Invalid URL")
            return
        }
        
        let parameters: [String: Any] = [
            "phoneNumber": phoneNumber,
            "gender": selectedGenderOptions,
            "sex": selectedSexOptions,
            "intrests": selectedInterestsOptions,
            "sexuality": selectedSexualityOptions,
            "relationshipStatus": selectedRelationshipStatusOptions
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
                showAlert(title: "Error data nil/null", message: "No message")
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                // Handle the response from the server
                if let success = jsonResponse?["success"] as? Bool, success {
                    // Navigate to the verification page
                    // Set the flag to trigger navigation
                    self.addedDetails = true
                } else if let error = jsonResponse?["error"] as? String {
                    // Handle specific errors
                    switch error {
                    case "phone_exists":
                        showAlert(title: "Phone Number Already Exists", message: "A user with this phone number already exists.")
                    default:
                        showAlert(title: "Server Error", message: "Unexpected server response: \(error)")
                    }
                } else {
                    // Handle unsuccessful sign-up
                    if let error = jsonResponse?["error"] as? String {
                        print("Server error: \(error)")
                        
                        showAlert(title: "Server error", message: "There was a error with the server")
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

struct PreferButton: View {
    @State var option: String
    @Binding var selectedOptions: [String]
    @State var multiple: Bool?
    
    var isSelected: Bool {
        return selectedOptions.contains(option)
    }
    
    var body: some View {
        Text(option)
            .padding(8)
            .padding(.horizontal, 11.0)
            .background(selectedOptions.contains(option) ? .blue : .clear)
            .foregroundColor(.white)
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white, lineWidth: 2)
            )
            .padding(2)
            .onTapGesture {
                withAnimation(.smooth(duration: 0.475)) {
                    if multiple == true {
                        // Toggle selection for multiple mode
                        if isSelected {
                            selectedOptions.removeAll { $0 == option }
                        } else {
                            selectedOptions.append(option)
                        }
                    } else {
                        // Single selection mode
                        selectedOptions = [option]
                    }
                }
            }
    }
}

struct WelcomeView: View {
    var body: some View {
        Text("Welcome")
    }
}

struct ChatView: View {
    var body: some View {
        VStack {
            VStack {
                Spacer()
                
                AsyncImage(url: URL(string: "https://hws.dev/paul.jpg")
                ) { image in
                    image.image?
                        .resizable()
                        .scaledToFill()
                }.frame(width: 80.0, height: 80.0).aspectRatio(contentMode: .fill).cornerRadius(50)
                
                Text("+1 (970) 691-7604")
                    .padding(.bottom)
            }.frame(maxWidth: .infinity, maxHeight: 185).background(Color(UIColor.systemGray).opacity(0.4).blur(radius: 3)).ignoresSafeArea()
            
            ScrollView {
                VStack {
                    ChatBubble(direction: .left) {
                        Text("Hi")
                            .padding(.all, 15)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                    }
                    ChatBubble(direction: .right) {
                        Text("Hello!")
                            .padding(.all, 15)
                            .foregroundColor(Color.white)
                            .background(Color(UIColor.systemGray4))
                    }
                    ChatBubble(direction: .left) {
                        Text("Hi")
                            .padding(.all, 15)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                    }
                    ChatBubble(direction: .right) {
                        Text("Hello!")
                            .padding(.all, 15)
                            .foregroundColor(Color.white)
                            .background(Color(UIColor.systemGray4))
                    }
                    ChatBubble(direction: .left) {
                        Text("Hi")
                            .padding(.all, 15)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                    }
                    ChatBubble(direction: .right) {
                        Text("Hello!")
                            .padding(.all, 15)
                            .foregroundColor(Color.white)
                            .background(Color(UIColor.systemGray4))
                    }
                    ChatBubble(direction: .left) {
                        Text("Hi")
                            .padding(.all, 15)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                    }
                    ChatBubble(direction: .right) {
                        Text("Hello!")
                            .padding(.all, 15)
                            .foregroundColor(Color.white)
                            .background(Color(UIColor.systemGray4))
                    }
                    ChatBubble(direction: .left) {
                        Text("Hi")
                            .padding(.all, 15)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                    }
                    ChatBubble(direction: .right) {
                        Text("Hello!")
                            .padding(.all, 15)
                            .foregroundColor(Color.white)
                            .background(Color(UIColor.systemGray4))
                    }
                    ChatBubble(direction: .left) {
                        Text("Hi")
                            .padding(.all, 15)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                    }
                    ChatBubble(direction: .right) {
                        Text("Hello!")
                            .padding(.all, 15)
                            .foregroundColor(Color.white)
                            .background(Color(UIColor.systemGray4))
                    }
                    ChatBubble(direction: .left) {
                        Text("Hi")
                            .padding(.all, 15)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                    }
                    ChatBubble(direction: .right) {
                        Text("Hello!")
                            .padding(.all, 15)
                            .foregroundColor(Color.white)
                            .background(Color(UIColor.systemGray4))
                    }
                    ChatBubble(direction: .left) {
                        Text("Hi")
                            .padding(.all, 15)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                    }
                    ChatBubble(direction: .right) {
                        Text("Hello!")
                            .padding(.all, 15)
                            .foregroundColor(Color.white)
                            .background(Color(UIColor.systemGray4))
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct Video: Identifiable {
    var id = UUID()
    var name: String
    var fileName: String
}

struct VideoPlayerView: View {
    var video: Video
    
    @State private var player: AVPlayer? = nil
    @State private var isPlaying = true
    
    var body: some View {
        VStack {
            VideoPlayer(player: player)
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
                .disabled(true)
        }
        .onAppear {
            player = AVPlayer(url: Bundle.main.url(forResource: video.fileName, withExtension: "mp4")!)
            player?.play()
        }
    }
}

struct ViewPeopleView: View {
    let videos = [
        Video(name: "Video 1", fileName: "video1"),
        Video(name: "Video 2", fileName: "video2"),
        // Add more videos as needed
    ]
    
    @State private var currentIndex = 0
    
    var body: some View {
        VideoPlayerView(video: videos[currentIndex])
            .gesture(DragGesture().onEnded { gesture in
                let threshold: CGFloat = 0.01
                dump(gesture)
                if gesture.translation.height > threshold {
                    // Swipe right to show the previous video
                    currentIndex = (currentIndex - 1 + videos.count) % videos.count
                } else if gesture.translation.height < -threshold {
                    // Swipe left to show the next video
                    currentIndex = (currentIndex + 1) % videos.count
                }
            })
    }
}

extension AVPlayer {
    static var sharedQueue: AVQueuePlayer = {
        let queuePlayer = AVQueuePlayer()
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
        return queuePlayer
    }()
}

struct FirstLaunchView_Previews: PreviewProvider {
    static var previews: some View {
        FirstLaunchView()
            .preferredColorScheme(.dark)
    }
}
