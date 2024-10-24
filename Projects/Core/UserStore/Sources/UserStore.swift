import Foundation
import SwiftyUserDefaults

public var Defaults = DefaultsAdapter<DefaultsKeys>(defaults: .standard, keyStore: .init())

public extension DefaultsKeys {
    var launchCount: DefaultsKey<Int> { .init("launchCount", defaultValue: 0) }
    var isAuthenticated: DefaultsKey<Bool> { .init("isAuthenticated", defaultValue: false) }
    var jwtToken: DefaultsKey<String?> { .init("jwtToken") }
    
    var profileImageUrl: DefaultsKey<URL?> { .init("profileImageUrl") }
    var phoneNumber: DefaultsKey<String?> { .init("phoneNumber") }
    var nickname: DefaultsKey<String?> { .init("nickname") }
    var name: DefaultsKey<String?> { .init("name") }
    var email: DefaultsKey<String?> { .init("email") }
    var birth: DefaultsKey<String?> { .init("birth") }
    var stepCounterInitializedDate: DefaultsKey<Date?> { .init("stepCounterInitializedDate") }
}

public extension DefaultsAdapter {
    func clearUser() {
        Defaults.isAuthenticated = false
        Defaults.jwtToken = nil
        Defaults.profileImageUrl = nil
        Defaults.phoneNumber = nil
        Defaults.nickname = nil
        Defaults.name = nil
        Defaults.email = nil
        Defaults.birth = nil
    }
}
