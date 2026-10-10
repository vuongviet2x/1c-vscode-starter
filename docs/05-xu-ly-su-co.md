# 05 — Xử lý sự cố

Bước đầu tiên luôn là chạy **doctor** và đọc file log của bước bị lỗi trong `logs/`. Bạn cũng có thể hỏi Claude: *"Lệnh check vừa lỗi, đọc logs/check.log và giải thích giúp mình."*

## Platform và script

| Triệu chứng | Nguyên nhân thường gặp | Cách xử lý |
|---|---|---|
| `Khong tim thay 1cv8.exe` / `Không tìm thấy 1cv8` | `V8_VERSION` trong `1c.env` khác bản đã cài | Sửa `V8_VERSION`, hoặc điền đường dẫn đầy đủ vào `V8_PATH`. macOS: `ls -d /Applications/1cv8*/*/1cv8.app` để xem bản đã cài |
| macOS: `permission denied` khi chạy `.sh` | File chưa có quyền chạy | `chmod +x scripts/macos/*.sh` |
| macOS: hệ thống chặn mở 1cv8 | Gatekeeper | Mở 1C một lần bằng tay từ Finder, chọn *Open* |
| Lệnh chạy rất lâu rồi báo lỗi khóa / *Designer is already running* | Designer đang mở cùng infobase | Đóng Designer rồi chạy lại |
| `apply` báo không cập nhật được database | Còn phiên 1C:Enterprise đang mở | Đóng hết cửa sổ 1C:Enterprise rồi chạy lại |
| Log toàn ký tự lạ | Encoding của log khác terminal | Mở file log trong VS Code: góc dưới phải bấm encoding → *Reopen with Encoding* → thử UTF-8, UTF-16, Windows-1251 |
| Đăng nhập thất bại | Sai `IB_USER` / `IB_PWD` | Sửa `1c.env`. Mật khẩu chỉ dùng chữ và số |
| Thông báo lỗi tiếng Nga | `UI_LANG=ru`, hoặc platform không có gói tiếng Anh | Đặt `UI_LANG=en`. Claude vẫn đọc được tiếng Nga |

## Đồng bộ Designer ↔ file

| Triệu chứng | Nguyên nhân | Cách xử lý |
|---|---|---|
| Sửa trong Designer xong, VS Code vẫn thấy code cũ | Chưa `dump` | Đóng Designer, `dump` |
| Mất phần vừa sửa trong Designer sau khi `check`/`apply` | Đã nạp `src/cf` cũ đè lên | Mở Designer → *Configuration → Load configuration from file…* → chọn `logs/backup-before-load.cf` (bản sao lưu ngay trước lần nạp gần nhất), rồi `dump` |
| `check` báo lỗi ở file mình không sửa | Merge Git hỏng, hoặc sửa nhầm file `.xml` | `git status`, `git diff` để xem; `git checkout -- <file>` để trả lại file |
| `dump` lần nào cũng xuất lại toàn bộ | Thiếu hoặc lệch `src/cf/ConfigDumpInfo.xml` | Bình thường sau lần đầu; nếu vẫn chậm, xóa `src/cf` và `dump` lại |

## VS Code và Claude

| Triệu chứng | Cách xử lý |
|---|---|
| File `.bsl` không tô màu | Kiểm tra đã cài *Language 1C (BSL)*; góc dưới phải chọn ngôn ngữ **1C (BSL)** |
| Không có gạch chân lỗi | BSL Language Server đang tải lần đầu, chờ vài phút; xem *Output → BSL Language Server*. Nếu báo thiếu Java, cài Java 17 trở lên |
| Panel Claude Code không đăng nhập được | Tài khoản phải là gói trả phí (Pro trở lên) hoặc Claude Console; thử *Sign out* rồi đăng nhập lại |
| Claude không theo giáo trình, không hỏi lộ trình | Skill chưa cài hoặc chưa nạp: chạy doctor; gõ `/reload-skills` hoặc mở lại panel; có thể gọi thẳng `/1c-dev-mentor-student` |
| Claude xin quyền mỗi lần chạy check | Bình thường lần đầu với lệnh mới; chọn *Yes, and don't ask again* cho `check` và `dump` |
| Windows: Claude chạy lệnh lỗi đường dẫn | Cài Git for Windows để Claude dùng Git Bash; hoặc nói rõ "dùng scripts\windows\check.cmd" |

Vẫn không được: chụp màn hình lỗi, kèm kết quả `doctor`, gửi giảng viên.
