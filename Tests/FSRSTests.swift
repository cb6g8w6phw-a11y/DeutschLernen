import Foundation
import Testing
@testable import DeutschLernen

@Test func oneCorrectHitCreditsAndDoesNotMaster() {
    var card = WordStat()
    let now = Date(timeIntervalSince1970: 1_700_000_000)
    let snap = StudyCredit.goodHit(card: &card, counted: 4, now: now)
    #expect(snap.counted == 5)
    #expect(snap.due > now)
    #expect(snap.mastered == false)
    #expect(FSRS.mastered(card) == false)
    #expect(card.reps == 1)
    #expect(card.stability < 21)
}

@Test func laterReviewCanMaster() {
    var card = WordStat()
    var now = Date(timeIntervalSince1970: 1_700_000_000)
    for _ in 0..<6 {
        FSRS.apply(&card, rating: .good, now: now, fuzz: false)
        now = card.due.addingTimeInterval(60)
    }
    #expect(card.stability.isFinite)
    #expect(card.stability < 100_000)
    #expect(FSRS.mastered(card))
    #expect(card.due > Date(timeIntervalSince1970: 1_700_000_000))
}

@Test func againIsNotMasteredAndComesBackSoon() {
    var card = WordStat()
    let now = Date(timeIntervalSince1970: 1_700_000_000)
    FSRS.apply(&card, rating: .again, now: now, fuzz: false)
    #expect(FSRS.mastered(card) == false)
    #expect(card.due > now)
    #expect(card.due.timeIntervalSince(now) < 3600)
}

@Test func fuzzStaysInsideFivePercent() {
    let low = FSRS.fuzzed(10, unit: 0)
    let high = FSRS.fuzzed(10, unit: 1)
    #expect(low >= 9.5)
    #expect(high <= 10.5)
}

@Test func answerIgnoresPeriodCaseAndUmlaut() {
    #expect(AnswerCheck.judge("Die Heizung ist kaputt.", "die Heizung ist kaputt") == .exact)
    #expect(AnswerCheck.judge("fuer", "für") == .exact)
    #expect(AnswerCheck.judge("heiss", "heiß") == .typo || AnswerCheck.judge("heiss", "heiß") == .exact)
    #expect(AnswerCheck.judge("Die Heizung ist kaput", "Die Heizung ist kaputt") == .typo)
    #expect(AnswerCheck.almost("Ja.") == "Prawie dobrze: Ja.")
}
