//
//  SignInModelTests.swift
//  homeTests
//
//  Created by Genrikh Beraylik on 16.02.2022.
//

import XCTest
@testable import SOLIUS_Home

final class SignInModelTests: XCTestCase {
    
    private var authServiceSpy: AuthServiceSpy?
    private var cloudApiSpy: CloudApiSpy?
    private var cacheSpy: CacheSpy?
    private var validatorSpy: ValidatorSpy?
    
    func test_init_doesNothingUponCreation() {
        let _ = makeSUT()
        
        XCTAssertEqual(authServiceSpy?.events, [])
        XCTAssertEqual(cloudApiSpy?.events, [])
        XCTAssertEqual(cacheSpy?.events, [])
        XCTAssertEqual(validatorSpy?.events, [])
    }

    // MARK: - Helpers
    
    private func makeSUT() -> SignInModel {
        let authServiceSpy = AuthServiceSpy()
        let cloudApiSpy = CloudApiSpy()
        let cacheSpy = CacheSpy()
        let validatorSpy = ValidatorSpy()
        let sut = SignInModel(authService: authServiceSpy, cloudApi: cloudApiSpy, cache: cacheSpy, validator: validatorSpy)
        
        self.authServiceSpy = authServiceSpy
        self.cloudApiSpy = cloudApiSpy
        self.cacheSpy = cacheSpy
        self.validatorSpy = validatorSpy
        
        return sut
    }
    
    private class AuthServiceSpy: AuthService {
        enum Event: Equatable {

        }
        
        private(set) var events = [Event]()
        
        // MARK: AuthService
        
        func login(username: String, password: String, completion: @escaping LoginCompletion) {
            
        }
        
        func fetchAuthSession(completion: @escaping AuthSessionCompletion) {
            
        }
        
        func fetchUserProfile(completion: @escaping UserProfileCompletion) {
            
        }
        
        func resetPassword(username: String, completion: @escaping ResetCompletion) {
            
        }
        
        func logout(completion: @escaping LogoutCompletion) {
            
        }
    }
    
    private class CloudApiSpy: CloudApi {
        enum Event: Equatable {

        }
        
        private(set) var events = [Event]()
        
        // MARK: CloudApi
        
        func getAccount(token: String, completion: @escaping (Result<AccountInfo, Error>) -> Void) {
            
        }
        
        func postTreatment(token: String, skinType: Int, completion: @escaping (Result<TreatmentInfo, Error>) -> Void) {
            
        }
        
        func putTreatmentSession(token: String, sessionID: Int, beginTherapyRequestData: Data, completion: @escaping (Result<TreatmentSessionInfo, Error>) -> Void) {
            
        }
        
        func postSystemStatus(token: String, sessionID: Int, state: TreatmentState, statusData: Data, completion: @escaping (Result<SystemStatusInfo, Error>) -> Void) {
            
        }
        
        func putTreatmentFollowup(token: String, sessionID: Int, rednessReported: Bool, completion: @escaping (Result<TreatmentFollowupInfo, Error>) -> Void) {
            
        }
    }
    
    private class CacheSpy: SignInCacheProtocol {
        enum Event: Equatable {

        }
        
        private(set) var events = [Event]()
        
        // MARK: SignInCacheProtocol
        
        func saveTokens(idToken: String, accessToken: String, refreshToken: String) {
            
        }
        
        func saveTreatmentSession(id: Int, dosePoint: Int, sideExposedFront: Bool, duration: Int) {
            
        }
        
        func setName(_ name: String) {
            
        }
        
        func saveSkinType(_ skinType: Int?, askErythemaQuestion: Bool) {
            
        }
        
        func clear() {
            
        }
    }
    
    private class ValidatorSpy: SignInValidator {
        enum Event: Equatable {

        }
        
        private(set) var events = [Event]()
        
        // MARK: SignInValidator
        
        func validateEmail(_ email: String) -> Bool {
            return false
        }
        
        func validatePassword(_ password: String) -> Bool {
            return false
        }
    }
    
}
