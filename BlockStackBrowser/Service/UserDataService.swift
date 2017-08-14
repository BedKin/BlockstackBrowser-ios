//
//  UserDataService.swift
//  BlockStackBrowser
//
//  Created by lsease on 8/1/17.
//  Copyright © 2017 blockstack. All rights reserved.
//

import Foundation
import BlockstackCoreApi_iOS

public typealias GenericCompletionHandler<T> = (_ object: T?, _ error: Error?) -> Void

class UserDataService
{
    private static let UserProfilesKey = "USER_PROFILES"
    private static let PrivateKey = "BSK_PRIVATE_KEY"
    
    //a temporary static variable until actual persistence exists
    public var userProfiles : [Profile] = []
    
    public var privateKey : String?
    
    // shared instance
    class func shared() -> UserDataService {
        struct Singleton {
            static let instance = UserDataService()
        }
        return Singleton.instance
    }
    
    init()
    {
        loadPrivateKey()
        loadProfiles()
    }
    
}

//MARK: Private / Public Keys
//TODO: Implement methods
extension UserDataService
{
    private func loadPrivateKey()
    {
        privateKey = UserDefaults.standard.string(forKey: UserDataService.PrivateKey)
    }
    
    public func generateAndSavePrivateKey(password: String)
    {
        let privateKey = JWTUtils.shared().makeECPrivateKey()
        self.privateKey = privateKey
        UserDefaults.standard.set(privateKey, forKey: UserDataService.PrivateKey)
    }
    
    public func passphraseFromPrivateKey(_ pk : String) -> String
    {
        return pk
    }
    
    public func publicKeyFromPrivateKey(_ pk : String) -> String
    {
        return pk
    }
    
    public func privateKeyFromPassphrase(_ phrase : String) -> String
    {
        return phrase
    }
    
    public func publicKey() -> String?
    {
        return nil
    }
}


//MARK: Profiles
extension UserDataService
{
    //MARK: Profile methods
    private func loadProfiles()
    {
        if let profileData = UserDefaults.standard.object(forKey: "USER_PROFILES") as? Data,
            let profiles = Profile.deserializeArray(from: profileData)
        {
            userProfiles = profiles
        }else{
            
            userProfiles = [UserDataService.emptyProfile()]
            
            saveProfiles()
        }
    }
    
    public func getPrimaryUserProfile() -> Profile?
    {
        return userProfiles.first
    }
    
    public func saveProfiles()
    {
        //TODO: Save to storage
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(userProfiles)
        {
            UserDefaults.standard.set(data, forKey: "USER_PROFILES")
            UserDefaults.standard.synchronize()
        }
    }
    
    public func addProfile(_ profile : Profile)
    {
        userProfiles.append(profile)
        saveProfiles()
    }
}

//MARK: Test Data methods
extension UserDataService
{
    static func emptyProfile() -> Profile
    {
        var userProfile = Profile()
        userProfile.givenName = "Test"
        userProfile.familyName = "User \(UserDataService.shared().userProfiles.count)"
        userProfile.name = "\(userProfile.givenName!) \(userProfile.familyName!)"
        userProfile.description = "This is my test profile"
        
        var btcAccount = Account()
        btcAccount.service = Account.ServiceType.bitcoin.rawValue
        btcAccount.identifier = UUID.init().uuidString[0...24]
        userProfile.account = [btcAccount]
        
        return userProfile
    }
}
