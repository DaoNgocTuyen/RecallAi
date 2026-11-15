# RecallAI · Phase 3

[Open screens 16–25 in Figma](https://www.figma.com/design/jtdPE6oTE3hNoAOn3FTbOS/Untitled?node-id=76-7437).

The existing fifteen screens and the 237 original library component definitions are preserved. Ten new 390 × 844 screens cover analytics, weak topics, exam planning, daily scheduling, classrooms, invitations, class details, assignments, teacher assessments and results.

The dashboard retains its existing content and adds contextual analytics/planner shortcuts. Its classroom shortcut now opens My Classrooms. The five-item navigation is retained. During teacher assessments the bottom navigation is hidden to keep the assessment focused.

All three requested journeys are connected. Supporting states include date/time/topic selectors, invalid plans, task details/rescheduling/duration controls, class-code validation/loading/preview/success, assignment filters, attempt exhaustion, submission warnings, expiry, submitted confirmation, hidden answers, published answers and grading pending. Each weak topic has a separate three-question sample practice session.

Validation: 107 native-action logic checks passed. All twenty-five primary frames are present at 390 × 844. The new screens use Inter, have no detected visible text overflow or missing navigation destinations, and were visually reviewed. Checks evaluate the stored Figma actions; they are not browser-driven playback or backend tests.

The prototype uses sample data. Form input is simulated through example states and selectors. AI suggestions are editable. Teacher answer visibility is enforced through distinct result flows; students have no answer-release toggle. The teacher timer advances with mock question progress and an explicit expiry scenario. No real backend, authorization, PDF parsing, AI processing, classroom enrollment or grading is connected.

The planning dataset treats 11/11/2026 as today, starts new plans on 12/11/2026, and offers sample exam dates 15/12/2026 and 22/12/2026. The detailed daily calendar demonstrates 09–22/11/2026. Draft changes do not apply to the saved schedule until Save.

`design-state.json` records the current Figma IDs and validation evidence. JavaScript files are construction records requiring Figma Plugin API context; do not run them blindly against the completed file. The effective snapshots retain later corrections to native conditional handling, attempt tracking and routing.
