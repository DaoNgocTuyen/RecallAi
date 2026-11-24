import 'package:flutter/material.dart';
import '../design/recall_theme.dart';
import '../models/demo_store.dart';
import 'helpers.dart';
import 'inputs.dart';
import 'layout.dart';

// Navigation data ─────────────────────────────────────────────────────────────

const studentNav = [
  ('Tổng quan', 'home', '/student/dashboard'),
  ('Tài liệu', 'file', '/student/documents'),
  ('Luyện tập AI', 'spark', '/student/studio'),
  ('Flashcard', 'cards', '/student/decks'),
  ('Lịch ôn tập', 'calendar', '/student/review'),
  ('Thống kê', 'chart', '/student/analytics'),
  ('Kế hoạch ôn thi', 'clock', '/student/planner'),
  ('Lớp học', 'cap', '/student/classes'),
  ('Cài đặt', 'settings', '/settings'),
];

const teacherNav = [
  ('Tổng quan', 'home', '/teacher/dashboard'),
  ('Lớp học', 'cap', '/teacher/classes'),
  ('Ngân hàng câu hỏi', 'book', '/teacher/questions'),
  ('Bài kiểm tra', 'file', '/teacher/quizzes'),
  ('Chấm điểm', 'check', '/teacher/grading'),
  ('Thống kê', 'chart', '/teacher/analytics'),
  ('Đề xuất ôn tập', 'spark', '/teacher/recommendations'),
  ('Cài đặt', 'settings', '/settings'),
];

// AppShell ────────────────────────────────────────────────────────────────────

/// Full-page scaffold with collapsible sidebar (desktop) or drawer + bottom
/// navigation (mobile). Used by both student and teacher flows.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.title,
    required this.child,
    this.teacher = false,
    this.active = 0,
    this.subtitle,
  });
  final String title;
  final Widget child;
  final bool teacher;
  final int active;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final store = DemoScope.of(context);
    final desktop = MediaQuery.sizeOf(context).width >= 1000;
    final nav = teacher ? teacherNav : studentNav;
    final routeSection =
        ModalRoute.of(context)?.settings.name?.split('/').last;
    final teacherScreen =
        const {
          'dashboard': 'T01',
          'classes': 'T02',
          'classroom': 'T03',
          'generate': 'T04',
          'questions': 'T05',
          'edit': 'T06',
          'builder': 'T07',
          'assign': 'T08',
          'quizzes': 'T09',
          'grading': 'T10',
          'analytics': 'T11',
          'recommendations': 'T12',
        }[routeSection] ??
        'T01';

    Widget sidebar({bool drawer = false}) => SizedBox(
      width: drawer || !store.sidebarCollapsed ? 248 : 80,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(right: BorderSide(color: RecallColors.border)),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: drawer || !store.sidebarCollapsed ? 24 : 16,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Logo ──
                Row(
                  children: [
                    const RecallRobot(size: 24),
                    if (drawer || !store.sidebarCollapsed) ...[
                      const SizedBox(width: 8),
                      const Text(
                        'RecallAI',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
                if (drawer || !store.sidebarCollapsed)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      teacher
                          ? 'KHÔNG GIAN GIÁO VIÊN'
                          : 'KHÔNG GIAN HỌC TẬP',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 10,
                      ),
                    ),
                  ),
                const SizedBox(height: 32),
                // ── Nav items ──
                for (var i = 0; i < nav.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: i == active
                          ? RecallColors.mint
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          if (drawer) Navigator.pop(context);
                          go(context, nav[i].$3);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              FigmaImage(
                                'imgBiuTng${nav[i].$2[0].toUpperCase()}${nav[i].$2.substring(1)}',
                                screen: teacher ? teacherScreen : 'S01',
                              ),
                              if (drawer || !store.sidebarCollapsed) ...[
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    nav[i].$1,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: teacher && i != active
                                          ? RecallColors.muted
                                          : RecallColors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                const Spacer(),
                // ── User card ──
                if (drawer || !store.sidebarCollapsed)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: RecallColors.background,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: VStack([
                      Text(
                        teacher ? 'Nguyễn Văn A' : store.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Muted(
                        teacher
                            ? 'Giáo viên · Cộng tác giảng dạy'
                            : 'Dữ liệu mẫu',
                        small: true,
                      ),
                    ], gap: 8),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      drawer: desktop ? null : Drawer(child: sidebar(drawer: true)),
      bottomNavigationBar: desktop || teacher
          ? null
          : NavigationBar(
              height: 72,
              selectedIndex: active == 0
                  ? 0
                  : active == 1
                  ? 1
                  : active == 2
                  ? 2
                  : active == 3 || active == 4
                  ? 3
                  : 4,
              onDestinationSelected: (i) => go(
                context,
                [
                  '/student/dashboard',
                  '/student/documents',
                  '/student/studio',
                  '/student/review',
                  '/settings',
                ][i],
              ),
              backgroundColor: Colors.white,
              indicatorColor: RecallColors.mint,
              destinations: const [
                NavigationDestination(
                  icon: FigmaImage('imgBiuTngHome'),
                  label: 'Tổng quan',
                ),
                NavigationDestination(
                  icon: FigmaImage('imgBiuTngFile'),
                  label: 'Tài liệu',
                ),
                NavigationDestination(
                  icon: FigmaImage('imgBiuTngSpark'),
                  label: 'Luyện tập',
                ),
                NavigationDestination(
                  icon: FigmaImage('imgBiuTngClock'),
                  label: 'Ôn tập',
                ),
                NavigationDestination(
                  icon: FigmaImage('imgBiuTngSettings'),
                  label: 'Cá nhân',
                ),
              ],
            ),
      body: Row(
        children: [
          if (desktop) sidebar(),
          Expanded(
            child: Column(
              children: [
                // ── Top bar ──
                Container(
                  height: desktop ? 80 : 64,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: RecallColors.border),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: desktop ? 24 : 12,
                  ),
                  child: Row(
                    children: [
                      Builder(
                        builder: (ctx) => IconButton(
                          tooltip: 'Menu',
                          onPressed: () {
                            if (desktop) {
                              store.sidebarCollapsed =
                                  !store.sidebarCollapsed;
                              store.update();
                            } else {
                              Scaffold.of(ctx).openDrawer();
                            }
                          },
                          icon: const Icon(Icons.menu, size: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          desktop
                              ? '${teacher ? 'Không gian giáo viên' : 'Sinh viên'} / $title'
                              : title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: desktop ? 14 : 16,
                            color: desktop
                                ? RecallColors.muted
                                : RecallColors.ink,
                            fontWeight: desktop
                                ? FontWeight.w400
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      if (desktop)
                        SizedBox(
                          width: 340,
                          child: InkWell(
                            onTap: () => _search(context),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: RecallColors.background,
                                border: Border.all(
                                  color: RecallColors.border,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  FigmaImage('imgBiuTngSearch'),
                                  SizedBox(width: 12),
                                  Flexible(
                                    child: Muted(
                                      'Tìm tài liệu, thẻ ghi nhớ…',
                                      small: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 16),
                      IconButton(
                        tooltip: 'Thông báo',
                        onPressed: () => recallDialog(
                          context,
                          'Thông báo',
                          const VStack([
                            Pill('24 thẻ cần ôn hôm nay'),
                            Text(
                              'Giáo viên nhắc ôn SQL JOIN trước bài kiểm tra.',
                            ),
                          ]),
                        ),
                        icon: FigmaImage(
                          'imgBiuTngBell',
                          screen: teacher ? teacherScreen : 'S01',
                          width: teacher ? 24 : 20,
                        ),
                      ),
                      PopupMenuButton<String>(
                        tooltip: 'Tài khoản',
                        onSelected: (v) {
                          if (v == 'teacher' || v == 'student') {
                            store.setRole(v == 'teacher');
                            go(context, '/$v/dashboard');
                          } else {
                            go(context, v);
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: '/settings',
                            child: Text('Cài đặt tài khoản'),
                          ),
                          PopupMenuItem(
                            value: 'student',
                            child: Text('Giao diện sinh viên'),
                          ),
                          PopupMenuItem(
                            value: 'teacher',
                            child: Text('Giao diện giáo viên'),
                          ),
                          PopupMenuItem(
                            value: '/login',
                            child: Text('Đăng xuất'),
                          ),
                        ],
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: RecallColors.mint,
                          child: Text(
                            teacher ? 'NA' : 'MA',
                            style: const TextStyle(
                              fontSize: 12,
                              color: RecallColors.ink,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ── Page content ──
                Expanded(
                  child: SingleChildScrollView(
                    key: PageStorageKey(title),
                    padding: EdgeInsets.all(desktop ? 32 : 24),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1128),
                        child: SizedBox(
                          width: double.infinity,
                          child: VStack([
                            Text(
                              title,
                              style: desktop
                                  ? Theme.of(
                                      context,
                                    ).textTheme.headlineLarge
                                  : Theme.of(
                                      context,
                                    ).textTheme.headlineMedium,
                            ),
                            if (subtitle != null) Muted(subtitle!),
                            child,
                          ], gap: 24),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _search(BuildContext context) => recallDialog(
    context,
    'Tìm trong không gian học tập',
    VStack([
      const RecallField('Từ khóa', hint: 'Tìm tài liệu, bộ thẻ…'),
      for (final (label, route) in [
        ('Cơ sở dữ liệu.pdf', '/student/pdf'),
        ('Thuật ngữ Cơ sở dữ liệu', '/student/decks'),
        ('Kiểm tra chương 2 – SQL', '/student/classes'),
      ])
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(label),
          trailing: const Icon(Icons.arrow_forward, size: 18),
          onTap: () {
            Navigator.pop(context);
            go(context, route);
          },
        ),
    ]),
  );
}
