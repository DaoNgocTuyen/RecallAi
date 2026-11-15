export type Role = 'student' | 'teacher';
export type QuestionType = 'mc' | 'tf' | 'short';
export interface Question { id: string; prompt: string; statement: string; options: string[]; mcOptions: string[]; correct: number; mcCorrect: number; truth: boolean; expected: string; explanation: string; topic: string; page: number | null; type: QuestionType; points: number; approved: boolean; sourceId: string; }
export interface DocumentItem { id: string; title: string; subject: string; uploaded: string; pages: number | null; size: string; status: 'ready' | 'processing' | 'error'; }
export interface Attempt { id: string; questions: Question[]; answers: (string | null)[]; sourceId: string; sourceTitle: string; submittedAt: string; correct: boolean[]; quizId?: string; }
export interface Flashcard { id: string; front: string; back: string; explanation: string; topic: string; questionId: string; sourceId: string; sourceTitle: string; page: number | null; deckId: string; due: string; lastRating?: Rating; reviews: number; }
export type Rating = 'Học lại' | 'Khó' | 'Tốt' | 'Dễ';
export interface Deck { id: string; title: string; subject: string; count: number; due: number; progress: number; lastReview: string; }
export interface Classroom { id: string; name: string; teacher: string; code: string; members: number; quizzes: number; joined: boolean; archived: boolean; announcement: string; }
export interface QuizDraft { name: string; description: string; subject: string; questionIds: string[]; minutes: number; attempts: number; start: string; deadline: string; answerPolicy: 'Sau khi trả kết quả' | 'Sau hạn nộp' | 'Không công bố'; resultPolicy: 'Ngay sau khi nộp' | 'Sau khi giáo viên duyệt'; shuffle: boolean; classIds: string[]; }
export interface Assignment extends QuizDraft { id: string; questions: Question[]; publishedAt: string; }
export interface Submission { id: string; assignmentId: string; attempt: Attempt; remaining: number; manual: Record<string, number>; feedback: string; confirmed: boolean; released: boolean; }
export interface PlanTask { id: string; title: string; date: string; time: string; minutes: number; done: boolean; }
export interface ExamPlan { name: string; subject: string; date: string; minutes: number; days: number[]; goal: string; topics: string[]; tasks: PlanTask[]; }
export interface AppData { version: 1; profile: { name: string; email: string; reminders: boolean; }; role: Role; documents: DocumentItem[]; questions: Question[]; attempts: Attempt[]; flashcards: Flashcard[]; decks: Deck[]; classes: Classroom[]; assignments: Assignment[]; submissions: Submission[]; draft: QuizDraft; plan: ExamPlan; mockNow: string; reviewEvents: number; }
export interface QuizConfig { sourceId: string; sourceTitle: string; quantity: number; types: QuestionType[]; difficulty: string; topic?: string; text?: string; }
