# 04 — Debug nâng cao: breakpoint ngay trong VS Code

Mức này **không bắt buộc**. Làm khi bạn đã quen mức cơ bản (`dump` / `check` / `apply` chạy trơn tru) và muốn đặt breakpoint, xem biến, step từng dòng mà không phải chuyển sang Designer.

Công cụ dùng ở đây là extension cộng đồng **1C: Platform Tools** (`yellow-hammer.1c-platform-tools`). Nó nối VS Code với debug server HTTP của platform (`dbgs`, cổng mặc định 1550). Đây không phải công cụ chính thức của 1C; nếu gặp trục trặc, quay về debug trong Designer như ở [03](03-go-loi-cung-claude.md).

> **Giảng viên:** hãy chạy thử toàn bộ trang này trên một máy Windows và một máy macOS với bản platform lớp đang dùng trước khi phát cho lớp. Sửa `platformVersion` trong `launch.json` cho đúng bản đó.

## Cần cài thêm

1. **.NET 8 Runtime** — debug adapter của extension chạy trên .NET 8: https://dotnet.microsoft.com/download/dotnet/8.0 (chọn *.NET Runtime*).
2. Extension **1C: Platform Tools**: Extensions → tìm `1C: Platform Tools` (tác giả yellow-hammer) → Install.
3. **OneScript, OPM, vanessa-runner** — cài từ chính extension: mở panel *1C: Tools* ở thanh bên → mục *Dependencies* → cài các thành phần được liệt kê.

## Cấu hình dự án

Extension chỉ kích hoạt khi thư mục dự án có file **`packagedef`** ở thư mục gốc. Dùng mục *Service files* trong panel *1C: Tools* để tạo các file dịch vụ (packagedef, launch profile…) nếu extension đề nghị; giữ đường dẫn mã nguồn là `src/cf` — đúng với cấu trúc của bộ khởi động.

1. Sao chép `docs/samples/env.json` ra thư mục gốc dự án. Điền `--db-user`, `--db-pwd` nếu infobase có user. File này chứa mật khẩu nên đã được Git bỏ qua.
2. Sao chép `docs/samples/launch.json` vào `.vscode/launch.json`. Xóa cấu hình của hệ điều hành bạn không dùng. Sửa `platformVersion` nếu bạn cài bản khác.

   Hoặc để extension tự tạo: *Run and Debug* (`Ctrl+Shift+D`) → *create a launch.json file* → chọn **1Cpt: Enterprise Debugger**.

## Debug

1. **Nạp code mới nhất vào infobase trước** (task **apply**). Debugger chạy code trong infobase; nếu `src/cf` khác infobase, breakpoint sẽ lệch dòng hoặc không dừng.
2. Đóng Designer và 1C:Enterprise nếu đang mở.
3. Mở file `.bsl`, bấm vào lề trái cạnh số dòng để đặt breakpoint (chấm đỏ).
4. **F5** → chọn cấu hình `1C: Debug (...)`. Extension tự khởi động debug server và mở 1C:Enterprise.
5. Thao tác trong 1C:Enterprise đến chỗ cần kiểm tra. VS Code dừng ở breakpoint:
   - Panel **Variables**: giá trị biến; panel **Watch**: thêm biểu thức cần theo dõi.
   - **Debug Console**: gõ biểu thức để tính (giống *Evaluate expression*).
   - **F10** step over, **F11** step into, **Shift+F11** step out, **F5** chạy tiếp.
6. **Shift+F5** dừng phiên debug (cửa sổ 1C:Enterprise vẫn mở, đóng tay).

Có thể đặt breakpoint có điều kiện (chuột phải chấm đỏ → *Edit Breakpoint*), sửa giá trị biến trong panel Variables, và debug cả extension, external data processor.

## Kết hợp với Claude

Khi đang dừng ở breakpoint, copy giá trị trong Variables / Debug Console gửi cho Claude:

> Mình đang dừng ở dòng 42 của `Documents/SalesInvoice/Ext/ObjectModule.bsl`. Variables: `Selection.Quantity = 0`, `Selection.Product = <Empty>`. Vì sao query không lấy được dữ liệu?

Extension còn có MCP server và skill cho AI agent (cho phép Claude gọi lệnh của extension). Bộ khởi động chưa bật phần này; các lệnh `check` / `dump` của bộ khởi động đã đủ cho việc học.

## Nếu không chạy

| Triệu chứng | Thử |
|---|---|
| Không thấy *1Cpt: Enterprise Debugger* | Thư mục gốc chưa có `packagedef`; mở lại VS Code sau khi tạo |
| Báo thiếu .NET | Cài .NET 8 Runtime, khởi động lại VS Code |
| Breakpoint rỗng (vòng tròn xám), không dừng | Chưa **apply**; hoặc dòng đó không phải dòng code chạy được (comment, dòng trống) |
| Variables trống khi dừng | Server chậm: tăng `"calcWaitingTimeMs": 500` trong cấu hình launch |
| Không kết nối được debug server | Cổng 1550 bị chiếm hoặc firewall chặn; tắt phiên Designer đang debug |
