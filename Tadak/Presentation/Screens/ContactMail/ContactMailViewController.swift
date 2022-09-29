//
//  ContactMailViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/09/29.
//

import UIKit
import MessageUI

final class ContactMailViewController: MFMailComposeViewController {
    
    // MARK: Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        let message = messageBody()
        self.setToRecipients(["nupic7@gmail.com"])
        self.setSubject("[타닥타닥] 문의/피드백")
        self.setMessageBody(message, isHTML: false)
    }
    
    private func messageBody() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let device = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        let info = Bundle.main.infoDictionary
        let appVersion = info?["CFBundleShortVersionString"] as? String ?? ""
        let osVersion = UIDevice.current.systemVersion
        
        return """
        1. 분류:
        ex) 문의/ 피드백/ 버그신고
        
        
        
        2. 세부 내용:
        
        
        
        
        
        - OS version: iOS \(osVersion)
        - App version: iOS \(appVersion)
        - Device: \(device)
        """
    }
}
