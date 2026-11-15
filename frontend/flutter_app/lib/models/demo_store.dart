import 'exam_draft.dart';
import 'package:flutter/material.dart';

enum QuestionKind { choice, trueFalse, shortAnswer }

class LearningQuestion {
  const LearningQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    required this.answer,
    required this.explanation,
    required this.topic,
    this.page,
    this.kind = QuestionKind.choice,
  });
  final String id, prompt, explanation, topic;
  final List<String> options;
  final int answer;
  final int? page;
  final QuestionKind kind;
  String get correctText => options[answer];
  LearningQuestion withPrompt(String value) => LearningQuestion(
    id: id,
    prompt: value,
    options: options,
    answer: answer,
    explanation: explanation,
    topic: topic,
    page: page,
    kind: kind,
  );
}

const sampleQuestions = <LearningQuestion>[
  LearningQuestion(
    id: 'Q-CSDL-01',
    prompt: 'Khóa chính trong một bảng có vai trò gì?',
    options: [
      'Định danh duy nhất một bản ghi',
      'Sắp xếp bản ghi theo tên',
      'Lưu trữ mọi giá trị trùng nhau',
      'Mã hóa toàn bộ dữ liệu',
    ],
    answer: 0,
    explanation:
        'Khóa chính xác định duy nhất từng dòng trong bảng. Giá trị khóa chính không được trùng lặp và không được NULL.',
    topic: 'Khóa và ràng buộc',
    page: 12,
  ),
  LearningQuestion(
    id: 'Q-CSDL-02',
    prompt:
        'Đúng hay sai? Khóa ngoại luôn phải là duy nhất trong bảng chứa nó.',
    options: ['Đúng', 'Sai'],
    answer: 1,
    explanation:
        'Nhiều dòng có thể dùng cùng giá trị khóa ngoại. Khóa ngoại tham chiếu đến khóa của bảng khác để tạo quan hệ.',
    topic: 'Khóa và ràng buộc',
    page: 13,
    kind: QuestionKind.trueFalse,
  ),
  LearningQuestion(
    id: 'Q-CSDL-03',
    prompt: 'NULL thường biểu thị điều gì?',
    options: ['Giá trị chưa biết hoặc không có', 'Số 0 hoặc chuỗi rỗng'],
    answer: 0,
    explanation:
        'NULL biểu thị giá trị thiếu hoặc chưa biết. Nó khác số 0 và chuỗi rỗng; nên kiểm tra bằng IS NULL.',
    topic: 'Khóa và ràng buộc',
    page: 16,
    kind: QuestionKind.shortAnswer,
  ),
  LearningQuestion(
    id: 'Q-CSDL-04',
    prompt: 'Lệnh nào lấy dữ liệu từ một bảng?',
    options: ['SELECT', 'DELETE', 'DROP', 'UPDATE'],
    answer: 0,
    explanation:
        'SELECT dùng để chọn dữ liệu. WHERE lọc các dòng, còn ORDER BY sắp xếp kết quả.',
    topic: 'Truy vấn SQL',
    page: 19,
  ),
  LearningQuestion(
    id: 'Q-CSDL-05',
    prompt: 'Đúng hay sai? WHERE dùng để sắp xếp các dòng trong kết quả.',
    options: ['Đúng', 'Sai'],
    answer: 1,
    explanation:
        'WHERE lọc các dòng thỏa điều kiện. ORDER BY mới là mệnh đề dùng để sắp xếp kết quả.',
    topic: 'Truy vấn SQL',
    page: 20,
    kind: QuestionKind.trueFalse,
  ),
  LearningQuestion(
    id: 'Q-CSDL-06',
    prompt: 'INNER JOIN trả về những dòng nào?',
    options: [
      'Mọi dòng ở cả hai bảng',
      'Những dòng khớp điều kiện nối',
      'Chỉ những dòng không khớp',
      'Chỉ dòng đầu tiên',
    ],
    answer: 1,
    explanation:
        'INNER JOIN giữ các cặp dòng thỏa điều kiện nối giữa hai bảng. Các dòng không có cặp khớp không xuất hiện.',
    topic: 'SQL JOIN',
    page: 24,
  ),
  LearningQuestion(
    id: 'Q-CSDL-07',
    prompt:
        'Đúng hay sai? LEFT JOIN chỉ giữ các dòng có khóa khớp ở cả hai bảng.',
    options: ['Đúng', 'Sai'],
    answer: 1,
    explanation:
        'LEFT JOIN giữ toàn bộ dòng của bảng trái. Nếu không có dòng khớp bên phải, các cột phía phải nhận giá trị NULL.',
    topic: 'SQL JOIN',
    page: 24,
    kind: QuestionKind.trueFalse,
  ),
  LearningQuestion(
    id: 'Q-CSDL-08',
    prompt: 'Điều kiện ON trong JOIN dùng để làm gì?',
    options: [
      'Xác định điều kiện ghép các dòng giữa hai bảng',
      'Chỉ dùng để sắp xếp các dòng theo tên',
    ],
    answer: 0,
    explanation:
        'ON mô tả điều kiện nối, chẳng hạn SinhVien.LopId = Lop.Id. ORDER BY mới dùng để sắp xếp.',
    topic: 'SQL JOIN',
    page: 24,
    kind: QuestionKind.shortAnswer,
  ),
  LearningQuestion(
    id: 'Q-CSDL-09',
    prompt: 'SQL là tên viết tắt của cụm từ nào?',
    options: [
      'Simple Query List',
      'Sequential Question Logic',
      'Structured Query Language',
      'Standard Queue Layer',
    ],
    answer: 2,
    explanation:
        'SQL viết tắt của Structured Query Language — ngôn ngữ truy vấn có cấu trúc.',
    topic: 'Truy vấn SQL',
    page: 18,
  ),
  LearningQuestion(
    id: 'Q-CSDL-10',
    prompt: 'UNIQUE thể hiện ràng buộc nào?',
    options: [
      'Mọi giá trị phải bằng nhau',
      'Các giá trị không được trùng lặp',
      'Mọi giá trị là số',
      'Cột không được sử dụng',
    ],
    answer: 1,
    explanation:
        'UNIQUE bảo đảm tính duy nhất của giá trị trong cột hoặc nhóm cột.',
    topic: 'Khóa và ràng buộc',
    page: 14,
  ),
];

class DemoDocument {
  DemoDocument(
    this.id,
    this.title,
    this.subject,
    this.pages, {
    this.ready = true,
  });
  final String id, subject;
  String title;
  final int? pages;
  bool ready;
}

class DemoFlashcard {
  DemoFlashcard({
    required this.id,
    required this.front,
    required this.back,
    required this.explanation,
    required this.question,
    required this.due,
  });
  final String id;
  String front, back, explanation;
  final LearningQuestion question;
  DateTime due;
  String? rating;
  int reviews = 0;
}

class DemoClass {
  DemoClass(
    this.name,
    this.code,
    this.teacher,
    this.members, {
    this.joined = true,
  });
  String name, code, teacher;
  int members;
  bool joined;
}

class StudyTask {
  StudyTask(this.title, this.date, this.minutes, {this.done = false});
  String title;
  DateTime date;
  int minutes;
  bool done;
}

class DemoStore extends ChangeNotifier {
  final examDrafts = <ExamDraft>[];
  ExamDraft? pendingExam, activeExam;
  int nextExamId = 1;
  bool teacher = false, sidebarCollapsed = false, reminder = true;
  String name = 'Nguyễn Minh Anh';
  String source = 'Cơ sở dữ liệu.pdf';
  String textSource = '';
  bool sourceIsPdf = true, fileSelected = true;
  int quantity = 10;
  String difficulty = 'Trung bình';
  Set<QuestionKind> kinds = QuestionKind.values.toSet();
  final documents = [
    DemoDocument('DOC-CSDL-001', 'Cơ sở dữ liệu.pdf', 'Cơ sở dữ liệu', 24),
    DemoDocument('DOC-CS-001', 'Lập trình C#.pdf', 'Lập trình C#', null),
    DemoDocument(
      'DOC-AI-001',
      'Nhập môn trí tuệ nhân tạo.pdf',
      'Nhập môn AI',
      null,
      ready: false,
    ),
  ];
  List<LearningQuestion> quiz = List.of(sampleQuestions);
  List<int?> answers = List<int?>.filled(10, null);
  final Map<int, String> shortAnswers = {};
  final Map<int, String> lastShortAnswers = {};
  final Map<String, String> questionOverrides = {};
  bool assignedMode = false;
  List<LearningQuestion> assignmentQuestions = [];
  List<int?> assignmentAnswers = [];
  int questionIndex = 0, explanationIndex = 5, cardIndex = 0, attempts = 1;
  bool submitted = false, hasAttempt = true;
  bool examInProgress = false;
  List<int?> lastAnswers = [0, 1, 0, 0, 1, 0, 0, 1, 2, 1];
  List<LearningQuestion> lastQuiz = List.of(sampleQuestions);
  final flashcards = <DemoFlashcard>[];
  DateTime now = DateTime(2026, 11, 12, 9);
  int reviewEvents = 0;
  final classes = [
    DemoClass('Lập trình C#', 'CS-K24', 'GV Nguyễn Văn A', 30),
    DemoClass('Cơ sở dữ liệu', 'CSDL-K24', 'GV Trần Thị B', 32),
    DemoClass('Nhập môn AI', 'AI-K24', 'GV Lê Văn C', 28),
    DemoClass(
      'Cơ sở dữ liệu – K23',
      'CSDL-K23',
      'GV Nguyễn Văn A',
      58,
      joined: false,
    ),
  ];
  int selectedClass = 1;
  final tasks = <StudyTask>[
    StudyTask('Ôn SQL JOIN', DateTime(2026, 11, 12, 8), 30),
    StudyTask('Làm bài luyện tập', DateTime(2026, 11, 12, 14), 20),
    StudyTask('Ôn 15 flashcard', DateTime(2026, 11, 12, 20), 15),
  ];
  String examName = 'Thi cuối kỳ · Cơ sở dữ liệu',
      examSubject = 'Cơ sở dữ liệu';
  DateTime examDate = DateTime(2026, 12, 15);
  int dailyMinutes = 120;
  Set<int> studyDays = {1, 2, 3, 4, 5};
  String goal = 'Nắm vững kiến thức và đạt 8 điểm';
  bool planGenerated = false;
  final approvedQuestions = <String>{
    'Q-CSDL-01',
    'Q-CSDL-02',
    'Q-CSDL-04',
    'Q-CSDL-06',
    'Q-CSDL-08',
  };
  Set<String> get selectedQuestions =>
      activeExam?.questionIds ?? _selectedQuestions;
  final _selectedQuestions = <String>{
    'Q-CSDL-01',
    'Q-CSDL-02',
    'Q-CSDL-04',
    'Q-CSDL-06',
    'Q-CSDL-08',
  };
  String assignmentName = 'Ôn tập SQL JOIN – Bộ 02';
  String publishedName = 'Ôn tập SQL JOIN – Bộ 02';
  final Set<String> assignedClasses = {'CSDL-K24'};
  final Map<String, String> teacherQuestionTitles = {};
  String editingQuestionId = 'Q-CSDL-06';
  int viewerPage = 12;
  int assignmentMinutes = 20, maxAttempts = 2, remainingAttempts = 2;
  bool assignmentPublished = false,
      assignedSubmitted = false,
      gradeConfirmed = false,
      gradeReleased = false;
  double? manualGrade;
  String feedback = '', answerPolicy = 'Sau khi trả kết quả';
  bool reviewAssigned = false;
  bool reviewApproved = false;
  bool get answersVisible =>
      gradeReleased &&
      (answerPolicy == 'Sau khi trả kết quả' ||
          answerPolicy == 'Sau hạn nộp' &&
              !now.isBefore(DateTime(2026, 11, 20, 22)));

  void update() => notifyListeners();
  void setRole(bool value) {
    teacher = value;
    update();
  }

  void chooseSource(DemoDocument doc) {
    viewerPage = 12;
    source = doc.title;
    sourceIsPdf = true;
    fileSelected = true;
    update();
  }

  void beginQuiz({bool weakOnly = false, bool assigned = false}) {
    assignedMode = assigned;
    final pool = assigned
        ? assignmentQuestions
        : sampleQuestions
              .where(
                (q) =>
                    (!weakOnly || q.topic == 'SQL JOIN') &&
                    kinds.contains(q.kind),
              )
              .map((q) => q.withPrompt(questionOverrides[q.id] ?? q.prompt))
              .toList();
    if (pool.isEmpty) return;
    quiz = List.generate(
      weakOnly || assigned ? pool.length : quantity,
      (i) => pool[i % pool.length],
    );
    answers = List<int?>.filled(quiz.length, null);
    shortAnswers.clear();
    questionIndex = 0;
    submitted = false;
    examInProgress = true;
    update();
  }

  void answer(int value) {
    if (!submitted) {
      answers[questionIndex] = value;
      update();
    }
  }

  void answerShort(String value) {
    if (submitted) return;
    shortAnswers[questionIndex] = value;
    final q = quiz[questionIndex];
    answers[questionIndex] = value.trim().isEmpty
        ? null
        : value.trim().toLowerCase() == q.correctText.toLowerCase()
        ? q.answer
        : 1;
    update();
  }

  void submitQuiz() {
    if (submitted) return;
    submitted = true;
    examInProgress = false;
    if (assignedMode) {
      assignedSubmitted = true;
      assignmentAnswers = List.of(answers);
      remainingAttempts = (remainingAttempts - 1).clamp(0, maxAttempts);
      gradeConfirmed = false;
      gradeReleased = false;
      manualGrade = null;
    } else {
      hasAttempt = true;
      lastQuiz = List.of(quiz);
      lastAnswers = List.of(answers);
      lastShortAnswers
        ..clear()
        ..addAll(shortAnswers);
      attempts++;
    }
    update();
  }

  int get correct => List.generate(
    lastQuiz.length,
    (i) => lastAnswers[i] == lastQuiz[i].answer,
  ).where((v) => v).length;
  int get accuracy =>
      lastQuiz.isEmpty ? 0 : (correct * 100 / lastQuiz.length).round();
  List<int> get wrongIndices => List.generate(
    lastQuiz.length,
    (i) => i,
  ).where((i) => lastAnswers[i] != lastQuiz[i].answer).toList();
  LearningQuestion get explained =>
      lastQuiz[explanationIndex.clamp(0, lastQuiz.length - 1)];
  String get learnerAnswer {
    final i = explanationIndex;
    final a = lastAnswers[i];
    return lastShortAnswers[i] ??
        (a == null ? 'Chưa trả lời' : lastQuiz[i].options[a]);
  }

  void explain(int i) {
    explanationIndex = i;
    update();
  }

  void saveCard(String front, String back, String explanation) {
    final q = explained, id = 'FC-${explained.id}';
    final existing = flashcards.indexWhere((c) => c.id == id);
    if (existing < 0) {
      flashcards.add(
        DemoFlashcard(
          id: id,
          front: front,
          back: back,
          explanation: explanation,
          question: q,
          due: now,
        ),
      );
      cardIndex = flashcards.length - 1;
    } else {
      final c = flashcards[existing];
      c.front = front;
      c.back = back;
      c.explanation = explanation;
      cardIndex = existing;
    }
    update();
  }

  DemoFlashcard? get currentCard => flashcards.isEmpty
      ? null
      : flashcards[cardIndex.clamp(0, flashcards.length - 1)];
  void rate(String rating) {
    final c = currentCard;
    if (c == null) return;
    c.rating = rating;
    c.reviews++;
    c.due = now.add(
      Duration(
        minutes: {'Học lại': 1, 'Khó': 10, 'Tốt': 1440, 'Dễ': 5760}[rating]!,
      ),
    );
    reviewEvents++;
    update();
  }

  int get dueCount => 24 + flashcards.where((c) => !c.due.isAfter(now)).length;
  void reviewAgain(DemoFlashcard c) {
    if (c.due.isAfter(now)) now = c.due;
    cardIndex = flashcards.indexOf(c);
    update();
  }

  void joinClass(String code) {
    if (classes.any((c) => c.code == code)) return;
    classes.add(
      DemoClass('Cơ sở dữ liệu · Nhóm B', code, 'GV Nguyễn Văn A', 36),
    );
    update();
  }

  void createClass(String value) {
    classes.add(
      DemoClass(
        value,
        'RECALL-${2026 + classes.length - 4}',
        'GV Nguyễn Văn A',
        0,
        joined: false,
      ),
    );
    update();
  }

  int get assignmentObjective {
    var result = 0;
    for (var i = 0; i < assignmentQuestions.length; i++) {
      final q = assignmentQuestions[i];
      if (q.kind != QuestionKind.shortAnswer &&
          i < assignmentAnswers.length &&
          assignmentAnswers[i] == q.answer) {
        result++;
      }
    }
    return result;
  }

  int get assignmentMaximum => assignmentQuestions.fold(
    0,
    (n, q) => n + (q.kind == QuestionKind.shortAnswer ? 2 : 1),
  );
  int get assignmentShortMaximum =>
      assignmentQuestions
          .where((q) => q.kind == QuestionKind.shortAnswer)
          .length *
      2;
  void publishAssignment() {
    assignmentQuestions = sampleQuestions
        .where((q) => selectedQuestions.contains(q.id))
        .map((q) => q.withPrompt(teacherQuestionTitles[q.id] ?? q.prompt))
        .toList();
    publishedName = assignmentName;
    assignmentPublished = true;
    remainingAttempts = maxAttempts;
    assignedSubmitted = false;
    gradeConfirmed = false;
    gradeReleased = false;
    update();
  }

  void generatePlan() {
    tasks.clear();
    for (
      var date = DateTime(2026, 11, 12);
      date.isBefore(examDate);
      date = date.add(const Duration(days: 1))
    ) {
      if (studyDays.contains(date.weekday)) {
        tasks.add(
          StudyTask(
            'Ôn SQL JOIN và tự kiểm tra',
            DateTime(date.year, date.month, date.day, 8),
            dailyMinutes,
          ),
        );
      }
    }
    planGenerated = true;
    update();
  }
}

class DemoScope extends InheritedNotifier<DemoStore> {
  const DemoScope({super.key, required DemoStore store, required super.child})
    : super(notifier: store);
  static DemoStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DemoScope>()!.notifier!;
}

String dateLabel(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
String timeLabel(DateTime d) =>
    '${dateLabel(d)} · ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
