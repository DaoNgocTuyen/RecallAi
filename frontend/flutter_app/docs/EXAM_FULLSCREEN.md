# Chế độ làm bài toàn màn hình

Áp dụng cho `/student/quiz`, gồm luyện tập và bài do giáo viên giao.

- Nút bắt đầu yêu cầu fullscreen trước khi mở bài trên Web.
- Không có sidebar, menu tài khoản, liên kết về xem trước hoặc điều hướng sang chức năng khác trong phiên thi.
- `PopScope` chặn Back trong ứng dụng khi chưa nộp. Hàm điều hướng `go()` cũng chặn chuyển trang khi `examInProgress` đang bật.
- Trên Web, `fullscreenchange` kiểm tra trạng thái thật. Khi thoát fullscreen, câu hỏi tạm ẩn; người học cần bấm nút vào lại để tiếp tục. Câu trả lời giữ nguyên trong bộ nhớ phiên.
- Nút Nộp bài mở xác nhận. Hủy xác nhận tiếp tục làm bài. Xác nhận mới ghi kết quả, mở khóa điều hướng, thoát fullscreen và thay route bài làm bằng route kết quả.
- Bài giáo viên giao không hiển thị nút điền đáp án mẫu trong câu tự luận.

## Các file chính

- `lib/screens/student/learning/widgets/focused_exam_scaffold.dart`: khung tập trung, chặn Back, màn hình yêu cầu fullscreen.
- `lib/screens/student/learning/exam_session_actions.dart`: bắt đầu và kết thúc phiên.
- `lib/screens/student/learning/active_recall_page.dart`: câu hỏi và xác nhận nộp bài.
- `lib/platform/exam_fullscreen/`: driver Web/Android, tách bằng conditional import.
- `test/exam_fullscreen_test.dart`: kiểm thử chặn thoát, khôi phục đáp án, từ chối fullscreen và nộp bài.
- `tool/exam_fullscreen_check.mjs`: kiểm tra thực tế bằng Edge/Playwright.
- `validation/exam-fullscreen/`: ảnh và kết quả kiểm tra trình duyệt.

## Giới hạn của nền tảng

Web không thể vô hiệu hóa Esc, đóng tab, đóng trình duyệt hoặc thao tác của hệ điều hành. Trình duyệt có thể từ chối fullscreen nếu không có thao tác người dùng hoặc không hỗ trợ API. Khi bị từ chối, app không mở nội dung bài và cho phép thử lại. `beforeunload` chỉ yêu cầu trình duyệt cảnh báo khi rời/tải lại trang; không bảo đảm giữ người dùng trên trang. Dữ liệu hiện vẫn ở bộ nhớ và sẽ mất nếu tải lại/đóng ứng dụng.

Android dùng toàn bộ vùng ứng dụng và yêu cầu immersive mode khi nền tảng cho phép. SDK/phiên bản Android có thể giữ thanh hệ thống (đặc biệt app target API 36); đây không phải chế độ kiosk hoặc khóa thiết bị. Không thay đổi target SDK để né chính sách hệ thống.

Nguồn API: [Fullscreen API](https://developer.mozilla.org/en-US/docs/Web/API/Fullscreen_API), [Flutter SystemChrome](https://api.flutter.dev/flutter/services/SystemChrome/setEnabledSystemUIMode.html).

Đã kiểm tra: 113 kiểm thử Flutter đạt, `flutter analyze` không có lỗi, build Web và APK debug Android thành công. Kiểm tra trình duyệt xác nhận bắt đầu fullscreen, thoát/quay lại giữ đáp án, hủy nộp không thoát, xác nhận nộp mới thoát fullscreen.
