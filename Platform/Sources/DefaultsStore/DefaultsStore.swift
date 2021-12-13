import Foundation

// DefaultsStore는 기능을 확장할 때 마다 모듈을 수정해야하기 때문에 잘못 설계된 구조이다.
// OCP 원칙을 지키지 않았다.

public protocol DefaultsStore {
    var isInitialLaunch: Bool { get set }
    var lastNoticeDate: Double { get set }
}

public struct DefaultsStoreImp: DefaultsStore {
    
    public var isInitialLaunch: Bool {
        get {
            userDefaults.bool(forKey: kIsInitialLaunch)
        }
        set {
            userDefaults.set(newValue, forKey: kIsInitialLaunch)
        }
    }
    
    public var lastNoticeDate: Double {
        get {
            userDefaults.double(forKey: kLastNoticeDate)
        }
        set {
            userDefaults.set(newValue, forKey: kLastNoticeDate)
        }
    }
    
    private let userDefaults: UserDefaults
    
    private let kIsInitialLaunch = "kIsInitialLaunch"
    private let kLastNoticeDate = "kLastNoticeDate"
    
    public init(defaults: UserDefaults) {
        self.userDefaults = defaults
    }
    
}
