# Tạo đề kiểm tra – RecallAI

Vào **Giáo viên → Bài kiểm tra → Tạo bài kiểm tra**.

- `/teacher/builder`: chọn tệp hoặc chọn cách tạo đề Online/Offline.
- `/teacher/exam-config`: tên đề, khối học, môn học, mục đích, cấu hình giá và mô tả.
- `/teacher/exam-success`: tiếp tục biên tập câu hỏi, giao cho lớp, xem cấu trúc, xem trước đề/slide.
- `/teacher/exam-settings`: thời gian/lượt làm, đảo câu, bàn phím, công bố điểm/đáp án, thông báo.
- `/teacher/editor`: trình biên tập câu hỏi có sẵn được giữ nguyên và nối vào luồng mới.

Thông tin đề và cài đặt lưu riêng theo mã đề trong bộ nhớ của phiên ứng dụng. Refresh/đóng ứng dụng sẽ xóa dữ liệu này. Hủy cài đặt không thay đổi bản đã lưu.

Chọn tệp/kéo thả thực tế trên web, chọn tệp trên Android; kiểm tra định dạng và giới hạn 50 MB. Chỉ giữ tên tệp trong giao diện, chưa gửi máy chủ hoặc tự nhập nội dung. Các tùy chọn nâng cao, giá, in đề và PowerPoint là cấu hình/bản xem trước mô phỏng. Không có thanh toán, OCR, xuất DOCX/PDF/PPTX hoặc link thi công khai.

Kiểm tra: `flutter test`, `flutter analyze`, `flutter build web --release --no-web-resources-cdn`.

Ảnh kiểm tra trình duyệt: `validation/exam-creation/`.
