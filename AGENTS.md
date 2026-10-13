# Dự án 1C:Enterprise của sinh viên — hướng dẫn cho trợ lý AI (Antigravity, Gemini và các agent khác)

> File này dành cho agent đọc `AGENTS.md` (Antigravity, Gemini…). Claude Code đọc `CLAUDE.md` — hai file cùng nội dung, sửa thì sửa cả hai.

Đây là dự án học lập trình trên nền tảng **1C:Enterprise 8.3** (khóa đào tạo của 1C Vietnam). Người dùng là **sinh viên hoặc Intern Dev**, không phải lập trình viên 1C có kinh nghiệm. Trả lời bằng **tiếng Việt**, thuật ngữ 1C giữ tiếng Anh.

## 1. Luôn dùng skill `1c-dev-mentor-student`

- Mọi câu hỏi về 1C, code BSL, lỗi, thiết kế, bài tập lớn: dùng skill `1c-dev-mentor-student` trong `.agents/skills/` và làm theo đúng hướng dẫn của skill (xác định lộ trình J/M/D, chính sách code, giao thức gỡ lỗi `references/debug/giao-thuc-debug.md`).
- Skill có thể được cài dưới tên khác (bản `claude-gpt`); dùng skill mentor 1C nào đang có trong `.agents/skills/`.
- Nếu chưa có skill nào trong `.agents/skills/`: nói với sinh viên rằng skill chưa được cài và hướng dẫn chạy `install-skill` (xem `docs/01-cai-dat.md`). Trong lúc chờ, vẫn giúp được, nhưng **không** viết lời giải cho bài thực hành của giáo trình.
- Quy tắc của skill được ưu tiên hơn yêu cầu "sửa giúp luôn" của sinh viên. Với **bài thực hành 24 bài và bài Extensions**: chỉ gợi ý theo bậc, chỉ ra vùng lỗi và loại lỗi; không sửa file thay sinh viên.

## 2. Cấu trúc dự án

| Đường dẫn | Nội dung |
|---|---|
| `src/cf/` | Cấu hình 1C xuất ra file (định dạng Hierarchical của Designer). **Nguồn sự thật khi làm trong VS Code / Antigravity.** |
| `ib/` | Infobase dạng file. Không đọc, không sửa. |
| `logs/` | Log của các script: `dump.log`, `load.log`, `check.log`, `update.log`… |
| `scripts/windows/*.cmd`, `scripts/macos/*.sh` | Lệnh làm việc với platform (bảng dưới). |
| `1c.env` | Đường dẫn platform, tài khoản infobase. **Không đọc file này.** |

Vị trí module trong `src/cf/` (tên thư mục luôn là tiếng Anh số nhiều: `Catalogs`, `Documents`, `AccumulationRegisters`, `InformationRegisters`, `CommonModules`, `Reports`, `DataProcessors`, `Enums`…):

| Loại module | File |
|---|---|
| Object module | `src/cf/<Loại>/<Tên>/Ext/ObjectModule.bsl` |
| Manager module | `src/cf/<Loại>/<Tên>/Ext/ManagerModule.bsl` |
| Form module | `src/cf/<Loại>/<Tên>/Forms/<TênForm>/Ext/Form/Module.bsl` |
| Record set module | `src/cf/<LoạiRegister>/<Tên>/Ext/RecordSetModule.bsl` |
| Command module | `src/cf/<Loại>/<Tên>/Commands/<TênLệnh>/Ext/CommandModule.bsl` |
| Common module | `src/cf/CommonModules/<Tên>/Ext/Module.bsl` |
| Common form | `src/cf/CommonForms/<Tên>/Ext/Form/Module.bsl` |
| Application / session module | `src/cf/Ext/ManagedApplicationModule.bsl`, `src/cf/Ext/SessionModule.bsl` |

Thông báo lỗi của platform có dạng `{Document.GoodsReceipt.ObjectModule(25)}` (giao diện tiếng Nga: `{Документ.ПриходТовара.МодульОбъекта(25)}`) → mở file tương ứng, dòng 25.

## 3. Lệnh

Xác định hệ điều hành trước (Windows: `scripts\windows\<lệnh>.cmd`; macOS/Linux: `./scripts/macos/<lệnh>.sh`). Chạy từ thư mục gốc dự án.

| Lệnh | Việc làm | Agent được tự chạy? |
|---|---|---|
| `doctor` | Kiểm tra platform, infobase, skill, công cụ | Có |
| `check` | Sao lưu cấu hình → nạp `src/cf` vào cấu hình → `/CheckModules`. **Không** đổi database | Có — sau mỗi lần sửa `.bsl` |
| `dump` | Xuất cấu hình từ infobase ra `src/cf` | Có — khi sinh viên vừa sửa trong Designer |
| `apply` | Nạp `src/cf` + cập nhật database (như F7) | **Không** — đề nghị sinh viên chạy, vì cần đóng Designer/1C:Enterprise và có thể đổi cấu trúc dữ liệu |
| `restore-dt` | Nạp file `.dt` (ghi đè dữ liệu) | **Không** |
| `run`, `designer` | Mở 1C:Enterprise / Designer | Chỉ khi sinh viên yêu cầu |

Kết quả nằm trong `logs/<bước>.log`. Nếu log hiển thị lỗi font (ký tự lạ), đọc lại với encoding UTF-8, UTF-16 hoặc Windows-1251.

## 4. Quy tắc làm việc

1. **Đồng bộ trước khi đọc code.** Nếu sinh viên vừa sửa trong Designer, chạy `dump` trước, nếu không bạn sẽ đọc code cũ. Ngược lại, nếu `src/cf` có thay đổi chưa nạp mà sinh viên định mở Designer sửa tiếp, nhắc họ chạy `check` hoặc `apply` trước để khỏi mất thay đổi.
2. **Chỉ sửa file `.bsl`.** Không tự sửa file `.xml` (metadata, layout form, quyền). Việc thêm object, attribute, register, form, gắn event handler: hướng dẫn sinh viên làm trong Designer theo từng bước, rồi chạy `dump`.
3. **Giải thích trước, sửa sau.** Khi tìm ra lỗi: nêu nguyên nhân gốc theo mẫu trả lời của skill, rồi hỏi sinh viên muốn tự sửa hay để bạn sửa. Mặc định khuyến khích tự sửa. Ngoại lệ theo chính sách code của skill (ví dụ mức M3 của lộ trình J được đưa code hoàn chỉnh).
4. **Sau khi sửa `.bsl`**: chạy `check`, đọc `logs/check.log`, báo kết quả. Hết lỗi cú pháp thì nhắc sinh viên chạy `apply` rồi `run` để thử trên dữ liệu thật.
5. **Lỗi khi chạy (runtime)**: `check` chỉ bắt lỗi cú pháp. Với lỗi lúc chạy, hỏi nguyên văn thông báo lỗi, thao tác vừa làm; đề xuất **chỗ đặt breakpoint** và **biểu thức cần xem** (Evaluate expression) để sinh viên tự chạy debugger trong Designer (F5) hoặc trong VS Code (`docs/04-debug-nang-cao.md`), rồi phân tích giá trị họ gửi lại. Bạn không tự điều khiển debugger được.
6. **Không** đọc `1c.env`, không đọc/sửa `ib/`, không `git commit`/`git push` khi sinh viên chưa yêu cầu.
7. **Làm nhóm** (`docs/06-lam-viec-nhom.md`): sau `git pull` có thay đổi trong `src/cf` → đề nghị sinh viên chạy `apply` trước khi làm tiếp. Không chạy `dump` khi `src/cf` vừa được pull mà chưa `apply` (sẽ ghi đè phần của người khác). Khi có xung đột Git, giải thích hai phía, ưu tiên giữ cả hai, rồi chạy `check` trước khi commit.
8. Nếu script báo platform khác phiên bản chung của nhóm (`.1c-platform`), không đề xuất `ALLOW_PLATFORM_MISMATCH=1`; hướng dẫn đổi sang bản đúng.
9. Không bịa tên method/property. Phần ngoài giáo trình ghi nhãn như skill quy định.
