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
    
    override func tearDown() {
        authServiceSpy = nil
        cloudApiSpy = nil
        cloudApiSpy = nil
        cloudApiSpy = nil
    }
    
    func test_init_doesNothingUponCreation() {
        let _ = makeSUT()
        
        XCTAssertEqual(authServiceSpy?.events, [])
        XCTAssertEqual(cloudApiSpy?.events, [])
        XCTAssertEqual(cacheSpy?.events, [])
        XCTAssertEqual(validatorSpy?.events, [])
    }
    
    func test_login_responseNeedsConfirmationOnConfirmSignUp() {
        let sut = makeSUT()
        authServiceSpy?.loginResult = .success(.confirmSignUp)
        
        expect(sut, toCompleteLoginWith: .needsConfirmation)
        
        XCTAssertEqual(authServiceSpy?.events, [.login])
    }
    
    func test_login_fetchErrorOnLoginError() {
        let sut = makeSUT()
        
        let error = SLError(userMessage: "an error")
        authServiceSpy?.loginResult = .failure(error)
        
        expect(sut, toCompleteLoginWith: .error(title: "Login Failed", message: error.userMessage))
        
        XCTAssertEqual(authServiceSpy?.events, [.login])
    }
    
    func test_login_fetchErrorOnSessionError() {
        let sut = makeSUT()
        
        let error = SLError(userMessage: "an error")
        authServiceSpy?.loginResult = .success(.done)
        authServiceSpy?.sessionResult = .failure(error)
        
        expect(sut, toCompleteLoginWith: .error(title: "Login Failed", message: error.userMessage))
        
        XCTAssertEqual(authServiceSpy?.events, [.login, .fetchAuthSession])
    }
    
    func test_login_fetchErrorOnFetchingUserProfile() {
        let sut = makeSUT()
        
        let error = SLError(userMessage: "an error")
        let session = AuthSession(idToken: "id", accessToken: "access", refreshToken: "refresh")
        authServiceSpy?.loginResult = .success(.done)
        authServiceSpy?.sessionResult = .success(session)
        authServiceSpy?.userResult = .failure(error)
        
        expect(sut, toCompleteLoginWith: .error(title: "Login Failed", message: error.userMessage))
        
        XCTAssertEqual(authServiceSpy?.events, [.login, .fetchAuthSession, .fetchUserProfile])
    }
    
    func test_login_fetchErrorOnGetAccountError() {
        let sut = makeSUT()
        
        let error = NSError(domain: "an error", code: 0)
        let session = AuthSession(idToken: "id", accessToken: "access", refreshToken: "refresh")
        let userProfile = UserProfile(firstName: "first", lastName: "last")
        authServiceSpy?.loginResult = .success(.done)
        authServiceSpy?.sessionResult = .success(session)
        authServiceSpy?.userResult = .success(userProfile)
        cloudApiSpy?.accountResult = .failure(error)
        
        expect(sut, toCompleteLoginWith: .error(title: "Login Again", message: "First time login"))
        
        XCTAssertEqual(authServiceSpy?.events, [.login, .fetchAuthSession, .fetchUserProfile])
        XCTAssertEqual(cloudApiSpy?.events, [.getAccount])
    }
    
    func test_login_showWelcomeScreenOnSuccessWithoutSkinType() {
        let sut = makeSUT()
        
        let session = AuthSession(idToken: "id", accessToken: "access", refreshToken: "refresh")
        let userProfile = UserProfile(firstName: "first", lastName: "last")
        let accountInfo = AccountInfo(askErythemaQuestion: true, lowDoseFlag: true, skinType: 0)
        authServiceSpy?.loginResult = .success(.done)
        authServiceSpy?.sessionResult = .success(session)
        authServiceSpy?.userResult = .success(userProfile)
        cloudApiSpy?.accountResult = .success(accountInfo)
        
        expect(sut, toCompleteLoginWith: .showWelcomeScreen)
        
        XCTAssertEqual(authServiceSpy?.events, [.login, .fetchAuthSession, .fetchUserProfile])
        XCTAssertEqual(cloudApiSpy?.events, [.getAccount])
    }
    
    func test_login_showHomeScreenOnSuccessWithSkinType() {
        let sut = makeSUT()
        
        let session = AuthSession(idToken: "id", accessToken: "access", refreshToken: "refresh")
        let userProfile = UserProfile(firstName: "first", lastName: "last")
        let accountInfo = AccountInfo(askErythemaQuestion: true, lowDoseFlag: true, skinType: 1)
        authServiceSpy?.loginResult = .success(.done)
        authServiceSpy?.sessionResult = .success(session)
        authServiceSpy?.userResult = .success(userProfile)
        cloudApiSpy?.accountResult = .success(accountInfo)
        
        expect(sut, toCompleteLoginWith: .showHomeScreen(token: "access", skinType: 1))
        
        XCTAssertEqual(authServiceSpy?.events, [.login, .fetchAuthSession, .fetchUserProfile])
        XCTAssertEqual(cloudApiSpy?.events, [.getAccount])
    }

    func test_postTreatment_sendActionToCloudAPI() {
        let sut = makeSUT()
        
        sut.postTreatment(accessToken: "", skinType: 0) { _ in }
        
        XCTAssertEqual(cloudApiSpy?.events, [.postTreatment])
    }
    
    func test_postTreatment_completesWithSuccessOnAPISuccess() {
        let sut = makeSUT()
        let treatmentInfo = TreatmentInfo(TreatmentBlockedReason: "", SessionId: 1, SkinType: 0, DosePoint: 1, TreatmentBlocked: false, Intensity: 0, SideExposedFront: true, SessionDurationSeconds: 1, LowDoseFlag: false, DoseDiscovery: false)
        cloudApiSpy?.treatmentResult = .success(treatmentInfo)
        
        var completionIsSuccess: Bool = false
        let exp = expectation(description: "wait for the response")
        sut.postTreatment(accessToken: "", skinType: 0) { result in
            switch result {
            case .success:
                completionIsSuccess = true
            case .failure:
                XCTFail("Expected success, got failure instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        
        XCTAssertTrue(completionIsSuccess)
    }
    
    func test_postTreatment_completesWithFailureOnAPIError() {
        let sut = makeSUT()
        let error = NSError(domain: "an error", code: 0)
        cloudApiSpy?.treatmentResult = .failure(error)
        
        var completionIsFailure: Bool = false
        let exp = expectation(description: "wait for the response")
        sut.postTreatment(accessToken: "", skinType: 0) { result in
            switch result {
            case .failure:
                completionIsFailure = true
            case .success:
                XCTFail("Expected failure, got success instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        
        XCTAssertTrue(completionIsFailure)
    }
    
    func test_postTreatment_storesTreatmentSessionOnSuccess() {
        let sut = makeSUT()
        let treatmentInfo = TreatmentInfo(TreatmentBlockedReason: "", SessionId: 1, SkinType: 0, DosePoint: 1, TreatmentBlocked: false, Intensity: 0, SideExposedFront: true, SessionDurationSeconds: 1, LowDoseFlag: false, DoseDiscovery: false)
        cloudApiSpy?.treatmentResult = .success(treatmentInfo)
        
        let exp = expectation(description: "wait for the response")
        sut.postTreatment(accessToken: "", skinType: 0) { result in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        
        let expectedEvent = CacheSpy.Event.saveTreatment(id: treatmentInfo.SessionId,
                                                         dosePoint: treatmentInfo.DosePoint,
                                                         sideExposedFront: treatmentInfo.SideExposedFront,
                                                         duration: treatmentInfo.SessionDurationSeconds)
        XCTAssertEqual(cacheSpy?.events, [expectedEvent])
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
    
    private func expect(_ sut: SignInModel, toCompleteLoginWith expectedResult: SignInResult, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.login(email: "", password: "") { receivedResult in
            switch (receivedResult, expectedResult) {
            case (.needsConfirmation, .needsConfirmation):
                break
            case (.showWelcomeScreen, .showWelcomeScreen):
                break
            case let (.showHomeScreen(receivedToken, receivedSkinType), .showHomeScreen(expectedToken, expectedSkinType)):
                XCTAssertEqual(receivedToken, expectedToken, file: file, line: line)
                XCTAssertEqual(receivedSkinType, expectedSkinType, file: file, line: line)
            case let (.error(receivedTitle, receivedMessage), .error(expectedTitle, expectedMessage)):
                XCTAssertEqual(receivedTitle, expectedTitle, file: file, line: line)
                XCTAssertEqual(receivedMessage, expectedMessage, file: file, line: line)
            default:
                XCTFail("Expected result got \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    private class AuthServiceSpy: AuthService {
        enum Event: Equatable {
            case login
            case fetchAuthSession
            case fetchUserProfile
        }
        
        private(set) var events = [Event]()
        
        var loginResult: LoginResult?
        var sessionResult: SessionResult?
        var userResult: UserResult?
        
        // MARK: AuthService
        
        func login(username: String, password: String, completion: @escaping LoginCompletion) {
            events.append(.login)
            completion(loginResult!)
        }
        
        func fetchAuthSession(completion: @escaping AuthSessionCompletion) {
            events.append(.fetchAuthSession)
            completion(sessionResult!)
        }
        
        func fetchUserProfile(completion: @escaping UserProfileCompletion) {
            events.append(.fetchUserProfile)
            completion(userResult!)
        }
        
        // Unused
        func resetPassword(username: String, completion: @escaping ResetCompletion) {}
        func logout(completion: @escaping LogoutCompletion) {}
    }
    
    private class CloudApiSpy: CloudApi {
        enum Event: Equatable {
            case getAccount
            case postTreatment
        }
        
        private(set) var events = [Event]()
        
        var accountResult: Result<AccountInfo, Error>?
        var treatmentResult: Result<TreatmentInfo, Error>?
        
        // MARK: CloudApi
        
        func getAccount(token: String, completion: @escaping (Result<AccountInfo, Error>) -> Void) {
            events.append(.getAccount)
            completion(accountResult!)
        }
        
        func postTreatment(token: String, skinType: Int, completion: @escaping (Result<TreatmentInfo, Error>) -> Void) {
            events.append(.postTreatment)
            if let treatmentResult = treatmentResult {
                completion(treatmentResult)
            }
        }
        
        // Unused
        func putTreatmentSession(token: String, sessionID: Int, beginTherapyRequestData: Data, completion: @escaping (Result<TreatmentSessionInfo, Error>) -> Void) {}
        func postSystemStatus(token: String, sessionID: Int, state: TreatmentState, statusData: Data, completion: @escaping (Result<SystemStatusInfo, Error>) -> Void) {}
        func putTreatmentFollowup(token: String, sessionID: Int, rednessReported: Bool, completion: @escaping (Result<TreatmentFollowupInfo, Error>) -> Void) {}
    }
    
    private class CacheSpy: SignInCacheProtocol {
        enum Event: Equatable {
            case saveTreatment(id: Int, dosePoint: Int, sideExposedFront: Bool, duration: Int)
        }
        
        private(set) var events = [Event]()
        
        // MARK: SignInCacheProtocol
        
        func saveTokens(idToken: String, accessToken: String, refreshToken: String) {
            
        }
        
        func saveTreatmentSession(id: Int, dosePoint: Int, sideExposedFront: Bool, duration: Int) {
            events.append(.saveTreatment(id: id, dosePoint: dosePoint, sideExposedFront: sideExposedFront, duration: duration))
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
