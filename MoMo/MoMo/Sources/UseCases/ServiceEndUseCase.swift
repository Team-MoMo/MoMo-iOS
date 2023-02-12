//
//  ServiceEndUseCase.swift
//  MoMo
//
//  Created by Haeseok Lee on 2023/02/12.
//

import Foundation

protocol ServiceEndUseCase {
    
    var shouldShowPopUp: Bool { get }
    
    var shouldRequestDownloadLink: Bool { get }
    
    var maximumDownloadLinkRequestCountPerDay: Int { get }
    
    func agreeNotToSeeAgain()
    
    func agreeNotToSeeAgainFor3Days()
    
    func requestDownloadLink(completion: @escaping () -> Void)
}

final class ServiceEndUseCaseImpl {


    private var _isDoNotSeeAgainConfirmed: Bool {
        get {
            UserDefaults.standard.bool(forKey: "_isDoNotSeeAgainConfirmed")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "_isDoNotSeeAgainConfirmed")
        }
    }
    
    private var _lastConfirmDateDoNotSeeAgainFor3Days: Date? {
        get {
            UserDefaults.standard.object(forKey: "_lastConfirmDateDoNotSeeAgainFor3Days") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "_lastConfirmDateDoNotSeeAgainFor3Days")
        }
    }
    
    private var _lastRequestDateDownloadLink: Date? {
        get {
            UserDefaults.standard.object(forKey: "_lastRequestDateDownloadLink") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "_lastRequestDateDownloadLink")
        }
    }
    
    private var _downloadLinkRequestCountPerDay: Int {
        get {
            UserDefaults.standard.integer(forKey: "_maximumDownloadLinkRequestCountPerDay")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "_maximumDownloadLinkRequestCountPerDay")
        }
    }
    
    private var currentDate: Date { Date() }
    
    private var isDoNotSeeAgainConfirmed: Bool {
        get {
            _isDoNotSeeAgainConfirmed
        }
        set {
            _isDoNotSeeAgainConfirmed = newValue
        }
    }
    
    private var isDoNotSeeAgainFor3DaysConfirmed: Bool {
        guard let lastConfirmDate = _lastConfirmDateDoNotSeeAgainFor3Days else {
            return false
        }
        
        if lastConfirmDate + dayToSecond(3) < currentDate {
            return false
        }
        return true
    }
}

extension ServiceEndUseCaseImpl: ServiceEndUseCase {
    
    var shouldShowPopUp: Bool {
        !isDoNotSeeAgainConfirmed && !isDoNotSeeAgainFor3DaysConfirmed
    }
    
    var shouldRequestDownloadLink: Bool {
        guard let lastRequestDate = _lastRequestDateDownloadLink else {
            return true
        }
        
        if (lastRequestDate + dayToSecond(1) < currentDate) ||
            (_downloadLinkRequestCountPerDay < maximumDownloadLinkRequestCountPerDay) {
            return true
        }
        
        return false
    }
    
    var maximumDownloadLinkRequestCountPerDay: Int { 2 }
    
    func agreeNotToSeeAgain() {
        _isDoNotSeeAgainConfirmed = true
    }
    
    func agreeNotToSeeAgainFor3Days() {
        _lastConfirmDateDoNotSeeAgainFor3Days = currentDate
    }
    
    func requestDownloadLink(completion: @escaping () -> Void) {
        // TODO: - API 요청 ~~~
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) { [weak self] in
            // TODO: API 요청 성공시 아래 구문 실행
            completion()
            self?.initializeDownloadLinkRequestCountPerDayIfNeeded()
            self?._downloadLinkRequestCountPerDay += 1
            self?._lastRequestDateDownloadLink = self?.currentDate ?? Date()
        }
    }
}

private extension ServiceEndUseCaseImpl {
    
    func dayToSecond(_ day: Int) -> TimeInterval {
        Double(day) * 24 * 60 * 60
    }
    
    func initializeDownloadLinkRequestCountPerDayIfNeeded() {
        if let _lastRequestDateDownloadLink = _lastRequestDateDownloadLink,
           getDay(from: _lastRequestDateDownloadLink) != getDay(from: currentDate) {
            _downloadLinkRequestCountPerDay = 0
        }
    }
    
    func getDay(from date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: date).day ?? 0
    }
}