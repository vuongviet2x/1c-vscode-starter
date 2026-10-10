# 03 — Gỡ lỗi cùng Claude

Trong dự án này, Claude Code đọc được toàn bộ `src/cf`, tự chạy `check` / `dump`, đọc `logs/` và làm theo giao thức gỡ lỗi của skill **1c-dev-mentor-student**. Bạn không cần dán code vào chat như khi dùng Claude trên web.

## Claude làm được gì, không làm được gì

| Claude làm được | Claude không làm được |
|---|---|
| Đọc code, tìm module ứng với thông báo lỗi `{Document.X.ObjectModule(25)}` | Tự bấm chạy chương trình, tự nhập dữ liệu thử |
| Chạy `check`, đọc lỗi cú pháp, giải thích theo giáo trình | Tự điều khiển debugger (đặt breakpoint, step) |
| Gợi ý **chỗ đặt breakpoint** và **biểu thức cần xem** | Nhìn thấy màn hình 1C của bạn |
| Phân tích giá trị biến, nội dung Event log bạn gửi lại | Sửa metadata, form (phần đó bạn làm trong Designer) |
| Sửa file `.bsl` khi bạn đồng ý và chính sách cho phép | Giải hộ bài thực hành của giáo trình |

## Hai loại lỗi

**Lỗi cú pháp / biên dịch** — chạy `check` là thấy, ví dụ *Variable is not defined*, *Procedure or function with the specified name is not defined*. Cách nhanh nhất:

> Chạy check rồi giải thích các lỗi giúp mình.

**Lỗi khi chạy (runtime) hoặc chạy sai kết quả** — `check` không bắt được, ví dụ *Object field not found*, post xong register không có dòng nào, tồn kho bị âm. Bạn cần cho Claude biết:

1. **Nguyên văn thông báo lỗi** (chụp hoặc copy cả dòng `{...(số dòng)}`).
2. **Bạn vừa làm gì**: mở form nào, nhập gì, bấm nút nào.
3. **Bạn mong đợi gì** và **thực tế ra sao**.

Mẫu câu hỏi:

> Khi mình post document GoodsReceipt thì báo lỗi:
> `{Document.GoodsReceipt.ObjectModule(31)}: Object field not found (Quantity)`
> Mình vừa thêm tabular section Products có cột Qty. Mình muốn post xong thì sổ kho tăng số lượng.

> Post SalesInvoice không báo lỗi gì nhưng mở Register records thì trống. Mình làm bài tập lớn lộ trình MIS.

## Vòng gỡ lỗi với breakpoint (mức cơ bản)

Khi Claude cần biết giá trị thật lúc chạy, nó sẽ đề nghị bạn đặt breakpoint. Làm trong Designer:

1. Đóng 1C:Enterprise nếu đang mở. Mở Designer (task **designer**).
2. Mở module Claude chỉ, **double-click vùng xám bên trái** dòng cần dừng (hoặc *Debug → Breakpoint*) để đặt breakpoint.
3. **F5** (*Debug → Start debugging*) — 1C:Enterprise mở ra, thao tác lại đến chỗ lỗi.
4. Chương trình dừng ở breakpoint. **Shift+F9** (*Evaluate expression*) để xem biểu thức Claude gợi ý; *Debug → Step Over / Step In* để chạy tiếp từng dòng; *Local Variables* để xem mọi biến của procedure.
5. Copy kết quả gửi lại cho Claude.

Mẫu:

> Mình dừng ở dòng 31 như bạn nói. `Products.Count()` = 2, `ThisObject.Products[0].Qty` = 5. Tiếp theo xem gì?

Muốn dừng đúng dòng phát sinh lỗi mà không cần biết trước: trong Designer mở *Debug → Stop on errors*, tick **Stop on error** rồi chạy lại.

Chi tiết về debugger: Bài 8 của giáo trình. Event log: Bài 12.

## Khi nào Claude sửa code giúp, khi nào chỉ gợi ý

Theo chính sách của skill:

- **Bài thực hành của giáo trình (24 bài và Extensions):** Claude chỉ gợi ý theo từng bậc và chỉ ra vùng lỗi, loại lỗi. Bạn tự sửa. Đây là bài dùng để đánh giá, nên đừng cố "xin" lời giải.
- **Bài tập lớn, dự án tự xây dựng, công việc thực tập:** Claude giải thích nguyên nhân rồi hỏi bạn muốn tự sửa hay để nó sửa. Mức đưa code phụ thuộc lộ trình (J, M, D) — Claude sẽ hỏi bạn đang học lộ trình nào ở câu đầu.
- Dù Claude sửa, **đọc kỹ phần thay đổi** trước khi chấp nhận (VS Code hiển thị so sánh trước/sau). Hỏi lại dòng nào chưa hiểu.

## Câu hỏi hay dùng

| Muốn | Gõ |
|---|---|
| Hiểu một module | *Giải thích module `src/cf/Documents/SalesInvoice/Ext/ObjectModule.bsl` theo từng procedure.* |
| Hiểu một luồng | *Khi post SalesInvoice thì những procedure nào chạy, theo thứ tự nào?* |
| Review trước khi nộp | *Review code mình vừa sửa (git diff) theo chuẩn của khóa.* |
| Ôn khái niệm | *Giải thích lại `&AtServer` và `&AtClient`, ví dụ trên form SalesInvoice của mình.* |
| Kiểm tra sau sửa | *Chạy check, nếu sạch lỗi thì nhắc mình bước tiếp theo.* |

## Quyền của Claude trong dự án

File `.claude/settings.json` đặt sẵn:

- **Tự chạy, không hỏi:** `doctor`, `check`, `dump`; đọc `src/` và `logs/`.
- **Phải hỏi bạn:** `apply`, `restore-dt`, sửa file `.xml` trong `src/cf`, `git commit`, `git push`.
- **Không được:** đọc `1c.env` (có mật khẩu), đọc/sửa thư mục `ib/`.

Mỗi lần Claude xin quyền, đọc lệnh trước khi bấm đồng ý.
