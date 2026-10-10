# 01 — Cài đặt

Làm lần lượt từ trên xuống. Mỗi bước có cách kiểm tra; bước nào không qua thì xem [05 — Xử lý sự cố](05-xu-ly-su-co.md) trước khi đi tiếp.

Thời gian: khoảng 45–60 phút cho lần đầu.

## Bước 1. Platform 1C:Enterprise 8.3.25.1445

Bộ cài lấy từ thư mục Drive giảng viên cung cấp. Khóa học dùng bản **8.3.25.1445** vì cấu hình Jet của khóa chạy trên bản này.

- **Windows:** chạy bộ cài, chọn ít nhất *1C:Enterprise* và *1C:Enterprise — thin client*. Mặc định cài vào `C:\Program Files\1cv8\8.3.25.1445\`.
- **macOS:** mở file `.dmg`, chạy bộ cài. Mặc định cài vào `/Applications/1cv8.localized/8.3.25.1445/`. Nếu máy không cài được bản 8.3.25.1445, cài bản gần nhất và **báo giảng viên bản bạn đã cài**.

**Kiểm tra:** mở được cửa sổ launcher của 1C (danh sách infobase).

## Bước 2. Git

- **Windows:** tải từ https://git-scm.com/downloads/win, cài với các lựa chọn mặc định. Bản cài này có kèm Git Bash, Claude Code sẽ dùng nó.
- **macOS:** mở Terminal, chạy `xcode-select --install`.

**Kiểm tra:** mở terminal mới, gõ `git --version` → hiện số phiên bản.

Lần đầu dùng Git, khai báo tên và email:

```
git config --global user.name "Ho Ten Cua Ban"
git config --global user.email "email@cua.ban"
```

## Bước 3. VS Code và extension

1. Tải VS Code: https://code.visualstudio.com (bản 1.94 trở lên).
2. Tải bộ khởi động về máy (`git clone <link-repo> my-1c-project`, hoặc *Code → Download ZIP* rồi giải nén). Đặt ở đường dẫn **không dấu, không dấu cách** nếu được, ví dụ `D:\1C\my-1c-project` hoặc `~/1C/my-1c-project`.
3. Trong VS Code: *File → Open Folder…* → chọn thư mục dự án.
4. VS Code sẽ hỏi có cài các extension được gợi ý không → chọn **Install**. Hai extension đó là:
   - **Language 1C (BSL)** (`1c-syntax.language-1c-bsl`): tô màu, gợi ý, kiểm tra code bằng BSL Language Server.
   - **Claude Code** (`anthropic.claude-code`): Claude chạy trong VS Code.

   Nếu không thấy hỏi: mở Extensions (`Ctrl+Shift+X` / `Cmd+Shift+X`), tìm theo tên và cài.

**Kiểm tra:** mở một file `.bsl` bất kỳ (sau bước 6) → code được tô màu; góc dưới bên phải hiện ngôn ngữ **1C (BSL)**. Lần đầu, extension có thể mất vài phút tải BSL Language Server.

## Bước 4. Tài khoản Claude

Claude Code cần tài khoản Claude **trả phí** (Pro trở lên) hoặc tài khoản Claude Console; gói miễn phí không dùng được Claude Code. Hỏi giảng viên nếu lớp có tài khoản chung hoặc phương án khác.

1. Bấm biểu tượng Claude ở thanh bên trái (hoặc góc trên bên phải của editor).
2. Đăng nhập theo hướng dẫn trên trình duyệt.

**Kiểm tra:** panel Claude Code hiện ô chat, gõ "xin chào" có trả lời.

## Bước 5. Cấu hình `1c.env` và chạy doctor

Mở Terminal trong VS Code: *Terminal → New Terminal* (`` Ctrl+` ``). Terminal mở sẵn ở thư mục dự án.

- Windows: `scripts\windows\doctor.cmd`
- macOS: `./scripts/macos/doctor.sh` (lần đầu nếu báo *permission denied*: `chmod +x scripts/macos/*.sh`)

Lần đầu, doctor tự tạo file `1c.env`. Mở file này và kiểm tra:

```
V8_VERSION=8.3.25.1445
V8_PATH=
IB_PATH=ib
IB_USER=
IB_PWD=
UI_LANG=en
```

- `V8_VERSION`: đúng bản bạn đã cài. Nếu doctor vẫn báo không tìm thấy platform, điền đường dẫn đầy đủ của `1cv8.exe` (Windows) hoặc `1cv8` (macOS) vào `V8_PATH`.
- `IB_USER`, `IB_PWD`: tài khoản đăng nhập infobase. File `.dt` của khóa có user thì điền vào; infobase trống thì để trống.
- Mật khẩu chỉ nên dùng chữ và số (ký tự như `&`, `^`, `%` làm script Windows chạy sai).
- `1c.env` **không** được đưa lên Git và Claude được cấu hình không đọc file này.

Chạy lại doctor đến khi dòng *Platform* báo `[OK]`.

## Bước 6. Tạo infobase và xuất cấu hình ra file

**Lộ trình Jet hoặc có file `.dt` giảng viên gửi:**

1. Chép file `.dt` vào thư mục `dt/` của dự án.
2. Chạy **restore-dt** (`scripts\windows\restore-dt.cmd` / `./scripts/macos/restore-dt.sh`), xác nhận `Y`.

**Lớp MIS — tự xây dựng từ cấu hình trống:** chạy **new-ib**.

Sau đó, **đóng Designer nếu đang mở**, chạy **dump**. Lần đầu có thể mất vài phút với cấu hình lớn như Jet.

**Kiểm tra:** thư mục `src/cf/` có file `Configuration.xml` và các thư mục `Catalogs`, `Documents`…; chạy doctor thấy dòng *Infobase* và *Mã nguồn* đều `[OK]`.

Ghi lại mốc đầu tiên vào Git:

```
git add .
git commit -m "Cau hinh ban dau"
```

## Bước 7. Cài skill gia sư

Giảng viên gửi file `1c-dev-mentor-student.zip` (không giải nén). Trong terminal:

- Windows: `scripts\windows\install-skill.cmd "%USERPROFILE%\Downloads\1c-dev-mentor-student.zip"`
- macOS: `./scripts/macos/install-skill.sh ~/Downloads/1c-dev-mentor-student.zip`

Khi giảng viên phát bản skill mới, chạy lại đúng lệnh này với file mới.

**Kiểm tra:** đóng và mở lại panel Claude Code, gõ `/` → danh sách có `1c-dev-mentor-student`. Hỏi thử: *"Bạn là ai và giúp mình được những gì?"*

## Bước 8. Thử một vòng hoàn chỉnh

Gõ vào Claude Code:

> Chạy kiểm tra môi trường, sau đó chạy check cú pháp và cho mình biết kết quả.

Claude sẽ chạy `doctor` và `check`, đọc `logs/check.log` rồi báo lại. Nếu được hỏi quyền chạy lệnh, đọc lệnh rồi chọn đồng ý.

Xong. Tiếp theo: [02 — Quy trình làm việc hằng ngày](02-quy-trinh-hang-ngay.md).
