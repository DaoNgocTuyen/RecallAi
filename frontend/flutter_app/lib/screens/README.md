# Cấu trúc giao diện RecallAI

Mở thư mục `frontend/flutter_app` bằng VS Code. Giao diện được chia theo vai trò và chức năng, không còn nằm trong 5 file lớn.

```text
lib/screens/
├── auth/
│   ├── auth_screen.dart             # Khung responsive và điều hướng xác thực
│   ├── splash/                     # Màn hình khởi đầu
│   ├── onboarding/                 # Giới thiệu ứng dụng
│   ├── login/                      # Đăng nhập
│   ├── register/                   # Đăng ký
│   ├── role_selection/             # Chọn vai trò và thẻ vai trò
│   └── widgets/credentials_form.dart# Form dùng chung cho Login/Register
├── student/
│   ├── student_screen.dart          # Điều hướng và trạng thái giao diện sinh viên
│   ├── dashboard/                   # Tổng quan học tập
│   ├── documents/                   # Thư viện tài liệu, xem PDF
│   ├── learning/                    # Studio, tạo câu hỏi, làm bài, kết quả, lỗi sai
│   ├── flashcards/                  # Bộ thẻ, tạo/sửa thẻ, lật thẻ
│   ├── review/                      # Lịch ôn tập
│   ├── analytics/                   # Thống kê học tập
│   ├── planner/                     # Lập kế hoạch và sửa nhiệm vụ
│   ├── classrooms/                  # Lớp học và bài giáo viên giao
│   └── widgets/                     # Điều khiển dùng trong nhóm sinh viên
├── teacher/
│   ├── teacher_screen.dart          # Điều hướng và trạng thái giao diện giáo viên
│   ├── dashboard/                   # Tổng quan giảng dạy
│   ├── classrooms/                  # Tạo lớp, danh sách lớp, chi tiết lớp
│   ├── questions/                   # Tạo câu hỏi AI, ngân hàng, sửa câu hỏi
│   ├── exams/
│   │   ├── creation/
│   │   │   ├── exam_creation_screen.dart # Điều hướng luồng tạo đề
│   │   │   ├── pages/               # Chọn cách tạo, thông tin, thành công, cài đặt
│   │   │   └── widgets/             # Kéo thả/chọn tệp và biểu mẫu dùng chung
│   │   ├── editor/                  # Chọn câu hỏi, cấu hình, xem trước đề
│   │   ├── assignments/             # Giao đề cho lớp và xác nhận
│   │   └── management/              # Danh sách, tìm kiếm, mở đề
│   ├── grading/                     # Chấm điểm, công bố kết quả
│   ├── analytics/                   # Thống kê giảng dạy
│   ├── recommendations/             # Đề xuất ôn tập và duyệt hoạt động
│   └── widgets/                     # Bảng dữ liệu và nhãn loại câu hỏi
└── settings/
    ├── settings_screen.dart         # Trang cài đặt chung
    └── widgets/                     # Tài khoản, tùy chọn học tập, vai trò/đăng xuất
```

## Muốn sửa chức năng nào thì mở file nào?

| Chức năng | File trong `lib/screens/` |
|---|---|
| Form đăng nhập, đăng ký | `auth/widgets/credentials_form.dart` |
| Chọn vai trò | `auth/role_selection/role_selection_page.dart` |
| Thẻ học sinh/giáo viên | `auth/role_selection/widgets/role_card.dart` |
| Thư viện tài liệu | `student/documents/document_library_page.dart` |
| Xem PDF | `student/documents/pdf_viewer_page.dart` |
| AI Learning Studio | `student/learning/learning_studio_page.dart` |
| Tạo bài luyện tập | `student/learning/question_generator_page.dart` |
| Làm bài Active Recall | `student/learning/active_recall_page.dart` |
| Kết quả luyện tập | `student/learning/quiz_results_page.dart` |
| Giải thích lỗi sai | `student/learning/mistake_analysis_page.dart` |
| Tạo/sửa flashcard | `student/flashcards/flashcard_editor.dart` |
| Ôn flashcard | `student/flashcards/flashcard_review_page.dart` |
| Lịch ôn tập | `student/review/review_calendar_page.dart` |
| Kế hoạch học tập | `student/planner/study_planner_page.dart` |
| Bài kiểm tra được giao | `student/classrooms/assigned_quiz_page.dart` |
| Ngân hàng câu hỏi giáo viên | `teacher/questions/question_bank_page.dart` |
| Sửa câu hỏi | `teacher/questions/question_editor_page.dart` |
| Chọn cách tạo đề | `teacher/exams/creation/pages/create_exam_page.dart` |
| Cấu hình chung của đề | `teacher/exams/creation/pages/exam_configuration_page.dart` |
| Tạo đề thành công | `teacher/exams/creation/pages/exam_created_page.dart` |
| Cài đặt làm bài online | `teacher/exams/creation/pages/exam_settings_page.dart` |
| Chọn/kéo thả tệp | `teacher/exams/creation/widgets/file_upload_panel.dart` |
| Biên tập đề | `teacher/exams/editor/exam_editor_page.dart` |
| Giao bài | `teacher/exams/assignments/assign_exam_page.dart` |
| Quản lý đề | `teacher/exams/management/exams_page.dart` |
| Chấm điểm | `teacher/grading/grading_page.dart` |
| Cài đặt tài khoản | `settings/widgets/account_settings_card.dart` |

## Cách các file liên kết với nhau

- `lib/recall_app.dart` vẫn là nơi định tuyến chính. URL và tên route giữ nguyên.
- Các file tổng `auth_screen.dart`, `student_screen.dart`, `teacher_screen.dart`, `exam_creation_screen.dart` giữ trạng thái và chọn chức năng theo route; không chứa toàn bộ giao diện các chức năng nữa.
- Các file chức năng có `part of` và `extension` chứa UI/callback thực tế. Chúng dùng chung trạng thái của file tổng để giữ nguyên hành vi hiện tại. Không import trực tiếp một file `part of`; import file tổng của nhóm. Nếu cần thêm thư viện cho chức năng, thêm `import` vào file tổng tương ứng.
- Login và Register dùng cùng form trong `auth/widgets/credentials_form.dart` để tránh lặp phần nhập liệu, kiểm tra và điều hướng. Hai thư mục `login/`, `register/` là điểm vào riêng.
- `settings/widgets/` và `teacher/widgets/recall_table.dart` là widget độc lập, có thể import trực tiếp.
- Component dùng chung toàn ứng dụng vẫn ở `lib/widgets/`; màu, font và asset ở `lib/design/`; dữ liệu mẫu ở `lib/models/`.

Sau khi đổi cấu trúc, dừng và chạy lại `flutter run` để nạp đường dẫn mới.
