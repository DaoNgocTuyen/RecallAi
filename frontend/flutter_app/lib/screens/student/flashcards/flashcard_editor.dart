part of '../student_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _StudentFlashcardEditorView on _StudentScreenState {
  Future<void> _cardEditor(DemoStore s, {DemoFlashcard? card}) async {
    var front = card?.front ?? s.explained.prompt,
        back = card?.back ?? s.explained.correctText,
        explanation = card?.explanation ?? s.explained.explanation;
    await recallDialog(
      context,
      'Tạo flashcard từ câu cần ôn',
      VStack([
        Pill('${s.explained.id} · ${s.explained.topic}'),
        Muted(
          s.sourceIsPdf
              ? 'DOC-CSDL-001 · Trang ${s.explained.page} (mẫu)'
              : 'TEXT-CSDL-001 · Không có trang PDF',
          small: true,
        ),
        RecallField(
          'Mặt trước',
          initial: front,
          lines: 2,
          onChanged: (v) => front = v,
        ),
        RecallField(
          'Mặt sau',
          initial: back,
          lines: 2,
          onChanged: (v) => back = v,
        ),
        RecallField(
          'Giải thích',
          initial: explanation,
          lines: 3,
          onChanged: (v) => explanation = v,
        ),
      ]),
      actions: [
        RecallButton(
          'Lưu vào bộ thẻ',
          onPressed: () {
            if (front.trim().isEmpty || back.trim().isEmpty) {
              feedback(context, 'Điền nội dung cho cả hai mặt thẻ.');
              return;
            }
            if (card != null) {
              card.front = front;
              card.back = back;
              card.explanation = explanation;
              s.update();
            } else {
              s.saveCard(front, back, explanation);
            }
            Navigator.pop(context);
            feedback(
              context,
              'Đã lưu flashcard. Thẻ mới đến hạn ngay trong lịch mẫu.',
            );
            go(context, '/student/flashcards');
          },
        ),
        RecallButton(
          'Hủy',
          quiet: true,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
