import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F3_231A290089',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0468D7)),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Chìa khóa điều khiển toàn bộ Form
  final _formKey = GlobalKey<FormState>();

  // TextEditingController quản lý dữ liệu ô nhập
  final _hoTenCtrl = TextEditingController();
  final _mssvCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  static const _monHocs = [
    'Lập trình trên các thiết bị di động',
    'Cơ sở dữ liệu',
    'Trí tuệ nhân tạo',
    'Kiểm thử phần mềm',
  ];

  static const _buoiHocs = ['Sáng', 'Chiều', 'Tối'];

  String? _monHoc;
  String _heDaoTao = 'Chính quy';
  final Set<String> _buoiDaChon = {};
  bool _nhanThongBao = true;
  double _soTinChi = 15;

  @override
  void dispose() {
    // Dọn dẹp bộ nhớ bắt buộc để tránh rò rỉ (tương đương onDestroy ở Android)
    _hoTenCtrl.dispose();
    _mssvCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  // --- CÁC HÀM VALIDATOR ---
  String? _kiemTraHoTen(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Vui lòng nhập họ tên';
    if (s.length < 3) return 'Họ tên phải có ít nhất 3 ký tự';
    return null;
  }

  String? _kiemTraMssv(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Vui lòng nhập MSSV';
    if (!RegExp(r'^\d{10}$').hasMatch(s)) return 'MSSV phải gồm đúng 10 chữ số';
    return null;
  }

  String? _kiemTraEmail(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Vui lòng nhập email';
    if (!RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.\-]+$').hasMatch(s)) {
      return 'Email không đúng định dạng';
    }
    return null;
  }

  // --- XỬ LÝ NÚT ĐĂNG KÝ & LÀM LẠI ---
  void _dangKy() {
    // 1. Kiểm tra các trường bên trong Form
    final hopLe = _formKey.currentState!.validate();

    // 2. Kiểm tra control NẰM NGOÀI Form (Checkbox)
    if (_buoiDaChon.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hãy chọn ít nhất một buổi học'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    // NC2: Kiểm tra phụ thuộc: Nếu hệ "Vừa làm vừa học" thì bắt buộc chọn buổi Tối
    if (_heDaoTao == 'Vừa làm vừa học' && !_buoiDaChon.contains('Tối')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hệ Vừa làm vừa học bắt buộc phải đăng ký buổi Tối!'),
          backgroundColor: Colors.deepOrange,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (!hopLe) return;

    // 3. Hiển thị hộp thoại tóm tắt nếu toàn bộ dữ liệu hợp lệ
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận đăng ký'),
        content: Text(
          'Họ tên: ${_hoTenCtrl.text.trim()}\n'
          'MSSV: ${_mssvCtrl.text.trim()}\n'
          'Email: ${_emailCtrl.text.trim()}\n'
          'Học phần: $_monHoc\n'
          'Hệ đào tạo: $_heDaoTao\n'
          'Buổi học: ${(_buoiDaChon.toList()..sort()).join(", ")}\n'
          'Số tín chỉ: ${_soTinChi.round()}\n'
          'Nhận thông báo: ${_nhanThongBao ? "Có" : "Không"}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _lamLai() {
    // Xóa nội dung và lỗi của Form
    _formKey.currentState!.reset();
    _hoTenCtrl.clear();
    _mssvCtrl.clear();
    _emailCtrl.clear();

    setState(() {
      _monHoc = null;
      _heDaoTao = 'Chính quy';
      _buoiDaChon.clear();
      _nhanThongBao = true;
      _soTinChi = 15;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab F3 – Đăng ký học phần'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              /*// 1. Họ và tên
              TextFormField(
                controller: _hoTenCtrl,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên *',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: _kiemTraHoTen,
              ),
              const SizedBox(height: 12),*/
              // 1. Họ và tên (NC3: Tích hợp bộ đếm ký tự maxLength)
              TextFormField(
                controller: _hoTenCtrl,
                maxLength: 50,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên *',
                  prefixIcon: Icon(Icons.person_outline),
                  helperText: 'Tối đa 50 ký tự',
                ),
                validator: _kiemTraHoTen,
              ),

              // 2. MSSV (Chặn phím bằng inputFormatters)
              TextFormField(
                controller: _mssvCtrl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: const InputDecoration(
                  labelText: 'Mã số sinh viên *',
                  prefixIcon: Icon(Icons.badge_outlined),
                  helperText: 'Gồm đúng 10 chữ số',
                ),
                validator: _kiemTraMssv,
              ),
              const SizedBox(height: 12),

              // 3. Email
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
                validator: _kiemTraEmail,
              ),
              const SizedBox(height: 12),

              // 4. Dropdown Học phần
              DropdownButtonFormField<String>(
                key: ValueKey(_monHoc),
                initialValue: _monHoc,
                decoration: const InputDecoration(
                  labelText: 'Học phần đăng ký *',
                  prefixIcon: Icon(Icons.menu_book_outlined),
                ),
                items: _monHocs
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (v) => setState(() => _monHoc = v),
                validator: (v) => v == null ? 'Hãy chọn một học phần' : null,
              ),
              const SizedBox(height: 20),

              // 5. Hệ đào tạo (Radio)
              Text(
                'Hệ đào tạo',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              RadioGroup<String>(
                groupValue: _heDaoTao,
                onChanged: (v) => setState(() => _heDaoTao = v ?? 'Chính quy'),
                child: const Column(
                  children: [
                    RadioListTile<String>(
                      value: 'Chính quy',
                      title: Text('Chính quy'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    RadioListTile<String>(
                      value: 'Vừa làm vừa học',
                      title: Text('Vừa làm vừa học'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // 6. Buổi học (Checkbox)
              Text(
                'Buổi học mong muốn (chọn ≥ 1)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ..._buoiHocs.map(
                (b) => CheckboxListTile(
                  value: _buoiDaChon.contains(b),
                  title: Text(b),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (chon) => setState(() {
                    if (chon == true) {
                      _buoiDaChon.add(b);
                    } else {
                      _buoiDaChon.remove(b);
                    }
                  }),
                ),
              ),
              const SizedBox(height: 8),

              // 7. Số tín chỉ (Slider)
              Text(
                'Số tín chỉ đăng ký: ${_soTinChi.round()}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Slider(
                value: _soTinChi,
                min: 10,
                max: 24,
                divisions: 14,
                label: '${_soTinChi.round()}',
                onChanged: (v) => setState(() => _soTinChi = v),
              ),

              // 8. Nhận thông báo (Switch)
              SwitchListTile(
                value: _nhanThongBao,
                title: const Text('Nhận thông báo qua email'),
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => setState(() => _nhanThongBao = v),
              ),
              const SizedBox(height: 16),

              // Hàng nút Đăng ký & Làm lại
              FilledButton(
                onPressed: _dangKy,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'ĐĂNG KÝ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(onPressed: _lamLai, child: const Text('Làm lại')),
            ],
          ),
        ),
      ),
    );
  }
}
