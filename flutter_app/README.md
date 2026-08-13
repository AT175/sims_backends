# SIMS — Flutter Edition

A Flutter rewrite of the School Information Management System (SIMS) for Ghanaian Senior High Schools.

## Getting Started

```bash
# Install Flutter (if not already installed)
# https://docs.flutter.dev/get-started/install

# Install dependencies
flutter pub get

# Run the app
flutter run

# Run on web
flutter run -d chrome

# Run on Windows
flutter run -d windows
```

## Project Structure

```
flutter_app/
├── lib/
│   ├── main.dart                         # Entry point — auth router + dashboard selection
│   ├── core/
│   │   ├── theme/
│   │   │   └── app_theme.dart            # Colors, spacing, typography, Material theme
│   │   ├── types/
│   │   │   ├── role_id.dart              # RoleId enum (38 roles) + label/value extensions
│   │   │   ├── models.dart               # AuthUser, LoginResponse, SyncEnvelope, enums
│   │   │   └── types.dart                # Barrel export
│   │   ├── api/
│   │   │   ├── api_client.dart           # HTTP client with JWT + tenant headers
│   │   │   ├── auth_api.dart             # Auth API endpoints (login, switchRole, etc.)
│   │   │   └── api.dart                  # Barrel export
│   │   ├── state/
│   │   │   ├── auth_provider.dart        # Auth state (login, logout, switchRole)
│   │   │   ├── app_models.dart           # Domain models (Student, Fee, Exam, etc.)
│   │   │   ├── registry_provider.dart    # Students, admissions, certificates, staff
│   │   │   ├── bursary_provider.dart     # Fees, payroll, expenditure, budget, invoices
│   │   │   ├── academic_provider.dart    # Exams, timetables, HOD approvals, curriculum
│   │   │   └── notification_provider.dart # In-app notification center
│   │   ├── navigation/
│   │   │   ├── role_map.dart             # RoleId → dashboard key mapping
│   │   │   └── dashboard_catalog.dart    # All 37 dashboards + pages definitions
│   │   ├── widgets/
│   │   │   ├── dashboard_layout.dart     # Responsive sidebar + header + content layout + profile modal
│   │   │   ├── notification_center.dart  # Notification bell dropdown with unread badges
│   │   │   └── widgets.dart              # StatCard, StatCardGrid, AppDataTable, SectionCard, PlaceholderPage
│   └── features/
│       ├── login/
│       │   └── login_screen.dart         # Login + admission application + status check
│       ├── dashboard/
│       │   └── dashboard_router.dart     # Routes to correct dashboard by role
│       ├── dashboards/
│       │   ├── headmaster_dashboard.dart # 11 pages — overview, oversight, staff, approvals, reports, etc.
│       │   ├── academic_dashboard.dart   # 14 pages — overview, monitor, exams, timetable, SPIP, curriculum, etc.
│       │   ├── bursary_dashboard.dart    # 11 pages — overview, cashbook, fees, budget, invoices, etc.
│       │   ├── accountant_dashboard.dart # 10 pages — fees, payroll, expenditure, budget, reports, etc.
│       │   ├── registry_dashboard.dart   # 7 pages — students, admissions, certificates, correspondence, etc.
│       │   ├── generic_dashboard.dart    # Fallback for remaining 31 dashboards with contextual stats
│       │   └── dashboards.dart           # Barrel export
│       └── verification/
│           └── verification_dashboard.dart  # Voter/temp login dashboard
├── pubspec.yaml
└── analysis_options.yaml
```

## Architecture

- **Provider** for state management (mirrors Zustand stores from RN app)
- **Material 3** with custom theme matching the RN app's color palette
- **Responsive**: Sidebar on desktop (≥900px), drawer on mobile
- **Role-based**: Auth router selects dashboard based on `activeRole`
- **37 dashboards** defined in `dashboard_catalog.dart` — 5 fully implemented, 32 use generic dashboard with contextual stats

## Implemented

| Feature | Status |
|---|---|
| Project scaffold + theme | ✅ |
| Types (RoleId, AuthUser, SyncEnvelope, domain models) | ✅ |
| API client + auth API | ✅ |
| Auth provider (login, logout, switchRole) | ✅ |
| State stores (registry, bursary, academic, notification) | ✅ |
| Dashboard catalog (37 dashboards, 280+ pages) | ✅ |
| DashboardLayout (sidebar, header, role switcher, profile modal) | ✅ |
| LoginScreen (staff login, voter login, admission application) | ✅ |
| DashboardRouter (role → dashboard routing) | ✅ |
| VerificationDashboard (voter temp login) | ✅ |
| Headmaster dashboard (11 pages, full data) | ✅ |
| Academic dashboard (14 pages, full data) | ✅ |
| Bursary dashboard (11 pages, full data) | ✅ |
| Accountant dashboard (10 pages, full data) | ✅ |
| Registry dashboard (7 pages, full data) | ✅ |
| Remaining 31 dashboards (generic with contextual stats) | ✅ |
| Notification center dropdown (bell icon, unread badges, mark read) | ✅ |
| Profile editing modal (edit name, change password, demo-mode support) | ✅ |
| Access control store (page-level permissions) | ✅ |
| CRUD form modals for Academic dashboard (exams, timetable, curriculum, calendar, HOD approvals, report cards, transcripts, PLC requisitions) | ✅ |

## Next Steps

1. Build out remaining 31 dashboards with full page implementations
2. Wire up API calls to replace mock data with live backend data
3. Implement offline-first sync with local SQLite (drift/sqflite)
4. Add CRUD form modals to remaining dashboards (Bursary, Registry, Headmaster, etc.)
5. Add PDF report generation
6. Add sync status indicator with pending change count
