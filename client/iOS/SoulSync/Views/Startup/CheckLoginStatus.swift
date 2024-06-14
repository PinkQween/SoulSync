//
//  CheckLoginStatus.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/13/24.
//

import SwiftUI

struct CheckLoginStatus: View {
    enum launchScreens {
        case loading, first, loggedIn, error
    }
    
    @State var screen: launchScreens = .loading
    @State private var showAlert = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @ObservedObject var reloadViewHelper = ReloadViewHelper()
    
    var body: some View {
//        error
        containedView()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(errorTitle),
                    message: Text(errorMessage),
                    dismissButton: .cancel()
                )
            }
            .onAppear {
                let headers: [String: String] = [
                    "Authorization": "Bearer \(String(describing: KeychainManager.loadString(key: "token")))",
                ]
                
                NetworkManager.shared.post(to: URL(string: "\(apiURL)/validate-token")!, headers: headers) { data, res, error in
                    
                    if error != nil {
                        screen = .error
                        return
                    }
                    
                    guard let data = data else {
                        screen = .error
                        return
                    }
                    
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        
                        // Handle the response from the server
                        if let success = jsonResponse?["success"] as? Bool, success {
                            screen = .loggedIn
                        } else if ServerErrors(rawValue: jsonResponse?["error"] as? String ?? "") != nil {
                            screen = .first
                        } else {
                            screen = .error
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                        
                        screen = .error
                    }
                }
            }
    }
    
    @ViewBuilder
    private var loading: some View {
        LaunchScreenView()
    }
    
    @ViewBuilder
    private var error: some View {
        VStack {
            Text("Could not reach server please try again later\n\nIf your debbugging than try reseting token")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(20)
                .lineLimit(10)
            Button {
                let _ = KeychainManager.delete(key: "token")
            } label: {
                Text("Reset token")
            }
            .padding()
            Button {
                reload()
            } label: {
                Text("Reload app")
            }
        }
        .buttonStyle(.borderedProminent)
    }
    
    func containedView() -> AnyView {
        switch (screen) {
            case .loading: return AnyView(loading)
            case .first: return AnyView(FirstLaunchView())
            case .loggedIn: return AnyView(Color.white)
            case .error: return AnyView(error)
        }
    }
    
    func showAlert(title: String, message: String) {
        showAlert = true
        errorTitle = title
        errorMessage = message
    }
    
    func reload() {
        reloadViewHelper.reloadView()
    }
}

struct LaunchScreenView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        UIStoryboard(name: "Launch Screen", bundle: nil).instantiateInitialViewController()!
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates needed
    }
}
#Preview {
    CheckLoginStatus()
        .preferredColorScheme(.dark)
}
