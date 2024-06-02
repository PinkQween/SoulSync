//
//  URLSessionDelegate.swift
//  SoulSync
//
//  Created by Hanna Skairipa on 6/1/24.
//

import Foundation

class URLSessionPinningDelegate: NSObject, URLSessionDelegate {
    
    private func getPinnedCertificates() -> [Data] {
        var certificates: [Data] = []
        
        if let certPath = Bundle.main.path(forResource: "server", ofType: "cer") {
            if let certData = try? Data(contentsOf: URL(fileURLWithPath: certPath)) {
                certificates.append(certData)
            }
        }
        
        return certificates
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        
        let pinnedCertificates = getPinnedCertificates()
        
        if let serverCertificate = SecTrustCopyCertificateChain(serverTrust) {
            let serverCertificateData = SecCertificateCopyData(serverCertificate as! SecCertificate) as Data
            
            if pinnedCertificates.contains(serverCertificateData) {
                let credential = URLCredential(trust: serverTrust)
                completionHandler(.useCredential, credential)
                return
            }
        }
        
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
}
