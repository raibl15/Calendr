//
//  MockCalendarServiceProvider.swift
//  CalendrTests
//
//  Created by Paker on 11/03/2021.
//

import Foundation
import RxSwift
@testable import Calendr

typealias EventsArgs = (start: Date, end: Date, calendars: [String])

class MockCalendarServiceProvider: CalendarServiceProviding {

    let (changeObservable, changeObserver) = PublishSubject<Void>.pipe()
    let (spyEventsObservable, spyEventsObserver) = PublishSubject<EventsArgs>.pipe()
    let (spyCompleteObservable, spyCompleteObserver) = PublishSubject<Void>.pipe()
    let (spyRescheduleObservable, spyRescheduleObserver) = PublishSubject<Date>.pipe()
    let (spyChangeEventStatusObservable, spyChangeEventStatusObserver) = PublishSubject<EventStatus>.pipe()

    var didRequestAccess: (() -> Void)?

    var m_calendars: [CalendarModel] = []
    var m_events: [EventModel] = []

    func requestAccess() { didRequestAccess?() }

    func calendars() -> Observable<[CalendarModel]> { .just(m_calendars) }

    func events(from start: Date, to end: Date, calendars: [String]) -> Observable<[EventModel]> {
        spyEventsObserver.onNext((start: start, end: end, calendars: calendars))
        return .just(m_events)
    }

    func completeReminder(id: String) -> Observable<Void> {
        spyCompleteObserver.onNext(())
        return .void()
    }

    func rescheduleReminder(id: String, to date: Date) -> Observable<Void> {
        spyRescheduleObserver.onNext(date)
        return .void()
    }

    func changeEventStatus(id: String, date: Date, to status: EventStatus) -> Observable<Void> {
        spyChangeEventStatusObserver.onNext(status)
        return .void()
    }
}

// MARK: - Helpers

extension MockCalendarServiceProvider {

    func changeEvents(_ events: [EventModel]) {
        m_events = events
        changeObserver.onNext(())
    }
}
