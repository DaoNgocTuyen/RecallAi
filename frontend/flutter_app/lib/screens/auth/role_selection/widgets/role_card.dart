part of '../../auth_screen.dart';

// UI and actions for this feature; navigation state is owned by the screen.
extension _AuthRoleCardView on _AuthScreenState {
  Widget _roleCard(
    bool value,
    String title,
    String description,
    String symbol,
  ) => RecallCard(
    color: teacher == value ? RecallColors.mint : Colors.white,
    onTap: () => _refresh(() => teacher = value),
    child: VStack([
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FigmaImage(symbol, screen: 'M04', width: 28),
          SizedBox(
            width: 24,
            height: 24,
            child: Stack(
              alignment: Alignment.center,
              children: [
                FigmaImage(
                  teacher == value ? 'imgEllipse' : 'imgEllipse1',
                  screen: 'M04',
                  width: 24,
                ),
                if (teacher == value)
                  const FigmaImage('imgIconCheck', screen: 'M04', width: 16),
              ],
            ),
          ),
        ],
      ),
      SectionTitle(title),
      Muted(description),
    ]),
  );
}
