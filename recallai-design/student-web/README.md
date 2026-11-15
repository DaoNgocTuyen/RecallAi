# RecallAI Student Web — Phase 5

[Open the Student Web dashboard](https://www.figma.com/design/jtdPE6oTE3hNoAOn3FTbOS/Untitled?node-id=136-13183)

The existing Figma Design file now contains the section **RecallAI – Student Web**, with 14 native editable screens S01–S14 at 1440×900. Laptop (1280), tablet (1024), and collapsed-sidebar examples are included. The original 25 Mobile screens, 12 Teacher Web screens, and 237 original library component definitions remain in place.

This is a native Figma Design prototype in the supplied Design file, rather than a deployed application or a new Figma Make code file.

The screens use the shared Inter typography, semantic colors, components, and RecallAI mascot. Main content scrolls beneath the fixed navigation. Supporting screens and dialogs cover uploads, errors, confirmation, practice, review, classroom joining, teacher assessments, and grading visibility.

## Try the main flows

- Dashboard → Tài liệu → AI Learning Studio → Tạo bài luyện tập → Practice → Results → Explanation.
- Tài liệu → PDF workspace → source page / related question → Flashcard.
- Flashcard library → study → rating → review calendar.
- Thống kê → weak topic → review generator or related deck.
- Kế hoạch ôn thi → generate → save → daily task → complete, move, or change duration.
- Lớp học → join preview → confirm → assigned quiz → submit → permitted results.

For the shared Teacher Web assignment, configure **Mở ngay · 12/11, hạn 20/11** in the teacher schedule picker before publishing. The default future schedule correctly blocks an early start. After publication, **Xem với sinh viên trên web** opens S14 in the same prototype context. Teacher grading is available on T10: select the submitted web assignment, choose the manual short-answer score, confirm, then return results. Keep one prototype run when checking shared variables; a fresh run resets the fixture.

Existing SQL assessments retain their two-attempt and one-attempt limits. New assignments use a frozen published question snapshot. Repeated submission does not consume another attempt. Short-answer grades require teacher confirmation; answer visibility follows the published policy. Objective-only assignments can show an immediate final score when configured; mixed assignments show a clearly labeled partial objective score until grading.

Review ratings update the shared due count and next suggested review date. Saved explanations create a review task. Exam-plan dates, availability, task completion, durations, and rescheduling use the established Mobile mock variables. Teacher review activities require approval and appear in student task lists.

## Mock boundaries

AI generation, PDF extraction, timers, text entry, dates, account identity, and synchronization are simulated. No backend, database, realtime transport, or AI service was connected. PDF references are visibly labeled sample content, not citations extracted from uploaded files.

The CSDL fixture supports the full practice flow at 5, 10, 15, or 20 questions and all three question types. Other document generation routes explain unavailable fixture content. C# and REST decks contain representative sessions of three and one card. The library cards describe the larger illustrative decks, while study sessions represent their due subsets.

The flip animation uses native Smart Animate through front, narrow edge, and back states. Legacy review/calendar data retains its 11/11/2026 sample date; newly configured teacher schedules use explicit sample dates.

## Validation and maintenance

105 action-graph checks passed, plus six preservation/layout checks. Validation executed the native prototype actions against in-memory mock state, inspected node geometry and target IDs, and visually reviewed all 14 primary screens. It is not a test of live services or an automated Figma Present browser session.

The final geometry audit found no visible text or horizontal row overflow. The prototype target audit found no missing or self-navigation targets. Screen IDs, responsive examples, assessment mappings, and detailed check results are in [handoff/design-state.json](handoff/design-state.json).

The JavaScript in `handoff/` consists of native Figma tool fragments and construction references, not a runnable web application. Use the existing node IDs for future edits; do not replay screen creation against the completed file. Later fix fragments override earlier construction logic, particularly `state-toggle-fix.js`, `assessment-policy-effective.js`, `finish-effective.js`, and `planner-task-start.js`.

Frames are page-level siblings over a named section backdrop so native NAVIGATE reactions can target them; supporting dialogs and component sources are organized alongside the main section.

