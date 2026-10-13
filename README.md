# 1C VS Code Starter — lập trình 1C:Enterprise trong VS Code, có Claude hỗ trợ gỡ lỗi

Bộ khởi động cho sinh viên và Intern Dev học phát triển trên nền tảng **1C:Enterprise 8.3** (khóa đào tạo của 1C Vietnam). Sau khi cài xong, bạn có:

- Code 1C (`.bsl`) mở trong **VS Code**: tô màu cú pháp, gợi ý, báo lỗi và code smell ngay khi lưu (BSL Language Server).
- Các nút bấm (VS Code Tasks) để **xuất cấu hình ra file**, **kiểm tra cú pháp**, **nạp lại vào infobase**, mở Designer và 1C:Enterprise.
- **Claude Code** chạy ngay trong VS Code, kèm skill gia sư **1c-dev-mentor-student**: đọc code của bạn, chạy kiểm tra, đọc log lỗi và giải thích nguyên nhân theo giáo trình.
- Dự án nằm trong Git, nên mọi thay đổi đều xem lại và quay lui được.

> **Designer vẫn cần thiết.** Tạo object, attribute, register, vẽ form, phân quyền… làm trong Designer. VS Code dùng để viết và đọc **code module**. Bộ khởi động giúp hai bên đồng bộ với nhau.

## Hai mức sử dụng

| Mức | Bạn được gì | Cần cài thêm | Dành cho |
|---|---|---|---|
| **Cơ bản** | Viết code trong VS Code, kiểm tra cú pháp, Claude đọc lỗi và giải thích. Breakpoint vẫn đặt trong Designer (F5). | Không | Tất cả |
| **Nâng cao** | Đặt breakpoint, xem biến, step từng dòng **ngay trong VS Code** | Extension *1C: Platform Tools*, .NET 8, OneScript | Sinh viên MIS, Intern Dev, người đã quen mức cơ bản |

## Bắt đầu nhanh

1. Cài platform 1C:Enterprise 8.3 (**bản nào cũng được**; lộ trình 1C:Jet dùng **8.3.25**), Git, VS Code, tài khoản Claude — chi tiết: [docs/01-cai-dat.md](docs/01-cai-dat.md).
2. Tải repo này về: `git clone <link-repo> my-1c-project` (hoặc *Code → Download ZIP*), mở thư mục bằng VS Code, đồng ý cài các extension được gợi ý.
3. Mở Terminal trong VS Code (`` Ctrl+` ``) và chạy **doctor** để tạo `1c.env` và kiểm tra máy:
   - Windows: `scripts\windows\doctor.cmd`
   - macOS: `./scripts/macos/doctor.sh`
4. Tạo infobase:
   - Lộ trình Jet / có file `.dt`: chép file `.dt` vào thư mục `dt/`, chạy **restore-dt**.
   - Lớp MIS (cấu hình trống): chạy **new-ib**.
5. Đóng Designer nếu đang mở, chạy **dump** để xuất cấu hình ra `src/cf/`.
6. Cài skill từ file **`1c-dev-mentor-student-claude-gpt.zip`** giảng viên gửi (không dùng bản Gemini): `scripts\windows\install-skill.cmd <file.zip>` hoặc `./scripts/macos/install-skill.sh <file.zip>`.
7. Mở panel **Claude Code** (biểu tượng Claude ở thanh bên), gõ thử: *"Kiểm tra môi trường giúp mình và cho biết cấu hình có những document nào."*

## Các lệnh

Chạy bằng **Terminal → Run Task…** (chọn mục bắt đầu bằng `1C:`), hoặc gõ trong terminal. `Ctrl+Shift+B` chạy nhanh **check**.

| Lệnh | Việc làm | Khi nào |
|---|---|---|
| `doctor` | Kiểm tra platform, infobase, mã nguồn, skill, công cụ | Lần đầu, hoặc khi có gì đó không chạy |
| `dump` | Xuất cấu hình từ infobase ra `src/cf` | **Ngay sau khi sửa trong Designer** |
| `check` | Nạp `src/cf` vào cấu hình + kiểm tra cú pháp. Không đụng tới dữ liệu | Sau khi sửa code trong VS Code |
| `apply` | Nạp `src/cf` + cập nhật database (giống F7) | Khi muốn chạy thử code mới |
| `run` | Mở 1C:Enterprise | Thử chương trình |
| `designer` | Mở Designer | Sửa metadata, form |
| `restore-dt` / `new-ib` | Tạo infobase từ `.dt` / tạo infobase trống | Một lần lúc đầu |

**Quy tắc vàng:** mỗi lúc chỉ sửa ở **một phía**. Sửa trong Designer → đóng Designer → `dump`. Sửa trong VS Code → `check` / `apply` → mới mở lại Designer. Xem [docs/02-quy-trinh-hang-ngay.md](docs/02-quy-trinh-hang-ngay.md).

## Tài liệu

- [01 — Cài đặt](docs/01-cai-dat.md)
- [02 — Quy trình làm việc hằng ngày](docs/02-quy-trinh-hang-ngay.md)
- [03 — Gỡ lỗi cùng Claude](docs/03-go-loi-cung-claude.md)
- [04 — Debug nâng cao bằng breakpoint trong VS Code](docs/04-debug-nang-cao.md)
- [05 — Xử lý sự cố](docs/05-xu-ly-su-co.md)
- [06 — Làm việc nhóm qua Git](docs/06-lam-viec-nhom.md) — chung phiên bản platform, chia việc, xử lý xung đột

## Cấu trúc thư mục

```
.
├── CLAUDE.md                  # Hướng dẫn cho Claude khi làm việc trong dự án này
├── .claude/
│   ├── settings.json          # Quyền của Claude: được tự chạy check/dump, phải hỏi trước khi apply
│   └── skills/                # Skill 1c-dev-mentor-student (cài từ ZIP, không lên Git)
├── .vscode/                   # Extension gợi ý, cài đặt, Tasks
├── .bsl-language-server.json  # Cấu hình kiểm tra code BSL
├── 1c.env.example             # Mẫu cấu hình -> sao chép thành 1c.env
├── .1c-platform               # Phiên bản platform chung của nhóm (tự tạo ở lần dump đầu tiên)
├── scripts/windows/  scripts/macos/
├── src/cf/                    # Cấu hình xuất ra file — phần bạn commit lên Git
├── dt/                        # Chỗ để file .dt (không lên Git)
├── ib/                        # Infobase dạng file (không lên Git)
└── logs/                      # Log của các lệnh (không lên Git)
```

## Về skill và bản quyền

Skill **1c-dev-mentor-student** do Phạm Viết Quý (1C Vietnam) biên soạn, chỉ dùng cho học viên các chương trình đào tạo của 1C Vietnam và **không được đăng công khai**. Vì vậy skill không có trong repo này; thư mục `.claude/skills/` đã được Git bỏ qua. Khi bạn đẩy dự án của mình lên GitHub, skill sẽ không đi theo.

Bản dành cho sinh viên **không giải hộ** bài thực hành của giáo trình (24 bài và bài Extensions): Claude chỉ gợi ý và chỉ ra vùng lỗi để bạn tự sửa.

Góp ý, báo lỗi: Phạm Viết Quý — quypv@1c.com.vn
