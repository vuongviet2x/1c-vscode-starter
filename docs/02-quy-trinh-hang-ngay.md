# 02 — Quy trình làm việc hằng ngày

## Code nằm ở hai nơi

Cấu hình 1C có hai bản cùng lúc:

- **Trong infobase** (thư mục `ib/`): bản Designer đọc và sửa.
- **Trong `src/cf/`**: bản dạng file mà VS Code, Git và Claude đọc và sửa.

Các lệnh `dump`, `check`, `apply` sao chép qua lại giữa hai bản:

```
          dump  (infobase → file)
Designer ─────────────────────────▶ src/cf ──▶ VS Code, Claude, Git
   ▲                                   │
   └────────── check / apply ◀─────────┘
          (file → infobase)
```

Nếu sửa ở cả hai phía mà không đồng bộ, lần chép tiếp theo sẽ **ghi đè** phía bên kia. Để phòng trường hợp đó, `check` và `apply` luôn sao lưu cấu hình hiện tại vào `logs/backup-before-load.cf` trước khi nạp (chỉ giữ một bản gần nhất).

## Quy tắc vàng

1. **Mỗi lúc chỉ sửa ở một phía.**
2. Sửa trong Designer xong → **đóng Designer** → `dump`.
3. Sửa trong VS Code xong → `check` (hoặc `apply`) → mới mở lại Designer.
4. Mọi lệnh đều cần **Designer đang đóng** (mỗi infobase chỉ mở được một Designer). `apply` còn cần đóng cả 1C:Enterprise.

## Việc nào làm ở đâu

| Việc | Làm ở |
|---|---|
| Tạo Catalog, Document, Register, Enum, Report… | Designer |
| Thêm attribute, tabular section, dimension, resource | Designer |
| Vẽ / sửa form, thêm nút, gắn event handler cho ô và nút | Designer |
| Tick register ở tab *Register records*, đặt property, subsystem, role | Designer |
| Viết code trong object module, manager module, form module, common module | **VS Code** (hoặc Designer) |
| Đọc hiểu code, tìm chỗ dùng một procedure, so sánh thay đổi | **VS Code** |
| Hỏi Claude, gỡ lỗi | **VS Code** |
| Breakpoint, step từng dòng | Designer (mức cơ bản) hoặc VS Code (mức nâng cao) |

Gợi ý: khi tạo event handler mới (ví dụ `OnChange` của một ô), tạo nó trong Designer để Designer tự sinh procedure và gắn vào form, rồi `dump` và viết thân procedure trong VS Code.

## Một vòng làm việc mẫu

Ví dụ: thêm attribute `Discount` vào document `SalesInvoice` và tính lại tiền khi đổi.

1. **Designer:** thêm attribute `Discount`, đưa lên form, tạo handler `DiscountOnChange`. Lưu, **đóng Designer**.
2. **VS Code:** chạy task `1C: Xuất cấu hình ra src (dump)`.
3. Xem Git đã đổi gì: biểu tượng *Source Control* (`Ctrl+Shift+G`) — bạn sẽ thấy file XML của document và form module.
4. Viết code trong `src/cf/Documents/SalesInvoice/Forms/DocumentForm/Ext/Form/Module.bsl`. Lưu → BSL Language Server gạch chân chỗ nghi lỗi.
5. `Ctrl+Shift+B` (task **check**). Có lỗi thì hỏi Claude (xem [03](03-go-loi-cung-claude.md)).
6. Hết lỗi: task **apply**, rồi **run** để thử trên dữ liệu thật.
7. Chạy được đúng: commit.

```
git add .
git commit -m "SalesInvoice: them Discount, tinh lai tien"
```

## Git: những lệnh cần nhớ

| Muốn | Lệnh / thao tác |
|---|---|
| Xem đã sửa gì | *Source Control* trong VS Code, hoặc `git status`, `git diff` |
| Lưu mốc | `git add .` rồi `git commit -m "mô tả ngắn"` |
| Bỏ thay đổi chưa commit của một file | Chuột phải file trong *Source Control* → *Discard Changes* |
| Quay về mốc trước rồi nạp lại | `git checkout -- src/cf` rồi chạy **apply** |
| Làm nhóm | Một người tạo repo trên GitHub, cả nhóm clone; mỗi người làm trên nhánh riêng và hạn chế cùng sửa một object |

Commit sau mỗi bước chạy được. Khi có sự cố, quay về mốc gần nhất luôn nhanh hơn ngồi gỡ.

## Cấu hình lớn (Jet)

- Lần `dump` đầu tiên lâu, các lần sau nhanh hơn vì chỉ xuất phần thay đổi.
- `check` và `apply` nạp **toàn bộ** `src/cf`, nên với Jet mỗi lần có thể mất một đến vài phút. Gom nhiều chỗ sửa rồi mới check.
