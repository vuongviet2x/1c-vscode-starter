# 06 — Làm việc nhóm qua Git

Phần làm trong Designer **đưa lên Git được**, thông qua `dump`. Mỗi người có một infobase riêng trên máy mình. Phần dùng chung của cả nhóm là thư mục `src/cf` trên một repo GitHub:

```
Máy A: Designer ─dump─▶ src/cf ─push─▶  GitHub (repo nhóm)  ─pull─▶ src/cf ─apply─▶ Designer :Máy B
```

Không chia sẻ thư mục `ib` qua Drive hay USB: infobase dạng file không dùng chung an toàn được, và Git không lưu nó.

## 1. Phiên bản platform của nhóm

Định dạng file mà `dump` xuất ra phụ thuộc phiên bản platform. Một bản platform **cũ hơn** có thể không nạp được file do bản **mới hơn** xuất ra. Vì vậy:

- Cả nhóm dùng cùng **8.3.25.x**. Số cuối (`1445`, `1560`…) khác nhau không sao.
- Phiên bản chung ghi trong file **`.1c-platform`** ở thư mục gốc (mặc định `8.3.25`). File này lên Git, nên cả nhóm cùng đọc một giá trị.
- Mỗi lệnh đều so platform trên máy bạn với file này. Khác bản thì in **cảnh báo**; riêng `dump` sẽ **dừng**, vì dump bằng bản khác có thể làm cả nhóm không nạp được.
- Máy có nhiều bản platform: chọn bản 8.3.25 trong `1c.env` (`V8_VERSION` hoặc `V8_PATH`).
- Nhóm muốn chuyển cả sang bản khác: một người sửa `.1c-platform`, commit, push. Mọi người cài bản đó rồi `git pull`.

Chạy `doctor` để xem: dòng `Platform: 8.3.25.1560` và `Dung phien ban chung cua nhom: 8.3.25.x`.

## 2. Thiết lập lần đầu

**Trưởng nhóm (một lần):**

1. Trên trang GitHub của bộ khởi động, bấm **Use this template → Create a new repository**. Đặt tên, ví dụ `nhom3-btl-1c`, nên chọn **Private**.
2. Repo mới → **Settings → Collaborators → Add people** → mời tài khoản GitHub của từng thành viên.
3. Clone repo nhóm về máy, làm Phần B của hướng dẫn: `doctor` → tạo infobase (`restore-dt` với file `.dt` của đề, hoặc `new-ib`) → `dump`.
4. Đưa lên:
   ```
   git add .
   git commit -m "Cau hinh ban dau cua nhom"
   git push
   ```

**Mỗi thành viên:**

1. Chấp nhận lời mời trong email GitHub.
2. Clone **repo nhóm** (không phải repo bộ khởi động gốc). Làm `doctor`, sửa `1c.env`.
3. Tạo infobase giống trưởng nhóm: cùng file `.dt` → `restore-dt`; cấu hình trống → `new-ib`.
4. Chạy **`apply`** để nạp cấu hình của nhóm từ `src/cf` vào infobase của mình. Không chạy `dump` ở bước này, vì dump lúc này sẽ ghi đè `src/cf` bằng cấu hình gốc chưa có phần của nhóm.

## 3. Vòng làm việc mỗi ngày

| Khi | Làm |
|---|---|
| **Trước khi bắt đầu** | `git pull` → `apply` (lấy phần mới của cả nhóm vào infobase của bạn) |
| Trong khi làm | Như bình thường: sửa Designer → đóng → `dump`; sửa VS Code → `check` |
| **Xong một phần chạy được** | `git add .` → `git commit -m "..."` → `git pull` → có thay đổi mới thì `apply` và thử lại → `git push` |

Hai thói quen tránh gần hết sự cố:

- **Luôn `git pull` + `apply` trước khi mở Designer.** Sửa trong Designer trên cấu hình cũ, rồi `dump`, là bạn xóa mất phần người khác vừa đẩy lên.
- **Push sớm, push nhỏ.** Mỗi lần thêm xong một object hoặc một chức năng chạy được thì push, đừng gom cả tuần.

## 4. Chia việc để ít xung đột

Git gộp tự động khi hai người sửa **hai file khác nhau**. Xung đột xảy ra khi cùng sửa một chỗ.

- **Mỗi người phụ trách object riêng**, ví dụ An: `Catalog.Products`, `Document.GoodsReceipt`; Bình: `Document.SalesInvoice`. Ghi bảng phân công vào README của repo nhóm.
- **Phần dùng chung** (register, common module, role, subsystem, `Configuration.xml`) chỉ một người sửa tại một thời điểm, và báo nhóm trước.
- **Thêm object mới** luôn làm `Configuration.xml` thay đổi, vì file này giữ danh sách object. Trình tự: `git pull` + `apply` → thêm object → `dump` → commit → push ngay.

## 5. Khi bị xung đột (conflict)

`git pull` báo `CONFLICT` nghĩa là hai người sửa cùng một chỗ.

1. Mở *Source Control* trong VS Code. File xung đột nằm ở mục *Merge Changes*, mở từng file.
2. Cách chọn:
   - `Configuration.xml`, file subsystem, danh sách quyền: thường là **cả hai** cùng thêm một dòng → chọn **Accept Both**.
   - File `.bsl`: đọc kỹ cả hai phía rồi mới chọn. Không chắc thì hỏi người kia.
   - Có thể nhờ Claude: *"Mình bị conflict ở src/cf/Configuration.xml sau git pull. Giải thích hai phía và đề xuất cách giữ thay đổi của cả hai."*
3. Lưu, rồi **`check`**. Phải sạch lỗi mới tiếp.
4. `git add .` → `git commit` → `apply` để thử chạy → `git push`.

Rối quá: `git merge --abort` để quay về trạng thái trước khi pull, rồi gọi người kia cùng xử lý.

## 6. Những gì KHÔNG đi qua Git

| Thứ | Vì sao | Muốn chia sẻ thì |
|---|---|---|
| Dữ liệu nhập thử (chứng từ, danh mục) | Nằm trong `ib`, mỗi máy một bộ | Designer → *Administration → Dump infobase* ra `.dt`, gửi qua Drive; người nhận chạy `restore-dt` rồi `git pull` + `apply` |
| `1c.env` | Cấu hình và mật khẩu riêng từng máy | Không chia sẻ |
| Skill gia sư | Không được đăng công khai | Mỗi người tự cài từ file ZIP giảng viên gửi |
| `src/cf/ConfigDumpInfo.xml` | File riêng của từng máy, đưa lên sẽ xung đột liên tục | Đã có trong `.gitignore` |

Designer cũng có công cụ làm nhóm riêng là *configuration repository*. Công cụ này cần một thư mục hoặc server dùng chung, nên khóa học dùng Git như trên.
