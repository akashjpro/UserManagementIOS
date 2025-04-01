
#  Project User Management iOS: List, Detail, Add, Update Screens with MVVM

## 1. Cấu trúc Dự Án

Dự án này được phát triển bằng **iOS Native** (Swift), với mô hình **MVVM** (Model-View-ViewModel) để quản lý logic và dữ liệu dễ dàng.
Kiến trúc **Clean Architecture** được áp dụng với 3 lớp: **Presentation**, **Domain**, **Data**.
### Các thành phần chính:
- **Presentation**: Quản lý UI .
- **Domain**: Xử lý logic business.
- **Data**: Xử lý Data.

### Các màn hình chính:
- **Màn hình home (Home)**: Hiển thị danh sách User.
- **Màn hình add (AddScreen)**: Thêm user.
- **Màn hình edit (EditScreen)**: Cập nhập user.
- **Màn hình detail (DetailScreen)**: Hiển thị chi tiết thông tin User.

### Cấu trúc thư mục
```
UserManagement
│── Core
│   ├── Enums/                  # Enum dùng chung
│   ├── Resource/               # Resource (Localizable, Assets)
│   ├── Extensions/             # Các extension hỗ trợ
│
│── Presentation
│   ├── ViewModel/              # ViewModel (MVVM)
│   ├── Views/                  # UI - SwiftUI/UIKit
│
│── Domain
│   ├── Usecase/                # Use Cases
│
│── Application                 # Cấu hình Application
│
│── Data
│   ├── Service/                # Services (API, Database)
│   ├── Repository/             # Repository Layer
│   ├── Entities/               # Entities (Models)
│
│── Assets                      # Hình ảnh, màu sắc
│── Preview Content             # Dữ liệu preview SwiftUI
│── Tests                       # Unit tests
│
├── UserManagement.xcodeproj    # Project Xcode
└── Info.plist                   # Cấu hình ứng dụng
```

### Link demo app: https://drive.google.com/file/d/1B9b2Zpv1mRc-qyJg3Zk3Gf86hC17BRBc/view?usp=sharing
