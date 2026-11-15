# RecallAI — Flutter frontend

Giao diện RecallAI chuyển từ [thiết kế Figma](https://www.figma.com/design/jtdPE6oTE3hNoAOn3FTbOS/Untitled?node-id=0-1) sang **Flutter / Dart**, có bố cục desktop và điện thoại, font Inter và tài nguyên Figma lưu cục bộ.

## Chạy dự án

Yêu cầu Flutter 3.38 trở lên / Dart 3.10 trở lên. Bản này được kiểm tra với Flutter 3.38.3 và Dart 3.10.1.

```powershell
cd frontend/flutter_app
flutter pub get
flutter run -d chrome
```

Chạy trên thiết bị Android đã cấu hình:

```powershell
flutter devices
flutter run -d <device-id>
```

Build web:

```powershell
flutter build web --release --no-web-resources-cdn
```

Bản web nằm trong `build/web`. Tùy chọn trên đóng gói tài nguyên renderer tại chỗ; giao diện không tải font Inter hay ảnh Figma từ URL tạm khi chạy.

## Phần giao diện đã chuyển

- Splash, giới thiệu, đăng nhập/đăng ký, chọn vai trò.
- Sinh viên: tổng quan, tài liệu, nhập PDF/văn bản mẫu, AI Learning Studio, PDF workspace, cấu hình/xem trước câu hỏi, làm quiz, kết quả/phân tích lỗi, flashcard, lịch ôn, thống kê, kế hoạch ôn thi, lớp học và bài giáo viên giao.
- Giáo viên: tổng quan, danh sách/chi tiết lớp, tạo câu hỏi, ngân hàng/biên tập câu hỏi, tạo/giao/quản lý bài kiểm tra, chấm điểm, thống kê và đề xuất ôn tập.
- Sidebar thu gọn trên desktop; drawer và thanh điều hướng trên điện thoại. Form nhập, bộ lọc, modal, trạng thái trống/lỗi/loading và điều hướng dùng widget Flutter.

[Đối chiếu 51 frame thiết kế với route Flutter](docs/FIGMA_SCREEN_MAP.md).

## Cấu trúc mã nguồn

```text
lib/
  main.dart                  # Khởi động, nạp manifest asset cục bộ
  recall_app.dart            # Theme, tiếng Việt, route
  design/recall_theme.dart   # Màu, chữ Inter và asset gốc Figma
  widgets/recall_widgets.dart# Button, card, bố cục, sidebar, biểu đồ
  models/demo_store.dart     # Dữ liệu và trạng thái giao diện mẫu
  screens/
    auth/                    # Login, register, onboarding, role selection
    student/                 # Documents, learning, flashcards, review, classes
    teacher/                 # Classes, questions, exams, grading, analytics
    settings/                # Account, preferences, navigation
assets/
  figma/                     # Ảnh/SVG gốc, không dùng screenshot cả màn hình
  fonts/                     # Inter và giấy phép OFL
  design_assets.json         # Asset theo frame Figma
```

## Phạm vi frontend

**Chưa có backend RecallAI.** Không gọi API, không xác thực thật, không gửi email, không xử lý PDF hay gọi AI. Nút Google chỉ mở luồng giao diện mẫu. Chọn PDF dùng tệp minh họa; các đáp án/diễn giải là fixture có sẵn.

`DemoStore` chỉ giữ trạng thái trong bộ nhớ để xem giao diện: chọn đáp án, kết quả, tạo thẻ, lịch mẫu, bài giao và biểu mẫu. Refresh hoặc chạy lại app sẽ trở về dữ liệu ban đầu. Một số biểu mẫu quản lý chỉ phục vụ trình diễn; backend sau này sẽ thay phần dữ liệu này.

Ngày/giờ trong lịch là dữ liệu minh họa 12/11/2026, không phải lịch nhắc chạy thật. Ví dụ ban đầu có 7/10 đúng, 3 câu SQL JOIN sai, đạt 70%. Tạo thẻ rồi chọn **Khó** sẽ hiển thị mốc ôn mẫu **12/11/2026 · 09:10**.

Không có thay đổi dữ liệu trong file Figma khi chạy frontend. Bản React/Vite cũ được giữ tại `../react_reference`. Thư mục dành cho backend tương lai là `../../backend/recallai`.

## Kiểm tra

```powershell
flutter analyze
flutter test
```

Các bài kiểm tra dựng màn hình ở 1440px và 390px, kiểm tra lỗi layout và dữ liệu mẫu của luồng quiz → flashcard → lịch ôn. Ảnh kiểm tra bản web có trong `validation/`.


Hướng dẫn tìm và sửa từng chức năng: [lib/screens/README.md](lib/screens/README.md).
