part of '../student_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _StudentFlashcardReviewPageView on _StudentScreenState {
  Widget _flashcards(DemoStore s) {
    final c = s.currentCard, q = c?.question ?? s.explained;
    return VStack([
      Wrap(
        spacing: 24,
        runSpacing: 8,
        alignment: WrapAlignment.spaceBetween,
        children: [
          SectionTitle(
            c == null ? 'Thuật ngữ Cơ sở dữ liệu' : 'Sai lầm cần ôn · CSDL',
            large: true,
          ),
          Text(
            c == null
                ? '3 / 20'
                : '${s.cardIndex + 1} / ${s.flashcards.length}',
          ),
        ],
      ),
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: VStack([
            GestureDetector(
              onTap: () => _refresh(() => flipped = !flipped),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 350),
                  tween: Tween(end: flipped ? math.pi : 0),
                  builder: (context, angle, _) {
                    final back = angle > math.pi / 2;
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, .001)
                        ..rotateY(angle),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(back ? math.pi : 0),
                        child: RecallCard(
                          color: back ? Colors.white : RecallColors.mint,
                          padding: 32,
                          child: SizedBox(
                            width: double.infinity,
                            height: 316,
                            child: Center(
                              child: VStack(
                                [
                                  Muted(
                                    back ? 'ĐÁP ÁN' : 'CÂU HỎI',
                                    small: true,
                                  ),
                                  Text(
                                    back
                                        ? c?.back ?? q.correctText
                                        : c?.front ?? q.prompt,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineMedium,
                                  ),
                                  Text(
                                    back
                                        ? c?.explanation ?? q.explanation
                                        : 'Tự nhớ lại kiến thức trước khi lật thẻ.',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: RecallColors.muted,
                                    ),
                                  ),
                                  const Muted(
                                    '↻ Nhấp hoặc chạm để lật thẻ',
                                    small: true,
                                  ),
                                ],
                                gap: 16,
                                crossAxisAlignment: CrossAxisAlignment.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (flipped)
              AdaptiveGrid(
                [
                  for (final rating in ['Học lại', 'Khó', 'Tốt', 'Dễ'])
                    RecallCard(
                      padding: 16,
                      onTap: () {
                        if (s.currentCard == null) {
                          s.saveCard(q.prompt, q.correctText, q.explanation);
                        }
                        s.rate(rating);
                        _refresh(() => flipped = false);
                        go(context, '/student/review');
                      },
                      child: VStack([
                        Text(
                          rating,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: RecallColors.green,
                          ),
                        ),
                        Muted(
                          {
                            'Học lại': '1 phút',
                            'Khó': '10 phút',
                            'Tốt': '1 ngày',
                            'Dễ': '4 ngày',
                          }[rating]!,
                          small: true,
                        ),
                      ]),
                    ),
                ],
                columns: 4,
                minWidth: 130,
                gap: 16,
              ),
            ActionGroup([
              RecallButton(
                '← Thẻ trước',
                outlined: true,
                onPressed: s.flashcards.length < 2
                    ? null
                    : () {
                        s.cardIndex =
                            (s.cardIndex - 1 + s.flashcards.length) %
                            s.flashcards.length;
                        s.update();
                        _refresh(() => flipped = false);
                      },
              ),
              RecallButton(
                'Thẻ tiếp →',
                outlined: true,
                onPressed: s.flashcards.length < 2
                    ? null
                    : () {
                        s.cardIndex = (s.cardIndex + 1) % s.flashcards.length;
                        s.update();
                        _refresh(() => flipped = false);
                      },
              ),
              RecallButton(
                'Về bộ thẻ',
                quiet: true,
                onPressed: () => go(context, '/student/decks'),
              ),
            ]),
            Muted(
              '${q.id} · ${q.topic} · ${q.page == null ? 'Chưa rõ trang' : 'Trang ${q.page}'} (mẫu)',
              small: true,
            ),
            if (c?.rating != null)
              Text(
                'Ôn tiếp: ${timeLabel(c!.due)} · ${c.rating}',
                style: const TextStyle(color: RecallColors.green),
              ),
          ], gap: 24),
        ),
      ),
    ], gap: 24);
  }
}
