import type { Question } from '../types';
export const questionBank: Question[] = [
  {
    "id": "Q-CSDL-01",
    "prompt": "Khóa chính trong một bảng có vai trò gì?",
    "statement": "Khóa chính xác định duy nhất từng bản ghi.",
    "options": [
      "Định danh duy nhất một bản ghi",
      "Sắp xếp bản ghi theo tên",
      "Lưu trữ mọi giá trị trùng nhau",
      "Mã hóa toàn bộ dữ liệu"
    ],
    "mcOptions": [
      "Định danh duy nhất một bản ghi",
      "Sắp xếp bản ghi theo tên",
      "Lưu trữ mọi giá trị trùng nhau",
      "Mã hóa toàn bộ dữ liệu"
    ],
    "correct": 0,
    "mcCorrect": 0,
    "truth": true,
    "expected": "Định danh duy nhất một bản ghi",
    "explanation": "Khóa chính xác định duy nhất từng dòng trong bảng. Giá trị khóa chính không được trùng lặp và không được NULL.",
    "topic": "Khóa và ràng buộc",
    "page": 12,
    "type": "mc",
    "points": 1,
    "approved": true,
    "sourceId": "DOC-CSDL-001"
  },
  {
    "id": "Q-CSDL-02",
    "prompt": "Đúng hay sai? Khóa ngoại luôn phải là duy nhất trong bảng chứa nó.",
    "statement": "Khóa ngoại luôn phải là duy nhất trong bảng chứa nó.",
    "options": [
      "Đúng",
      "Sai"
    ],
    "mcOptions": [
      "Nén dữ liệu",
      "Liên kết dữ liệu giữa các bảng",
      "Sắp xếp dữ liệu",
      "Xóa toàn bộ dữ liệu"
    ],
    "correct": 1,
    "mcCorrect": 1,
    "truth": false,
    "expected": "Liên kết dữ liệu giữa các bảng",
    "explanation": "Khóa ngoại tham chiếu tới khóa của bảng khác để tạo quan hệ. Nhiều dòng có thể dùng cùng một giá trị khóa ngoại.",
    "topic": "Khóa và ràng buộc",
    "page": 13,
    "type": "tf",
    "points": 1,
    "approved": true,
    "sourceId": "DOC-CSDL-001"
  },
  {
    "id": "Q-CSDL-03",
    "prompt": "NULL thường biểu thị điều gì?",
    "statement": "NULL luôn đồng nghĩa với số 0.",
    "options": [
      "Số 0",
      "Chuỗi rỗng",
      "Giá trị chưa biết hoặc không có",
      "Giá trị lớn nhất"
    ],
    "mcOptions": [
      "Số 0",
      "Chuỗi rỗng",
      "Giá trị chưa biết hoặc không có",
      "Giá trị lớn nhất"
    ],
    "correct": 2,
    "mcCorrect": 2,
    "truth": false,
    "expected": "Giá trị chưa biết hoặc không có",
    "explanation": "NULL biểu thị giá trị thiếu hoặc chưa biết. Nó khác số 0 và chuỗi rỗng; nên kiểm tra bằng IS NULL.",
    "topic": "Dữ liệu và NULL",
    "page": 16,
    "type": "short",
    "points": 1,
    "approved": true,
    "sourceId": "DOC-CSDL-001"
  },
  {
    "id": "Q-CSDL-04",
    "prompt": "Lệnh nào lấy dữ liệu từ một bảng?",
    "statement": "SELECT dùng để truy vấn dữ liệu.",
    "options": [
      "SELECT",
      "DELETE",
      "DROP",
      "UPDATE"
    ],
    "mcOptions": [
      "SELECT",
      "DELETE",
      "DROP",
      "UPDATE"
    ],
    "correct": 0,
    "mcCorrect": 0,
    "truth": true,
    "expected": "SELECT",
    "explanation": "SELECT dùng để chọn dữ liệu. WHERE lọc các dòng, còn ORDER BY sắp xếp kết quả truy vấn.",
    "topic": "Truy vấn SQL",
    "page": 19,
    "type": "mc",
    "points": 1,
    "approved": true,
    "sourceId": "DOC-CSDL-001"
  },
  {
    "id": "Q-CSDL-05",
    "prompt": "Đúng hay sai? WHERE dùng để sắp xếp các dòng trong kết quả.",
    "statement": "WHERE dùng để sắp xếp các dòng trong kết quả.",
    "options": [
      "Đúng",
      "Sai"
    ],
    "mcOptions": [
      "Tạo bảng mới",
      "Đặt khóa chính",
      "Sắp xếp kết quả",
      "Lọc các bản ghi theo điều kiện"
    ],
    "correct": 1,
    "mcCorrect": 3,
    "truth": false,
    "expected": "Lọc các bản ghi theo điều kiện",
    "explanation": "WHERE lọc các dòng thỏa điều kiện. ORDER BY mới là mệnh đề dùng để sắp xếp kết quả.",
    "topic": "Truy vấn SQL",
    "page": 20,
    "type": "tf",
    "points": 1,
    "approved": true,
    "sourceId": "DOC-CSDL-001"
  },
  {
    "id": "Q-CSDL-06",
    "prompt": "INNER JOIN trả về những dòng nào?",
    "statement": "INNER JOIN chỉ trả về các dòng khớp điều kiện nối.",
    "options": [
      "Mọi dòng ở cả hai bảng",
      "Những dòng khớp điều kiện nối",
      "Chỉ những dòng không khớp",
      "Chỉ dòng đầu tiên"
    ],
    "mcOptions": [
      "Mọi dòng ở cả hai bảng",
      "Những dòng khớp điều kiện nối",
      "Chỉ những dòng không khớp",
      "Chỉ dòng đầu tiên"
    ],
    "correct": 1,
    "mcCorrect": 1,
    "truth": true,
    "expected": "Những dòng khớp điều kiện nối",
    "explanation": "INNER JOIN giữ các cặp dòng thỏa điều kiện nối giữa hai bảng. Các dòng không có cặp khớp không xuất hiện.",
    "topic": "SQL JOIN",
    "page": 24,
    "type": "mc",
    "points": 1,
    "approved": false,
    "sourceId": "DOC-CSDL-001"
  },
  {
    "id": "Q-CSDL-07",
    "prompt": "Đúng hay sai? LEFT JOIN chỉ giữ các dòng có khóa khớp ở cả hai bảng.",
    "statement": "LEFT JOIN chỉ giữ các dòng có khóa khớp ở cả hai bảng.",
    "options": [
      "Đúng",
      "Sai"
    ],
    "mcOptions": [
      "Chỉ các dòng khớp ở cả hai bảng",
      "Toàn bộ dòng bên trái, kể cả khi không khớp",
      "Chỉ các dòng bên phải",
      "Chỉ dòng cuối cùng"
    ],
    "correct": 1,
    "mcCorrect": 1,
    "truth": false,
    "expected": "Toàn bộ dòng bên trái, kể cả khi không khớp",
    "explanation": "LEFT JOIN giữ toàn bộ dòng của bảng trái. Nếu không có dòng khớp bên phải, các cột phía phải nhận giá trị NULL.",
    "topic": "SQL JOIN",
    "page": 24,
    "type": "tf",
    "points": 1,
    "approved": false,
    "sourceId": "DOC-CSDL-001"
  },
  {
    "id": "Q-CSDL-08",
    "prompt": "Điều kiện ON trong JOIN dùng để làm gì?",
    "statement": "ON xác định điều kiện ghép các dòng của hai bảng.",
    "options": [
      "Xác định điều kiện ghép các dòng giữa hai bảng",
      "Sắp xếp kết quả theo tên",
      "Xóa các dòng trùng",
      "Tạo một bảng mới"
    ],
    "mcOptions": [
      "Xác định điều kiện ghép các dòng giữa hai bảng",
      "Sắp xếp kết quả theo tên",
      "Xóa các dòng trùng",
      "Tạo một bảng mới"
    ],
    "correct": 0,
    "mcCorrect": 0,
    "truth": true,
    "expected": "Xác định điều kiện ghép các dòng giữa hai bảng",
    "explanation": "ON mô tả điều kiện nối, chẳng hạn SinhVien.LopId = Lop.Id. Nó xác định các cặp dòng được ghép; ORDER BY dùng để sắp xếp.",
    "topic": "SQL JOIN",
    "page": 24,
    "type": "short",
    "points": 1,
    "approved": false,
    "sourceId": "DOC-CSDL-001"
  },
  {
    "id": "Q-CSDL-09",
    "prompt": "SQL là tên viết tắt của cụm từ nào?",
    "statement": "SQL là ngôn ngữ truy vấn có cấu trúc.",
    "options": [
      "Simple Query List",
      "Sequential Question Logic",
      "Structured Query Language",
      "Standard Queue Layer"
    ],
    "mcOptions": [
      "Simple Query List",
      "Sequential Question Logic",
      "Structured Query Language",
      "Standard Queue Layer"
    ],
    "correct": 2,
    "mcCorrect": 2,
    "truth": true,
    "expected": "Structured Query Language",
    "explanation": "SQL viết tắt của Structured Query Language. Ngôn ngữ này hỗ trợ định nghĩa, truy vấn và thao tác dữ liệu quan hệ.",
    "topic": "Truy vấn SQL",
    "page": 18,
    "type": "mc",
    "points": 1,
    "approved": false,
    "sourceId": "DOC-CSDL-001"
  },
  {
    "id": "Q-CSDL-10",
    "prompt": "UNIQUE thể hiện ràng buộc nào?",
    "statement": "UNIQUE được dùng để hạn chế giá trị trùng lặp.",
    "options": [
      "Mọi giá trị phải bằng nhau",
      "Các giá trị không được trùng lặp",
      "Mọi giá trị là số",
      "Cột không được sử dụng"
    ],
    "mcOptions": [
      "Mọi giá trị phải bằng nhau",
      "Các giá trị không được trùng lặp",
      "Mọi giá trị là số",
      "Cột không được sử dụng"
    ],
    "correct": 1,
    "mcCorrect": 1,
    "truth": true,
    "expected": "Các giá trị không được trùng lặp",
    "explanation": "UNIQUE bảo đảm tính duy nhất của các giá trị trong cột hoặc nhóm cột. Cách xử lý NULL có thể khác nhau giữa các hệ quản trị.",
    "topic": "Khóa và ràng buộc",
    "page": 14,
    "type": "mc",
    "points": 1,
    "approved": false,
    "sourceId": "DOC-CSDL-001"
  },
  {
    "id": "Q-CSDL-11",
    "prompt": "COUNT(*) trả về giá trị gì?",
    "statement": "COUNT(*) đếm số dòng trong tập kết quả.",
    "options": [
      "Giá trị lớn nhất",
      "Tổng giá trị một cột",
      "Số dòng của tập kết quả",
      "Độ dài chuỗi"
    ],
    "mcOptions": [
      "Giá trị lớn nhất",
      "Tổng giá trị một cột",
      "Số dòng của tập kết quả",
      "Độ dài chuỗi"
    ],
    "correct": 2,
    "mcCorrect": 2,
    "truth": true,
    "expected": "Số dòng của tập kết quả",
    "explanation": "COUNT(*) đếm mọi dòng trong tập kết quả, kể cả khi một số cột của dòng có giá trị NULL.",
    "topic": "Hàm tổng hợp",
    "page": null,
    "type": "mc",
    "points": 1,
    "approved": false,
    "sourceId": "DOC-CSDL-001"
  },
  {
    "id": "Q-CSDL-12",
    "prompt": "Đúng hay sai? GROUP BY luôn thay thế được WHERE.",
    "statement": "GROUP BY luôn thay thế được WHERE.",
    "options": [
      "Đúng",
      "Sai"
    ],
    "mcOptions": [
      "Nhóm dữ liệu để tính tổng hợp",
      "Tạo mật khẩu",
      "Xóa chỉ mục",
      "Đổi tên cơ sở dữ liệu"
    ],
    "correct": 1,
    "mcCorrect": 0,
    "truth": false,
    "expected": "Nhóm dữ liệu để tính tổng hợp",
    "explanation": "GROUP BY gom các dòng có cùng giá trị nhóm để tính các hàm tổng hợp. Nó không thay thế vai trò lọc dòng của WHERE.",
    "topic": "Hàm tổng hợp",
    "page": null,
    "type": "tf",
    "points": 1,
    "approved": false,
    "sourceId": "DOC-CSDL-001"
  },
  {
    "id": "Q-CSDL-13",
    "prompt": "Chuẩn hóa dữ liệu giúp ích điều gì?",
    "statement": "Chuẩn hóa giúp giảm dư thừa dữ liệu.",
    "options": [
      "Nhân bản mọi dữ liệu",
      "Loại bỏ mọi quan hệ",
      "Tăng kích thước bảng",
      "Giảm dư thừa và bất thường cập nhật"
    ],
    "mcOptions": [
      "Nhân bản mọi dữ liệu",
      "Loại bỏ mọi quan hệ",
      "Tăng kích thước bảng",
      "Giảm dư thừa và bất thường cập nhật"
    ],
    "correct": 3,
    "mcCorrect": 3,
    "truth": true,
    "expected": "Giảm dư thừa và bất thường cập nhật",
    "explanation": "Chuẩn hóa tổ chức dữ liệu thành các quan hệ phù hợp để hạn chế dư thừa và các bất thường khi thêm, sửa hoặc xóa.",
    "topic": "Chuẩn hóa",
    "page": null,
    "type": "short",
    "points": 1,
    "approved": false,
    "sourceId": "DOC-CSDL-001"
  },
  {
    "id": "Q-CSDL-14",
    "prompt": "Một thuộc tính nguyên tố có đặc điểm gì?",
    "statement": "Thuộc tính nguyên tố phải có kiểu dữ liệu số nguyên.",
    "options": [
      "Chỉ chứa số nguyên",
      "Thuộc ít nhất một khóa ứng viên",
      "Luôn cho phép NULL",
      "Không thuộc bảng nào"
    ],
    "mcOptions": [
      "Chỉ chứa số nguyên",
      "Thuộc ít nhất một khóa ứng viên",
      "Luôn cho phép NULL",
      "Không thuộc bảng nào"
    ],
    "correct": 1,
    "mcCorrect": 1,
    "truth": false,
    "expected": "Thuộc ít nhất một khóa ứng viên",
    "explanation": "Thuộc tính nguyên tố là thuộc tính thuộc ít nhất một khóa ứng viên. Khái niệm này không phụ thuộc vào kiểu dữ liệu.",
    "topic": "Chuẩn hóa",
    "page": null,
    "type": "mc",
    "points": 1,
    "approved": false,
    "sourceId": "DOC-CSDL-001"
  },
  {
    "id": "Q-CSDL-15",
    "prompt": "Đúng hay sai? Atomicity bảo đảm giao dịch được thực hiện toàn bộ hoặc không thực hiện.",
    "statement": "Atomicity bảo đảm giao dịch được thực hiện toàn bộ hoặc không thực hiện.",
    "options": [
      "Đúng",
      "Sai"
    ],
    "mcOptions": [
      "Consistency",
      "Isolation",
      "Atomicity",
      "Durability"
    ],
    "correct": 0,
    "mcCorrect": 2,
    "truth": true,
    "expected": "Atomicity",
    "explanation": "Atomicity là tính nguyên tử: mọi thao tác của giao dịch cùng thành công hoặc các thay đổi được hoàn tác.",
    "topic": "Giao dịch",
    "page": null,
    "type": "tf",
    "points": 1,
    "approved": false,
    "sourceId": "DOC-CSDL-001"
  },
  {
    "id": "Q-CSDL-16",
    "prompt": "COMMIT có tác dụng gì?",
    "statement": "COMMIT hoàn tác mọi thay đổi chưa lưu.",
    "options": [
      "Xác nhận thay đổi của giao dịch",
      "Hủy bỏ giao dịch",
      "Tạo chỉ mục",
      "Xóa bảng"
    ],
    "mcOptions": [
      "Xác nhận thay đổi của giao dịch",
      "Hủy bỏ giao dịch",
      "Tạo chỉ mục",
      "Xóa bảng"
    ],
    "correct": 0,
    "mcCorrect": 0,
    "truth": false,
    "expected": "Xác nhận thay đổi của giao dịch",
    "explanation": "COMMIT xác nhận các thay đổi của giao dịch. ROLLBACK mới là thao tác hoàn tác các thay đổi chưa được xác nhận.",
    "topic": "Giao dịch",
    "page": null,
    "type": "short",
    "points": 1,
    "approved": false,
    "sourceId": "DOC-CSDL-001"
  },
  {
    "id": "Q-CSDL-17",
    "prompt": "Chỉ mục thường có lợi ích nào?",
    "statement": "Chỉ mục có thể tăng tốc truy vấn nhưng tốn chi phí cập nhật.",
    "options": [
      "Bảo đảm không có lỗi cú pháp",
      "Thay thế mọi khóa ngoại",
      "Giảm số lượng bảng",
      "Tăng tốc một số truy vấn"
    ],
    "mcOptions": [
      "Bảo đảm không có lỗi cú pháp",
      "Thay thế mọi khóa ngoại",
      "Giảm số lượng bảng",
      "Tăng tốc một số truy vấn"
    ],
    "correct": 3,
    "mcCorrect": 3,
    "truth": true,
    "expected": "Tăng tốc một số truy vấn",
    "explanation": "Chỉ mục hỗ trợ tìm kiếm nhanh hơn trong nhiều truy vấn, nhưng cần dung lượng và chi phí duy trì khi dữ liệu thay đổi.",
    "topic": "Chỉ mục",
    "page": null,
    "type": "mc",
    "points": 1,
    "approved": false,
    "sourceId": "DOC-CSDL-001"
  },
  {
    "id": "Q-CSDL-18",
    "prompt": "Đúng hay sai? DELETE có thể xóa các dòng mà vẫn giữ cấu trúc bảng.",
    "statement": "DELETE có thể xóa các dòng mà vẫn giữ cấu trúc bảng.",
    "options": [
      "Đúng",
      "Sai"
    ],
    "mcOptions": [
      "DELETE xóa dòng, DROP TABLE xóa bảng",
      "DELETE luôn xóa cơ sở dữ liệu",
      "Hai lệnh hoàn toàn giống nhau",
      "DROP TABLE chỉ lọc dữ liệu"
    ],
    "correct": 0,
    "mcCorrect": 0,
    "truth": true,
    "expected": "DELETE xóa dòng, DROP TABLE xóa bảng",
    "explanation": "DELETE loại bỏ các dòng, có thể kèm điều kiện WHERE. DROP TABLE loại bỏ đối tượng bảng và cấu trúc của nó.",
    "topic": "Thao tác dữ liệu",
    "page": 22,
    "type": "tf",
    "points": 1,
    "approved": false,
    "sourceId": "DOC-CSDL-001"
  },
  {
    "id": "Q-CSDL-19",
    "prompt": "HAVING thường lọc dữ liệu ở cấp độ nào?",
    "statement": "HAVING có thể lọc các nhóm theo giá trị tổng hợp.",
    "options": [
      "Tệp PDF",
      "Cột chưa có trong bảng",
      "Chỉ mục",
      "Nhóm sau khi tổng hợp"
    ],
    "mcOptions": [
      "Tệp PDF",
      "Cột chưa có trong bảng",
      "Chỉ mục",
      "Nhóm sau khi tổng hợp"
    ],
    "correct": 3,
    "mcCorrect": 3,
    "truth": true,
    "expected": "Nhóm sau khi tổng hợp",
    "explanation": "HAVING lọc các nhóm, thường dùng với GROUP BY và điều kiện chứa hàm tổng hợp. WHERE lọc dòng trước khi nhóm.",
    "topic": "Hàm tổng hợp",
    "page": null,
    "type": "short",
    "points": 1,
    "approved": false,
    "sourceId": "DOC-CSDL-001"
  },
  {
    "id": "Q-CSDL-20",
    "prompt": "Quan hệ một-nhiều có đặc điểm gì?",
    "statement": "Quan hệ một-nhiều yêu cầu hai bảng có cùng số dòng.",
    "options": [
      "Mỗi dòng chỉ có một ký tự",
      "Một dòng bên một liên quan nhiều dòng bên nhiều",
      "Không có khóa ngoại",
      "Hai bảng luôn có cùng số dòng"
    ],
    "mcOptions": [
      "Mỗi dòng chỉ có một ký tự",
      "Một dòng bên một liên quan nhiều dòng bên nhiều",
      "Không có khóa ngoại",
      "Hai bảng luôn có cùng số dòng"
    ],
    "correct": 1,
    "mcCorrect": 1,
    "truth": false,
    "expected": "Một dòng bên một liên quan nhiều dòng bên nhiều",
    "explanation": "Một bản ghi ở phía một có thể liên quan nhiều bản ghi ở phía nhiều. Khóa ngoại thường đặt ở phía nhiều.",
    "topic": "Mô hình quan hệ",
    "page": 9,
    "type": "mc",
    "points": 1,
    "approved": false,
    "sourceId": "DOC-CSDL-001"
  }
];
