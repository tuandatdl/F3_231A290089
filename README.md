# INT4211 - LẬP TRÌNH TRÊN CÁC THIẾT BỊ DI ĐỘNG
## BÁO CÁO THỰC HÀNH LAB F3: NHẬP LIỆU & FORM TRONG FLUTTER – ĐĂNG KÝ HỌC PHẦN

---

### THÔNG TIN SINH VIÊN
* **Họ và tên:** Đỗ Lê Tuấn Đạt
* **Mã số sinh viên (MSSV):** 231A290089
* **Lớp học phần:** Lập trình thiết bị di động (INT4211)
* **Môi trường thực thi:** Flutter 3.x (Material 3) trên macOS (Apple Silicon)
* **Thiết bị thử nghiệm:** Máy ảo Pixel 8 (Android 17, API 37.1) & Google Chrome

---

### CÁC MỤC ĐÃ HOÀN THÀNH

#### 1. Xây dựng Form đăng ký học phần đầy đủ 7 loại Control (Phần 1, 2, 4)
* **Quản lý Form tập trung:** Sử dụng `Form` kết hợp `GlobalKey<FormState>()`, kích hoạt chế độ kiểm tra tức thời `autovalidateMode: AutovalidateMode.onUserInteraction`.
* **Quản lý bộ nhớ:** Sử dụng `TextEditingController` cho 3 trường dữ liệu text và gọi `dispose()` giải phóng bộ nhớ đầy đủ trong phương thức vòng đời của State.
* **Tích hợp 7 loại Control chọn lựa:**
  1. `TextFormField`: Nhập Họ tên, MSSV, Email kèm Icon định danh.
  2. `DropdownButtonFormField`: Chọn môn học với danh sách sinh động qua `.map().toList()`. Dùng mẹo `ValueKey(_monHoc)` để reset widget về trạng thái rỗng khi làm lại.
  3. `RadioGroup` + `RadioListTile`: Chọn hệ đào tạo (Chính quy / Vừa làm vừa học).
  4. `CheckboxListTile`: Chọn nhiều buổi học (Sáng, Chiều, Tối) lưu trữ trong tập hợp `Set<String>`.
  5. `Slider`: Chọn số tín chỉ đăng ký (10 – 24 tín chỉ, chia 14 phân đoạn).
  6. `SwitchListTile`: Bật/tắt tùy chọn nhận thông báo email.
  7. `FilledButton` / `OutlinedButton`: Cặp nút hành động Đăng ký và Làm lại.

#### 2. Kiểm tra dữ liệu nhiều tầng & Chặn lỗi từ bàn phím (Phần 3, 5)
* **Chặn lỗi tại nguồn:** Sử dụng `FilteringTextInputFormatter.digitsOnly` và `LengthLimitingTextInputFormatter(10)` để người dùng không thể gõ chữ hoặc nhập quá 10 số vào ô MSSV.
* **Hàm Validator độc lập:** Kiểm tra rỗng, độ dài tối thiểu, và kiểm tra định dạng email bằng biểu thức chính quy Regex (`raw string r'...'`).
* **Kiểm tra hai lớp:** Kiểm tra đồng thời các trường thuộc Form (`validate()`) và trường nằm ngoài Form (buổi học) báo qua `SnackBar`.

#### 3. Bài nâng cao NC2: Ràng buộc nghiệp vụ phụ thuộc hệ đào tạo
* Kiểm tra điều kiện: Nếu sinh viên chọn hệ *"Vừa làm vừa học"* mà chưa tích chọn buổi *"Tối"*, hệ thống từ chối mở hộp thoại và cảnh báo qua `SnackBar`.

#### 4. Bài nâng cao NC3: Bộ đếm ký tự còn lại cho trường Họ tên
* Cấu hình `maxLength: 50` trên `TextFormField` của Họ tên, hệ thống tự động hiển thị bộ đếm ký tự `X/50` ở góc dưới.

#### 5. Bảng đối chiếu Controls giữa Android Native (Lab A4, A6) và Flutter (Lab F3)
| Việc cần làm | Android Native (Lab A4, A6) | Flutter Widget (Lab F3) |
|---|---|---|
| Nhập văn bản | `EditText` + `inputType` | `TextFormField` + `keyboardType` |
| Chọn 1 trong danh sách dài | `Spinner` + `ArrayAdapter` | `DropdownButtonFormField` + `items` |
| Chọn 1 trong số ít lựa chọn | `RadioGroup` + `RadioButton` | `RadioGroup` + `RadioListTile` |
| Chọn nhiều mục độc lập | `CheckBox` | `CheckboxListTile` (lưu vào `Set`) |
| Bật / tắt 2 trạng thái | `MaterialSwitch` / `ToggleButton` | `SwitchListTile` |
| Chọn giá trị trong khoảng | `SeekBar` | `Slider` (`min`, `max`, `divisions`) |
| Báo lỗi tại chỗ | `setError(...)` trên View | `validator` trả chuỗi lỗi đỏ |
| Thông báo nhanh | `Toast` | `SnackBar` qua `ScaffoldMessenger` |