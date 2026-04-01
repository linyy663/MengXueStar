MengXueStar/
├── MengXueStar/               # iOS SwiftUI 源码
│   ├── App/
│   │   ├── MengXueStarApp.swift
│   │   └── AppDelegate.swift
│   ├── Core/
│   │   ├── Config/
│   │   │   └── AppConfig.swift
│   │   ├── Extensions/
│   │   │   ├── Color+Theme.swift
│   │   │   └── View+Extensions.swift
│   │   ├── Network/
│   │   │   ├── CloudBaseService.swift
│   │   │   ├── APIClient.swift
│   │   │   └── APIEndpoints.swift
│   │   ├── Storage/
│   │   │   └── UserDefaultsManager.swift
│   │   └── Utilities/
│   │       ├── SMSCodeTimer.swift
│   │       └── DateUtils.swift
│   ├── Models/
│   │   ├── User.swift
│   │   ├── ChildProfile.swift
│   │   ├── Course.swift
│   │   ├── DailyTask.swift
│   │   ├── Question.swift
│   │   ├── CheckInRecord.swift
│   │   ├── Badge.swift
│   │   └── ParentControl.swift
│   ├── Features/
│   │   ├── Login/
│   │   │   ├── LoginView.swift
│   │   │   └── LoginViewModel.swift
│   │   ├── Home/
│   │   │   ├── HomeView.swift
│   │   │   └── HomeViewModel.swift
│   │   ├── Courses/
│   │   │   ├── CourseListView.swift
│   │   │   ├── CourseDetailView.swift
│   │   │   └── CoursesViewModel.swift
│   │   ├── Learning/
│   │   │   ├── LearningView.swift
│   │   │   ├── QuestionView.swift
│   │   │   ├── CompletionView.swift
│   │   │   └── LearningViewModel.swift
│   │   ├── Profile/
│   │   │   ├── ProfileView.swift
│   │   │   ├── ChildProfileEditView.swift
│   │   │   └── ProfileViewModel.swift
│   │   └── ParentControl/
│   │       ├── ParentControlView.swift
│   │       ├── TimeLimitSettingView.swift
│   │       ├── SubjectToggleView.swift
│   │       └── ParentControlViewModel.swift
│   ├── Components/
│   │   ├── Buttons/
│   │   │   ├── PrimaryButton.swift
│   │   │   └── SubjectCardButton.swift
│   │   ├── Cards/
│   │   │   ├── CourseCard.swift
│   │   │   ├── BadgeCard.swift
│   │   │   └── ProgressCard.swift
│   │   ├── Input/
│   │   │   ├── PhoneTextField.swift
│   │   │   └── SMSCodeField.swift
│   │   ├── Feedback/
│   │   │   ├── CorrectAnimation.swift
│   │   │   ├── WrongAnimation.swift
│   │   │   └── ConfettiView.swift
│   │   └── Common/
│   │       ├── LoadingView.swift
│   │       └── ToastView.swift
│   ├── Navigation/
│   │   └── AppNavigator.swift
│   └── Resources/
│       ├── Assets.xcassets/
│       └── Info.plist
├── cloudbase/                  # 腾讯云CloudBase后端
│   ├── functions/
│   │   ├── sendSMS/
│   │   │   └── index.js
│   │   ├── verifySMS/
│   │   │   └── index.js
│   │   ├── login/
│   │   │   └── index.js
│   │   ├── getDailyTasks/
│   │   │   └── index.js
│   │   ├── submitAnswer/
│   │   │   └── index.js
│   │   ├── checkIn/
│   │   │   └── index.js
│   │   ├── getParentSettings/
│   │   │   └── index.js
│   │   └── updateParentSettings/
│   │       └── index.js
│   └── database/
│       └── schema.json
├── codemagic.yaml              # Codemagic CI/CD 配置
├── MengXueStar.xcodeproj/     # (生成后由xcodegen生成)
├── project.yml                # XcodeGen 配置
├── Podfile                    # CocoaPods依赖
└── README.md
