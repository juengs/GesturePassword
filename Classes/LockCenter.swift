//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

public let LockManager = LockCenter.shared

let PASSWORD_KEY = "gesture_password_key_"

open class LockCenter {
    open var options = LockOptions()

    var storage: Storagable = LockUserDefaults()

    open static let shared = LockCenter()

    // 私有化构造方法，阻止其他对象使用这个类的默认的'()'构造方法
    fileprivate init() {}

    open func hasPassword(for key: String? = nil) -> Bool {
        return storage.str(forKey: suffix(with: key)) != nil
    }

    open func removePassword(for key: String? = nil) {
        storage.removeValue(forKey: suffix(with: key))
    }

    open func set(_ password: String, forKey key: String? = nil) {
        storage.set(password, forKey: suffix(with: key))
    }
    
    open func password(forKey key: String? = nil) -> String? {
        return storage.str(forKey: suffix(with: key))
    }

    private func suffix(with str: String?) -> String {
        return PASSWORD_KEY + (str ?? options.passwordKeySuffix)
    }
}

@discardableResult
public func showSetPattern(in controller: UIViewController) -> SetPatternController {
    let vc = SetPatternController()
    controller.navigationController?.pushViewController(vc, animated: true)
    return vc
}

@discardableResult
public func showVerifyPattern(in controller: UIViewController) -> VerifyPatternController {
    let vc = VerifyPatternController()
    controller.present(LockMainNav(rootViewController: vc), animated: true, completion: nil)
    return vc
}

@discardableResult
public func showModifyPattern(in controller: UIViewController) -> ResetPatternController {
    let vc = ResetPatternController()
    controller.navigationController?.pushViewController(vc, animated: true)
    return vc
}

func delay(_ interval: TimeInterval, handle: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: handle)
}
