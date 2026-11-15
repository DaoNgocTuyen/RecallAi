import 'package:flutter/material.dart';

enum ExamMethod {
  upload(
    'Tạo đề từ tệp',
    'Đính kèm tài liệu để chuẩn bị nội dung đề.',
    Icons.upload_file_outlined,
    true,
  ),
  manual(
    'Tự soạn Đề thi / Bài tập',
    'Soạn câu hỏi, chỉnh sửa nội dung hoặc chọn từ ngân hàng câu hỏi RecallAI.',
    Icons.edit_note_outlined,
    true,
  ),
  interactive(
    'Tạo đề thi tương tác',
    'Chuẩn bị bài luyện tập với trắc nghiệm, đúng / sai và câu trả lời ngắn.',
    Icons.sports_esports_outlined,
    true,
  ),
  competency(
    'Tạo đề thi đánh giá năng lực',
    'Tổ chức đề theo chủ đề kiến thức và mức độ khó.',
    Icons.fact_check_outlined,
    true,
  ),
  matrix(
    'Tạo đề từ Ma trận đề',
    'Phân bổ câu hỏi theo chủ đề, số lượng và mức độ khó.',
    Icons.account_balance_outlined,
    true,
  ),
  excel(
    'Tạo đề thi từ file Excel',
    'Chọn tệp Excel để chuẩn bị nhập ngân hàng câu hỏi.',
    Icons.table_chart_outlined,
    true,
  ),
  offlineManual(
    'Tạo đề offline thủ công',
    'Soạn đề và chuẩn bị đáp án cho bài kiểm tra trên giấy.',
    Icons.draw_outlined,
    false,
  ),
  offlineText(
    'Tạo đề thi offline bằng Text',
    'Nhập nội dung văn bản và tiếp tục biên tập câu hỏi.',
    Icons.text_fields_outlined,
    false,
  ),
  offlineExcel(
    'Tạo đề thi offline từ file Excel',
    'Đính kèm Excel để chuẩn bị đề và bảng đáp án offline.',
    Icons.grid_on_outlined,
    false,
  );

  const ExamMethod(this.title, this.description, this.icon, this.online);
  final String title, description;
  final IconData icon;
  final bool online;
}

class ExamDraft {
  ExamDraft({required this.id, this.method = ExamMethod.manual});
  final String id;
  ExamMethod method;
  String title = '',
      grade = 'Đại học',
      subject = 'Cơ sở dữ liệu',
      purpose = 'Luyện tập / Ôn tập',
      description = '',
      pricing = 'Miễn phí',
      sourceName = '',
      sourceText = '';
  final questionIds = <String>{};
  bool saved = false, settingsSaved = false;
  int minutes = 20, attempts = 2;
  bool shuffle = false,
      hideGroups = false,
      hideWrongAnswers = false,
      hideAttemptStats = false,
      hideLeaderboard = false,
      addHeader = false,
      showNotice = false;
  final Set<String> keyboards = {'Bàn phím cơ bản'};
  String scoreVisibility = 'Khi làm bài xong',
      answerVisibility = 'Khi làm bài xong',
      header = '',
      notice = '';
  int answerThreshold = 70;
  ExamDraft copy() => ExamDraft(id: id, method: method)
    ..title = title
    ..grade = grade
    ..subject = subject
    ..purpose = purpose
    ..description = description
    ..pricing = pricing
    ..sourceName = sourceName
    ..sourceText = sourceText
    ..questionIds.addAll(questionIds)
    ..settingsSaved = settingsSaved
    ..saved = saved
    ..minutes = minutes
    ..attempts = attempts
    ..shuffle = shuffle
    ..hideGroups = hideGroups
    ..hideWrongAnswers = hideWrongAnswers
    ..hideAttemptStats = hideAttemptStats
    ..hideLeaderboard = hideLeaderboard
    ..addHeader = addHeader
    ..showNotice = showNotice
    ..keyboards.clear()
    ..keyboards.addAll(keyboards)
    ..scoreVisibility = scoreVisibility
    ..answerVisibility = answerVisibility
    ..header = header
    ..notice = notice
    ..answerThreshold = answerThreshold;

  static const extensions = [
    'pdf',
    'docx',
    'xlsx',
    'tex',
    'zip',
    'jpg',
    'jpeg',
    'png',
  ];
  static bool accepts(String name) =>
      extensions.contains(name.split('.').last.toLowerCase());
}
