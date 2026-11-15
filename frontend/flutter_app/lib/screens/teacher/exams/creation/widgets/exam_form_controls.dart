part of '../exam_creation_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _ExamCreationExamFormControlsView on _ExamCreationScreenState {
  Widget _select(
    String label,
    String value,
    List<String> options,
    ValueChanged<String> changed,
  ) => VStack([
    Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      items: [
        for (final option in options)
          DropdownMenuItem(value: option, child: Text(option)),
      ],
      onChanged: (value) {
        if (value != null) _refresh(() => changed(value));
      },
    ),
  ], gap: 8);

  Widget _pricing(ExamDraft draft) => VStack([
    const SectionTitle('Cấu hình giá'),
    _choices(draft.pricing, [
      'Miễn phí',
      'Thu phí khi tham gia thi',
      'Thu phí khi xem giải thích',
    ], (v) => draft.pricing = v),
    const Muted(
      'Cấu hình minh họa trong phiên frontend. Chưa có thanh toán và không phát sinh giao dịch.',
      small: true,
    ),
  ], gap: 12);

  Widget _choices(
    String selected,
    List<String> options,
    ValueChanged<String> changed,
  ) => Wrap(
    spacing: 12,
    runSpacing: 10,
    children: [
      for (final value in options)
        ChoiceChip(
          label: Text(value),
          selected: selected == value,
          onSelected: (_) => _refresh(() => changed(value)),
        ),
    ],
  );

  Widget _empty(String message) => RecallCard(
    child: VStack([
      const Icon(
        Icons.description_outlined,
        size: 48,
        color: RecallColors.green,
      ),
      Text(message),
      RecallButton(
        'Tạo đề mới',
        onPressed: () => go(context, '/teacher/builder'),
      ),
    ]),
  );

  Widget _settingRow(String title, String description, Widget control) =>
      LayoutBuilder(
        builder: (context, c) {
          final label = VStack([
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            Muted(description, small: true),
          ], gap: 8);
          if (c.maxWidth < 760) return VStack([label, control], gap: 16);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 4, child: label),
              const SizedBox(width: 32),
              Expanded(flex: 6, child: control),
            ],
          );
        },
      );

  Widget _toggle(
    String title,
    String description,
    bool value,
    ValueChanged<bool> change,
  ) => _settingRow(
    title,
    description,
    Align(
      alignment: Alignment.centerLeft,
      child: Switch(value: value, onChanged: (v) => _refresh(() => change(v))),
    ),
  );
}
