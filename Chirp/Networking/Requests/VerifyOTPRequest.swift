//
//  VerifyOTPRequest.swift
//  Chirp
//
//  Created by ioannis on 10/6/23.
//

import Foundation

struct VerifyOPTRequest:Encodable {
    
    let verificationId: String
    let verificationCode: String
}
