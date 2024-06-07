//
//  Prefrences.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/2/24.
//

import SwiftUI
import Combine

struct PreferenceSelectionSection: View {
    let title: String
    let options: [String]
    @Binding var selectedOptions: [String]
    let allowsMultipleSelection: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .padding([.top, .leading, .trailing], 6.0)
                .padding(.horizontal, 9)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Color.clear
                        .padding(.horizontal, 3)
                        .frame(height: 0)
                    
                    ForEach(options, id: \.self) { option in
                        PreferButton(option: option, selectedOptions: $selectedOptions, multiple: allowsMultipleSelection)
                    }
                }
            }
        }
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
    @Binding var email: String
    @State var customAgeRangeLowerLimit: String = ""
    @State var customAgeRangeUpperLimit: String = ""
    @State var isNegitiveLowerLimit: Bool = false
    @State var isNegitiveUpperLimit: Bool = true
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("Select your preferences")
                    .font(.title)
                    .fontWeight(.medium)
                
                //                HStack {
                //                    Text("Gender:")
                //                        .padding([.top, .leading, .trailing], 6.0)
                //                    
                //                    Spacer()
                //                }
                //                
                //                
                //                ScrollView(.horizontal, showsIndicators: false) {
                //                    HStack {
                //                        ForEach(preferencesOptions?.genderOptions.options ?? [], id: \.self) { option in
                //                            PreferButton(option: option, selectedOptions: $selectedGenderOptions, multiple: preferencesOptions?.genderOptions.multiple)
                //                        }
                //                    }
                //                }
                //                
                //                HStack {
                //                    Text("Sex:")
                //                        .padding([.top, .leading, .trailing], 6.0)
                //                    
                //                    Spacer()
                //                }
                //                
                //                ScrollView(.horizontal, showsIndicators: false) {
                //                    HStack {
                //                        ForEach(preferencesOptions?.sexOptions.options ?? [], id: \.self) { option in
                //                            PreferButton(option: option, selectedOptions: $selectedSexOptions, multiple: preferencesOptions?.sexOptions.multiple)
                //                        }
                //                    }
                //                }
                //                
                //                HStack {
                //                    Text("Sexuality:")
                //                        .padding([.top, .leading, .trailing], 6.0)
                //                    
                //                    Spacer()
                //                }
                //                
                //                ScrollView(.horizontal, showsIndicators: false) {
                //                    HStack {
                //                        ForEach(preferencesOptions?.sexualityOptions.options ?? [], id: \.self) { option in
                //                            PreferButton(option: option, selectedOptions: $selectedSexualityOptions, multiple: preferencesOptions?.sexualityOptions.multiple)
                //                        }
                //                    }
                //                }
                //                
                //                
                //                
                //                HStack {
                //                    Text("Relationship Status:")
                //                        .padding([.top, .leading, .trailing], 6.0)
                //                    
                //                    Spacer()
                //                }
                //                
                //                ScrollView(.horizontal, showsIndicators: false) {
                //                    HStack {
                //                        ForEach(preferencesOptions?.relationshipStatusOptions.options ?? [], id: \.self) { option in
                //                            PreferButton(option: option, selectedOptions: $selectedRelationshipStatusOptions, multiple: preferencesOptions?.relationshipStatusOptions.multiple)
                //                        }
                //                    }
                //                }
                //                
                //                HStack {
                //                    Text("Age Range:")
                //                        .padding([.top, .leading, .trailing], 6.0)
                //                    
                //                    Spacer()
                //                }
                //                
                //                ScrollView(.horizontal, showsIndicators: false) {
                //                    HStack {
                //                        ForEach(preferencesOptions?.ageRange.options ?? [], id: \.self) { option in
                //                            PreferButton(option: option, selectedOptions: $selectedAgeRangeOptions, multiple: preferencesOptions?.ageRange.multiple)
                //                        }
                //                    }
                //                }
                
                PreferenceSelectionSection(title: "Gender:", options: preferencesOptions?.genderOptions.options ?? [], selectedOptions: $selectedGenderOptions, allowsMultipleSelection: preferencesOptions?.genderOptions.multiple ?? false)
                
                PreferenceSelectionSection(title: "Sex:", options: preferencesOptions?.sexOptions.options ?? [], selectedOptions: $selectedSexOptions, allowsMultipleSelection: preferencesOptions?.sexOptions.multiple ?? false)
                
                PreferenceSelectionSection(title: "Sexuality:", options: preferencesOptions?.sexualityOptions.options ?? [], selectedOptions: $selectedSexualityOptions, allowsMultipleSelection: preferencesOptions?.sexualityOptions.multiple ?? false)
                
                PreferenceSelectionSection(title: "Relationship Status:", options: preferencesOptions?.relationshipStatusOptions.options ?? [], selectedOptions: $selectedRelationshipStatusOptions, allowsMultipleSelection: preferencesOptions?.relationshipStatusOptions.multiple ?? false)
                
                PreferenceSelectionSection(title: "Age Range:", options: preferencesOptions?.ageRange.options ?? [], selectedOptions: $selectedAgeRangeOptions, allowsMultipleSelection: preferencesOptions?.ageRange.multiple ?? false)
                
                if (!selectedAgeRangeOptions.isEmpty && selectedAgeRangeOptions[0] == "Custom") {
                    VStack {
                        HStack {
                            Toggle(isOn: $isNegitiveLowerLimit) {
                                Image(systemName: "plus.forwardslash.minus")
                            }
                            .frame(width: 100)
                            
                            TextField("Lower Limit", text: $customAgeRangeLowerLimit)
                                .padding()
                                .keyboardType(.decimalPad)
                        }
                        HStack {
                            Toggle(isOn: $isNegitiveUpperLimit) {
                                Image(systemName: "plus.forwardslash.minus")
                            }
                            .frame(width: 100)
                            
                            TextField("Upper Limit", text: $customAgeRangeUpperLimit)
                                .padding()
                                .keyboardType(.decimalPad)
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    addPrefs()
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
        .frame(height: UIScreen.main.bounds.height - 150)
    }
}
    
    
    func showAlert(title: String, message: String) {
        showAlert = true
        errorTitle = title
        errorMessage = message
    }
    
    private func addPrefs() -> Void {
        var lowerAge = 0
        var upperAge = 0
        
        if (selectedAgeRangeOptions.contains("Custom")) {
            lowerAge = Int((isNegitiveLowerLimit ? "" : "-") + customAgeRangeLowerLimit) ?? 0
            upperAge = Int((isNegitiveUpperLimit ? "" : "-") + customAgeRangeUpperLimit) ?? 0
        } else {
            let ageComponent = selectedAgeRangeOptions[0].replacingOccurrences(of: "±", with: "", options: NSString.CompareOptions.literal, range: nil)
            lowerAge = (Int(ageComponent) ?? 0) * -1
            upperAge = Int(ageComponent) ?? 0
        }
        
        let parameters: [String: Any] = [
            "gender": selectedGenderOptions,
            "sex": selectedSexOptions,
            "intrests": selectedInterestsOptions,
            "sexuality": selectedSexualityOptions,
            "relationshipStatus": selectedRelationshipStatusOptions,
            "ageRange": "\(lowerAge) \(upperAge)"
        ]
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(String(describing: KeychainManager.loadString(key: "token")))",
        ]
        
        //        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")", forHTTPHeaderField: "Authorization")
        
        NetworkManager.shared.post(to: URL(string: "\(apiURL)/prefs")!, body: parameters, headers: headers) { data, response, error in
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
                } else if let error = ServerErrors(rawValue: jsonResponse?["error"] as? String ?? "") {
                    // Handle specific errors
                    switch error {
                    case .EMAIL_EXISTS:
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
        }
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
    @Binding var email: String
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("Select who you are")
                    .font(.title)
                    .fontWeight(.medium)
                
                //                    HStack {
                //                        Text("Gender:")
                //                            .padding([.top, .leading, .trailing], 6.0)
                //                        
                //                        Spacer()
                //                    }
                //                    
                //                    
                //                    ScrollView(.horizontal, showsIndicators: false) {
                //                        HStack {
                //                            ForEach(preferencesOptions?.genderOptions.options ?? [], id: \.self) { option in
                //                                PreferButton(option: option, selectedOptions: $selectedGenderOptions, multiple: preferencesOptions?.genderOptions.multiple)
                //                            }
                //                        }
                //                    }
                //                    
                //                    HStack {
                //                        Text("Sex:")
                //                            .padding([.top, .leading, .trailing], 6.0)
                //                        
                //                        Spacer()
                //                    }
                //                    
                //                    ScrollView(.horizontal, showsIndicators: false) {
                //                        HStack {
                //                            ForEach(preferencesOptions?.sexOptions.options ?? [], id: \.self) { option in
                //                                PreferButton(option: option, selectedOptions: $selectedSexOptions, multiple: preferencesOptions?.sexOptions.multiple)
                //                            }
                //                        }
                //                    }
                //                    
                //                    HStack {
                //                        Text("Sexuality:")
                //                            .padding([.top, .leading, .trailing], 6.0)
                //                        
                //                        Spacer()
                //                    }
                //                    ScrollView(.horizontal, showsIndicators: false) {
                //                        HStack {
                //                            ForEach(preferencesOptions?.sexualityOptions.options ?? [], id: \.self) { option in
                //                                PreferButton(option: option, selectedOptions: $selectedSexualityOptions, multiple: preferencesOptions?.sexualityOptions.multiple)
                //                            }
                //                        }
                //                    }
                //                    
                //                    
                //                    
                //                    HStack {
                //                        Text("Relationship Status:")
                //                            .padding([.top, .leading, .trailing], 6.0)
                //                        
                //                        Spacer()
                //                    }
                //                    
                //                    ScrollView(.horizontal, showsIndicators: false) {
                //                        HStack {
                //                            ForEach(preferencesOptions?.relationshipStatusOptions.options ?? [], id: \.self) { option in
                //                                PreferButton(option: option, selectedOptions: $selectedRelationshipStatusOptions, multiple: preferencesOptions?.relationshipStatusOptions.multiple)
                //                            }
                //                        }
                //                    }
                
                PreferenceSelectionSection(title: "Gender:", options: preferencesOptions?.genderOptions.options ?? [], selectedOptions: $selectedGenderOptions, allowsMultipleSelection: preferencesOptions?.genderOptions.multiple ?? false)
                
                PreferenceSelectionSection(title: "Sex:", options: preferencesOptions?.sexOptions.options ?? [], selectedOptions: $selectedSexOptions, allowsMultipleSelection: preferencesOptions?.sexOptions.multiple ?? false)
                
                PreferenceSelectionSection(title: "Sexuality:", options: preferencesOptions?.sexualityOptions.options ?? [], selectedOptions: $selectedSexualityOptions, allowsMultipleSelection: preferencesOptions?.sexualityOptions.multiple ?? false)
                
                PreferenceSelectionSection(title: "Relationship Status:", options: preferencesOptions?.relationshipStatusOptions.options ?? [], selectedOptions: $selectedRelationshipStatusOptions, allowsMultipleSelection: preferencesOptions?.relationshipStatusOptions.multiple ?? false)
                
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
            .frame(height: UIScreen.main.bounds.height - 150)
        }
    }
    
    func showAlert(title: String, message: String) {
        showAlert = true
        errorTitle = title
        errorMessage = message
    }
    
    private func addDetails() -> Void {
        let parameters: [String: Any] = [
            "gender": selectedGenderOptions,
            "sex": selectedSexOptions,
            "intrests": selectedInterestsOptions,
            "sexuality": selectedSexualityOptions,
            "relationshipStatus": selectedRelationshipStatusOptions
        ]
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(String(describing: KeychainManager.loadString(key: "token")))",
        ]
        
        NetworkManager.shared.post(to: URL(string: "\(apiURL)/details")!, body: parameters, headers: headers) { data, response, error in
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
                } else if let error = ServerErrors(rawValue: jsonResponse?["error"] as? String ?? "") {
                    // Handle specific errors
                    switch error {
                    case .EMAIL_EXISTS:
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
        }
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

#Preview {
    DescriptorsView(addedDetails: .constant(false), email: .constant("hanna@hannaskairipa.com"))
        .preferredColorScheme(.dark)
}
