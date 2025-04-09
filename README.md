<p align="center">
  <img src="https://github.com/user-attachments/assets/c6772960-8dbc-4a97-ba69-4d5aa3cd34cb" width="240">
</p>


<p align="center">
  <img src="https://github.com/user-attachments/assets/48fc3878-5f5e-497a-acec-48b4fac40ba4" width="120" height="120">
</p>

<p align="center">
    <a href="https://play.google.com/store/apps/details?id=com.bulmang.green_field">
        <img src="https://github.com/user-attachments/assets/3c6c240d-b4fb-4721-a2e7-b7c84f24625f" width="200" height="80">
    </a>
    <a href="https://apps.apple.com/kr/app/%ED%92%80%EB%B0%AD-%EC%83%88%EC%8B%B9%EC%9D%B4%EB%93%A4-%EC%84%9C%EC%9A%B8%EC%B2%AD%EB%85%84%EC%B7%A8%EC%97%85%EC%82%AC%EA%B4%80%ED%95%99%EA%B5%90-%EA%B0%95%EC%9D%98%EC%83%9D%EB%93%A4-%EC%9D%98-%EB%AA%A8%EC%9E%84/id6743421356">
        <img src="https://github.com/user-attachments/assets/fc9a09fe-5a04-4141-b207-05eb6fdd11e2" width="200" height="80">
    </a>
</p>

---


## 🚀 기능 소개
### 📢 캠퍼스별 공지사항 & 💬 실시간 채팅
![Slide 16_9 - 10](https://github.com/user-attachments/assets/2c7d67dd-0655-447d-a4e9-ccabb0c65216)
### 📄 게시글과 댓글 & 🏫 캠퍼스별 정보
![Slide 16_9 - 9](https://github.com/user-attachments/assets/ca28eddf-ba4b-47cc-be91-5d7c1992f39a)

<br>

## 🏗️ 아키텍처
각 계층은 독립적으로 동작하며, 상위 계층이 하위 계층에만 의존하도록 설계했습니다. 이를 통해 결합도를 최소화하고 테스트 및 유지보수성을 높였습니다.
#### 🥞 계층 구조
`View → ViewModel → Repository → Service`
- 의존성 방향: 상위 계층만 하위 계층을 참조합니다.
- 정보 은닉: 하위 계층은 상위 계층의 존재를 알지 못합니다.
#### 📋 계층별 역할 표

| 계층          | 역할                                                                 | 의존성 방향          | 정보 은닉 원칙       | 예시                                                                 |
|---------------|----------------------------------------------------------------------|----------------------|----------------------|----------------------------------------------------------------------|
| **View**      | - UI 렌더링<br>- 사용자 입력 처리<br>- 상태 변화 반영               | ← ViewModel          | 하위 계층 모름       | `HomeView()`, `LoginView()`, `PostView()`                    |
| **ViewModel** | - 비즈니스 로직 실행<br>- 상태 관리<br>- Repository와 통신          | ← Repository         | Service 계층 모름    | `HomeViewModel`, `LoginViewModel`, `PostViewModel`             |
| **Repository**| - 데이터 가공<br>- Service ↔ ViewModel 간 중개<br>- 도메인 로직 적용 | ← Service            | 외부 데이터 소스 모름 | `PostRepository`, `LoginRepository`, `NoticeRepository`           |
| **Service**   | - 외부 시스템 통신<br>- 데이터 CRUD 처리<br>- API/DB 연동           | ← 외부 데이터 소스   | 상위 계층 모름       | `FirebaseAuthService`, `FirebaseStorageService`, `FirebaseStoreService`       |
| **Model**     | - 데이터 구조 정의<br>- DTO/Entity 관리                             | 모든 계층에서 참조*  | 계층 무관           | `User(id, name, ...)`, `Potcie(title, body, ...)`, `Message(id, text, ...)`    |

\* Model은 순수 데이터 클래스로, 특정 계층에 종속되지 않습니다.

![풀밭_아키텍처 (4)](https://github.com/user-attachments/assets/dfe6baf2-c632-4e97-95c1-e11c938b770d)

<br>

## 🛡 에러 핸들링 (Result Pattern 적용)

Flutter에서 **Result Pattern**을 사용해 네트워크 통신 과정의 에러를 효율적으로 처리했습니다.  
아래 흐름대로 각 계층(View → ViewModel → Repository → Service)에서 일관된 에러 핸들링이 가능합니다.
성공시 지정한 데이터 타입의 객체가 반환됩니다.

- `sealed class`로 컴파일 타임 안전성 보장  
- 모든 경우의 수 처리 강제 (`Success`/`Failure`)

#### 🌐 계층별 에러 처리 예시 간편 로그인(네트워크 통신)

#### 🔄 에러 핸들링 흐름
![Error_Handler](https://github.com/user-attachments/assets/97c9a5ec-d05c-4570-bdc8-78013a69fffa)


## 🛣️ 라우팅 아키텍처 

### ❓ GoRouter 선택 이유
- **선언적 라우팅**: 복잡한 네비게이션 시나리오(로그인 전환, 딥링크)를 간결하게 관리할 수 있습니다.
- **Riverpod 연동**: 상태 변화에 반응하는 동적 리다이렉트 로직 구현이 용이합니다.

### ⚙️ 주요 기능 구현
1. **인증 상태 기반 라우팅**  
   - `GoRouterRefreshStream`으로 Riverpod의 인증 상태(`authStateProvider`)를 실시간 감지합니다.  
   - 인증 상태에 따라 `/login`, `/home` 등으로 자동 리다이렉트됩니다.

2. **StatefulShellRoute를 활용한 탭 구조**  
   - **독립적 네비게이션 스택**: 각 탭(홈, 검색, 프로필)마다 별도의 네비게이션 히스토리를 유지합니다.  
   - **지속적 UI**: 하단 탭 바가 모든 서브 경로에서 유지되도록 설계했습니다.  
   - **딥링크 지원**: `/profile/detail/:id`와 같은 경로로 직접 접근 가능합니다.

![네비게이션](https://github.com/user-attachments/assets/eea06a48-a4d4-40b5-86c1-ccd2041b2dd1)

<br>

## 📚 개발 기록
프로젝트 구현 과정에서 작성한 문서입니다. 각 주제를 클릭하면 해당 포스트로 이동합니다.

- [[Flutter] RiverPod - Loading 상태 처리하기(with Lottie & Skeleton)](https://bulmang-ios.tistory.com/191)
- [[Flutter] RiverPod - Data 상태 관리하기](https://bulmang-ios.tistory.com/189)
- [[Flutter] Riverpod 학습 - Performing side effects & Passing arguments to your requests](https://bulmang-ios.tistory.com/188)
- [[Flutter] RiverPod - provider 알아보기(with 네트워크 요청)](https://bulmang-ios.tistory.com/187)
- [[Flutter] RiverPod 학습 - State management](https://bulmang-ios.tistory.com/182)
- [[Flutter] [Error Handling] Result Pattern (간편로그인 적용)](https://bulmang-ios.tistory.com/173)
- [[Flutter] [Error Handling] Result Pattern](https://bulmang-ios.tistory.com/171)
- [[Flutter] [Firbase] 간편 로그인 구현하기(Apple🍎)](https://bulmang-ios.tistory.com/170)
- [[Flutter] [Firbase] 간편 로그인 구현하기(kakao💬)](https://bulmang-ios.tistory.com/165)
- [[Flutter] DesignSystem 트러블슈팅](https://bulmang-ios.tistory.com/154)
- [[Flutter] URL Navigation(with Go_router) 개발 정리](https://bulmang-ios.tistory.com/149)
- [[Flutter] DynamicTabBar 트러블 슈팅](https://bulmang-ios.tistory.com/143)
- [[Flutter] Dynamic TabBar on ScrollView & NaverMap URL Scheme 사용 방법](https://bulmang-ios.tistory.com/140)
- [[Flutter] WhiteScreen 해결(iPhone 무선빌드) & Load Sequence Flutter](https://bulmang-ios.tistory.com/139)

<br>

#### 💻 개발 환경 
<div style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: center;">
    <img src="https://img.shields.io/badge/Dart-3.6.1-0175C2?style=for-the-badge&logo=Dart&logoColor=white">
    <img src="https://img.shields.io/badge/Flutter-3.27.2-02569B?style=for-the-badge&logo=Flutter&logoColor=white">
</div>


#### 🔑 로그인  
- **카카오/애플 로그인**: 한국 사용자 편의성 + iOS 앱스토어 심사 규정 준수  
- `kakao_flutter_sdk_user`, `sign_in_with_apple`
<div style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: center;">
    <img src="https://img.shields.io/badge/kakao__flutter__sdk__user-1.9.5-FEE500?style=for-the-badge&logo=KakaoTalk&logoColor=black">
    <img src="https://img.shields.io/badge/sign__in__with__apple-6.1.2-000000?style=for-the-badge&logo=Apple&logoColor=white">
</div>


#### 📡 Firebase  
- **실시간 DB/인증/스토리지**: 백엔드 구축 필요 없음.
- `firebase_core`, `cloud_firestore`, `firebase_auth`, `firebase_storage`
<div style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: center;">
    <img src="https://img.shields.io/badge/firebase__core-3.10.0-FFCA28?style=for-the-badge&logo=Firebase&logoColor=white">
    <img src="https://img.shields.io/badge/cloud__firestore-5.6.1-FFCA28?style=for-the-badge&logo=Firebase&logoColor=white">
    <img src="https://img.shields.io/badge/firebase__auth-5.4.0-FFCA28?style=for-the-badge&logo=Firebase&logoColor=white">
    <img src="https://img.shields.io/badge/firebase__storage-12.4.0-FFCA28?style=for-the-badge&logo=Firebase&logoColor=white">
</div>


#### ⚙️ 유틸리티  
- **상태 관리**: `riverpod`으로 깔끔한 DI  
- **탭/딥링크**: `go_router`로 복잡한 네비게이션 처리  
- **날짜/URL**: `wheel_picker`, `url_launcher`로 사용성 향상  
<div style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: center;">
    <img src="https://img.shields.io/badge/wheel__picker-0.1.1-607D8B?style=for-the-badge&logo=Flutter&logoColor=white">
    <img src="https://img.shields.io/badge/carousel__slider-5.0.0-607D8B?style=for-the-badge&logo=Flutter&logoColor=white">
    <img src="https://img.shields.io/badge/url__launcher-6.3.1-607D8B?style=for-the-badge&logo=Flutter&logoColor=white">
    <img src="https://img.shields.io/badge/intl-0.19.0-607D8B?style=for-the-badge&logo=Dart&logoColor=white">
    <img src="https://img.shields.io/badge/go__router-14.6.1-607D8B?style=for-the-badge&logo=Dart&logoColor=white">
    <img src="https://img.shields.io/badge/flutter__dotenv-5.2.1-607D8B?style=for-the-badge&logo=Dart&logoColor=white">
    <img src="https://img.shields.io/badge/flutter__riverpod-2.6.1-42A5F5?style=for-the-badge&logo=Dart&logoColor=white">
    <img src="https://img.shields.io/badge/riverpod__annotation-2.6.1-42A5F5?style=for-the-badge&logo=Dart&logoColor=white">
</div>


#### 🎨 UI/애니메이션  
- **Lottie**: 가벼운 로딩 애니메이션  
- **Skeletonizer**: 데이터 대기 중 UI 자연스러운 전환  
<div style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: center;">
    <img src="https://img.shields.io/badge/skeletonizer-1.4.3-BDBDBD?style=for-the-badge&logo=Dart&logoColor=white">
    <img src="https://img.shields.io/badge/lottie-3.1.3-FC5185?style=for-the-badge&logo=LottieFiles&logoColor=white">
</div>

#### 🖼️ 이미지/데이터  
- **Cached NetworkImage**: 이미지 캐싱으로 속도 2배 ↑  
- **Image Compress**: 업로드 용량 80% ↓  
<div style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: center;">
    <img src="https://img.shields.io/badge/uuid-4.5.1-BDBDBD?style=for-the-badge&logo=Dart&logoColor=white">
    <img src="https://img.shields.io/badge/fluttertoast-8.2.10-BDBDBD?style=for-the-badge&logo=Dart&logoColor=white">
    <img src="https://img.shields.io/badge/cached__network__image-3.4.1-BDBDBD?style=for-the-badge&logo=Dart&logoColor=white">
    <img src="https://img.shields.io/badge/flutter__image__compress-2.4.0-BDBDBD?style=for-the-badge&logo=Dart&logoColor=white">
</div>

#### 🌐 웹  
- **Flutter Web Frame**: 모바일 ↔ 웹 레이아웃 자동 최적화
<div style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: center;">
    <img src="https://img.shields.io/badge/flutter__web__frame-1.0.0-BDBDBD?style=for-the-badge&logo=Dart&logoColor=white">
</div>
