//
//  ViewController.swift
//  指纹解锁
//
//  Created by 彭盛凇 on 16/10/15.
//  Copyright © 2016年 huangbaoche. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    let context: LAContext = LAContext()
    
    var error: NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //这个属性是设置指纹输入失败之后的弹出框的右文字
        context.localizedFallbackTitle = "爸爸要输入密码"
        
        //左文字
        context.localizedCancelTitle = "爸爸要取消"
        
        //进入后台时间，不需要验证密码
//        context.evaluatedPolicyDomainState = NSData()
        
        //先判断是否具有TouchID功能
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) { //支持指纹识别
            
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "爸爸让你按home键", reply: { (success, error) in
                
                if success {    //通过
                    print("成功验证")
                }else{
                    
                    if let error = error as? NSError {
                        // 获取错误信息
                        let message = self.errorMessageForLAErrorCode(errorCode: error.code)
                        print(message)
                    }
                }
            })

        }else {//不支持指纹识别

            print("不支持指纹识别")
        }
    }
    
    func errorMessageForLAErrorCode(errorCode: Int) -> String {
        var message = ""
        
        switch errorCode {
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application" //理论上应该进入后台
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
        
        case LAError.touchIDNotEnrolled.rawValue:
            message = "Touch ID has no enrolled fingers"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
        }
        return message
    }
    
}

