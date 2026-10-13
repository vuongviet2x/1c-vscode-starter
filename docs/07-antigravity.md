# 07 — Dùng Google Antigravity thay cho VS Code

Antigravity là IDE của Google, xây trên VS Code, có sẵn agent AI (mặc định Gemini, chọn được cả Claude). Bộ khởi động chạy nguyên vẹn trên Antigravity: vẫn các script `doctor`, `dump`, `check`, `apply`, vẫn Tasks, vẫn Git. Chỉ khác ở phần trợ lý AI.

| | VS Code + Claude Code | Antigravity |
|---|---|---|
| Trợ lý AI | Extension Claude Code (cần gói Claude trả phí) | Agent có sẵn, đăng nhập bằng tài khoản Google |
| File hướng dẫn cho AI | `CLAUDE.md` | `AGENTS.md` (đã có sẵn trong repo) |
| Chỗ đặt skill | `.claude/skills/` | `.agents/skills/` — `install-skill` cài vào cả hai |
| Quyền chạy lệnh của AI | `.claude/settings.json` (đặt sẵn) | Cài đặt của Antigravity — bạn tự duyệt |
| Kho extension | Microsoft Marketplace | Open VSX |

Tên menu trong Antigravity có thể khác đôi chút giữa các bản.

## 1. Cài đặt

1. Cài platform 1C:Enterprise (bản nào cũng được; lộ trình 1C:Jet dùng 8.3.25) và Git, như bước 1–2 của [01 — Cài đặt](01-cai-dat.md).
2. Tải Antigravity tại [antigravity.google](https://antigravity.google), cài, đăng nhập bằng tài khoản Google. Lần đầu mở, nếu được hỏi có nhập cài đặt từ VS Code không, chọn tùy ý.
3. Mở dự án: `Ctrl+Shift+P` → **Git: Clone** → dán link repo, hoặc clone bằng Terminal rồi *File → Open Folder*.

## 2. Extension Language 1C (BSL)

Antigravity lấy extension từ **Open VSX**, và Language 1C (BSL) của nhóm 1c-syntax **có trên Open VSX**.

1. Mở Extensions (`Ctrl+Shift+X`), tìm `Language 1C (BSL)`, tác giả **1c-syntax** → **Install**.
2. Không thấy trong danh sách: tải file `.vsix` mới nhất ở [github.com/1c-syntax/vsc-language-1c-bsl/releases](https://github.com/1c-syntax/vsc-language-1c-bsl/releases). Trong Extensions, bấm `…` → **Install from VSIX…** → chọn file vừa tải.

Không cần cài extension Claude Code. Nếu bạn có tài khoản Claude và muốn dùng Claude Code trong Antigravity, nó cũng có trên Open VSX.

**Kiểm tra:** mở một file `.bsl`, code được tô màu.

## 3. Nối dự án với 1C

Giống hệt bản VS Code: làm Phần B của hướng dẫn chính, gồm `doctor` → sửa `1c.env` → tạo infobase → điền user → `dump` → cài skill.

Lệnh cài skill vẫn như cũ, và skill được cài vào cả `.claude/skills/` lẫn `.agents/skills/`:

```
scripts\windows\install-skill.cmd "D:\Downloads\1c-dev-mentor-student-claude-gpt.zip"
```

Dùng bản **claude-gpt**, không dùng bản Gemini. Bản claude-gpt chứa sẵn toàn bộ tài liệu khóa học bên trong skill. Bản Gemini dẫn tới NotebookLM, mà agent trong IDE không đọc được.

**Kiểm tra:** `doctor` có dòng `Skill da cai: 1c-dev-mentor-student (Antigravity / Gemini)`.

## 4. Làm việc với agent

1. Mở khung chat của agent ở cạnh phải editor. Chọn model trong ô chọn model (Gemini là mặc định).
2. **Quyền chạy lệnh:** Antigravity không đọc `.claude/settings.json`. Trong cài đặt agent, giữ chế độ **hỏi trước / để bạn duyệt** khi agent chạy lệnh Terminal, không bật chế độ tự chạy mọi lệnh.
   - Duyệt thoải mái: `doctor`, `check`, `dump`.
   - Đọc kỹ trước khi duyệt: `apply`, `restore-dt`, `git commit`, `git push`, mọi lệnh xóa file.
3. **Mật khẩu:** quy tắc "không đọc `1c.env`" trong `AGENTS.md` chỉ là lời dặn, Antigravity không có cơ chế chặn. Đừng dùng mật khẩu thật của bạn cho infobase bài tập.
4. Câu đầu tiên nên gõ:
   > Đọc AGENTS.md, rồi chạy kiểm tra môi trường và check cú pháp, báo kết quả cho mình.

   Nếu agent hỏi có dùng skill `1c-dev-mentor-student` không, chọn đồng ý.
5. Hỏi và gỡ lỗi như [03 — Gỡ lỗi cùng Claude](03-go-loi-cung-claude.md): gửi nguyên văn lỗi, thao tác vừa làm, kết quả mong đợi. Breakpoint vẫn đặt trong Designer.

## 5. Làm việc hằng ngày và làm nhóm

Không có gì khác: quy tắc vàng, Run Task / `Ctrl+Shift+B`, Git, và file `.1c-platform` cho nhóm, như [02](02-quy-trinh-hang-ngay.md) và [06](06-lam-viec-nhom.md). Trong một nhóm, người dùng VS Code và người dùng Antigravity làm chung một repo bình thường.

## 6. Lỗi thường gặp riêng với Antigravity

| Thấy | Cách xử lý |
|---|---|
| Không tìm thấy Language 1C (BSL) trong Extensions | Cài từ file `.vsix` (mục 2) |
| Agent trả lời chung chung, không hỏi lộ trình, không theo giáo trình | Chạy `doctor` xem skill đã có trong `.agents/skills` chưa; mở lại khung agent; nhắc: *"Dùng skill 1c-dev-mentor-student trong .agents/skills."* |
| Agent chạy lệnh sai cú pháp trên Windows | Nói rõ: *"Chạy scripts\windows\check.cmd trong PowerShell."* |
| Agent tự sửa nhiều file, hoặc sửa file `.xml` | Từ chối thay đổi; nhắc *"Chỉ sửa file .bsl, theo AGENTS.md"*; trả file về bằng *Source Control → Discard Changes* |
| Báo hết lượt dùng | Đợi lượt được làm mới, hoặc đổi sang model khác trong ô chọn model |
| Không có Run Task / `Ctrl+Shift+B` không chạy | Gõ lệnh trực tiếp trong Terminal, ví dụ `scripts\windows\check.cmd` |
