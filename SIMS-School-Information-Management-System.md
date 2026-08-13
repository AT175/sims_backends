# SIMS — School Information Management System

A multitenant, offline-first cross-platform application for managing a Ghanaian Senior High School, built with **React Native + TypeScript** (strict typing, no plain JavaScript files) — targeting **PC (Windows/macOS) as the primary platform**, with **mobile (Android/iOS) as the secondary platform**, from one shared codebase. Every component in the school's supervision structure gets its own role-scoped dashboard, made up of specific pages that support that component's day-to-day duties.

---

## 1. Product overview

- **Multitenant**: one codebase and one deployed app serve many schools ("tenants"). Each school's data is fully isolated from every other school's.
- **PC-first, mobile-second**: the school office (Headmaster, Bursary, Registry, Stores, etc.) runs the app on a Windows/macOS desktop as the primary, day-to-day machine. Roles that need to move around the compound (Security gate log, Boarding house roll call, Sick bay, Transport, SRC/Electoral Commission voting) get a fully-featured mobile companion app targeting the same dashboards.
- **Offline-first**: every dashboard works fully without internet — data is read from and written to a local database first, whether the device is a desktop or a phone. When network becomes available, the app synchronizes automatically in the background.
- **Role-based dashboards**: a user logs in and sees only the dashboard(s) that match their role in the school (e.g. a Housemistress sees the Boarding Houses dashboard; the Headmaster sees an aggregated view of everything).
- **One school, many roles**: the same app installation serves every role in the school — what a user sees is determined entirely by their assigned role(s), not by a different app build.

---

## 2. Technical architecture

### 2.1 Tech stack

| Layer | Choice | Notes |
|---|---|---|
| App framework | React Native (TypeScript, strict mode) | No `.js`/`.jsx` files — `.ts`/`.tsx` only, with `strict: true` in `tsconfig.json` |
| Desktop target (primary) | React Native for Windows + React Native for macOS | Runs the same component/dashboard code as a native desktop app |
| Mobile target (secondary) | React Native (iOS + Android) | Standard React Native, same shared dashboard modules |
| Navigation | React Navigation (typed stacks) | Each dashboard is its own typed navigation stack/module; layout adapts to desktop (sidebar) vs. mobile (tab/stack) screen sizes |
| State management | Zustand or Redux Toolkit (typed) | Per-dashboard slices/stores, shared across all platform targets |
| Local database | WatermelonDB (SQLite-backed) or op-sqlite | Chosen specifically for offline-first, sync-friendly design; works identically on desktop and mobile |
| Backend API | Node.js + TypeScript (NestJS) | REST or GraphQL, tenant-aware middleware on every request |
| Server database | PostgreSQL | `tenant_id` scoping on every table, or schema-per-tenant for larger deployments |
| Auth | JWT (access + refresh tokens), tenant + role claims embedded | PIN/biometric app-lock on mobile; PIN/password lock on desktop, for offline access |
| File/media | Local cache-first, background upload to cloud object storage | Photos (ID cards, documents), scanned forms, etc. |
| Sync engine | Custom pull/push sync layer (or WatermelonDB's built-in sync adapter) | Change-log based, timestamped, per-record versioning; identical protocol regardless of platform |

### 2.2 Platform strategy — PC first, mobile second

- **Single shared codebase**: dashboards, navigation logic, data models, and the sync engine live in one shared TypeScript package (`src/dashboards/*`, `src/shared/*`). Only the thin platform entry point differs per target.
- **Desktop (primary platform)**: built with React Native for Windows and React Native for macOS. This is where most staff — Headmaster, Bursary, Registry, Stores, Assistant Headmasters, HODs — will do their day-to-day work, with larger screens suited to data entry, reports, and multi-pane dashboards (e.g. a sidebar of pages next to the active page's content).
- **Mobile (secondary platform)**: standard React Native for iOS and Android, aimed at roles that need to move around campus while working — Security (gate log), Boarding Houses (roll call), Health/Sick Bay, Transport (drivers), and students/SRC (elections, announcements). Mobile screens reuse the same dashboard modules but with a simplified, single-column, tab-based layout.
- **Responsive dashboard components**: every dashboard's pages are built with layout breakpoints so the same screen component re-flows between a desktop sidebar layout and a mobile tab/stack layout, rather than maintaining two separate UIs per dashboard.
- **Rollout order**: desktop builds ship first (matching how the school office actually operates today), with mobile builds following once the shared dashboard modules are stable — new dashboards/features are still designed once and shipped to both.

### 2.3 Multitenancy model

- Every school that signs up becomes a **tenant**, identified internally by a `tenant_id` / school code.
- All records (students, staff, finance entries, etc.) carry a `tenant_id` and are scoped at both the API layer and the database layer — no tenant can ever query another tenant's data.
- A super-admin layer (for GES/regional oversight or the SIMS provider) can exist above individual tenants, but is out of scope for the school-level dashboards described below.
- On first login, the app downloads and caches only that tenant's configuration, roles, and data — nothing from other schools ever touches the device.

### 2.4 Offline-first & sync engine

- **Local-first writes**: every create/update/delete happens instantly against the local database — the user is never blocked waiting on a network call.
- **Sync queue**: every local change is appended to a pending-changes queue with a timestamp and device ID.
- **Background sync**: when connectivity is detected, the app pushes queued changes to the server and pulls down changes made by other devices/tenants users since the last sync.
- **Conflict resolution**: field-level, timestamp-based ("last write wins") for most records; records that require human judgement on conflict (e.g. two staff editing the same student's record at once) are flagged and routed to the relevant dashboard for manual resolution.
- **Sync status indicator**: every dashboard shows a small persistent indicator — last synced time, and a count of changes still waiting to sync.
- **Critical offline scenarios** specifically supported: gate/security logging, sick bay visits, boarding house roll call, exam result entry, election voting — all must work fully with zero connectivity and sync later.

### 2.5 Roles & dashboard access model

- Each dashboard below corresponds 1:1 to a component in the school's supervision chart.
- A user account can hold **one or more roles**; the app renders a switchable set of dashboards based on the roles assigned.
- The **Headmaster/Headmistress dashboard** is the only dashboard with a read-aggregated view across all other dashboards, plus an approvals inbox that pulls requests from every department.
- Permissions are enforced both in the UI (a role only sees its own navigation stack) and at the API layer (a token for one role cannot fetch another dashboard's data even if requested directly).

---

## 3. Dashboards by component

### 3.1 Governing Board Dashboard
**Purpose:** high-level oversight, policy approval, budget sign-off. Mostly read access with a small set of approval actions.
**Pages:**
- **Overview** — key school metrics at a glance: enrollment, attendance rate, exam performance trend, finance snapshot.
- **Policy documents** — view and approve/reject draft policies submitted by the Headmaster.
- **Budget approvals** — review submitted termly/annual budgets, approve or send back with comments.
- **Meeting minutes** — log and browse past board meeting records and resolutions.
- **Reports** — termly/annual reports compiled for board review.

### 3.2 PTA Dashboard
**Purpose:** parent-teacher coordination, fundraising, and communication.
**Pages:**
- **My ward(s)** — a parent's own children linked to their account (created automatically on admission approval — see Section 7); view each ward's results/report cards, attendance, and fee/capitation status, read-only.
- **Announcements** — school-to-parent broadcast messages (works offline; sends when synced).
- **Fundraising projects** — track ongoing projects, contribution targets, and amounts raised.
- **Meeting schedule** — upcoming PTA meeting dates with RSVP.
- **Parent directory** — contact list (permission-scoped, no student academic data visible here).
- **Feedback/suggestions** — a log of parent input routed to the Headmaster.

### 3.3 Headmaster/Headmistress Dashboard
**Purpose:** the school's central command center — an aggregated view across every other dashboard, plus final approval authority.
**Pages:**
- **Executive overview** — enrollment, attendance %, exam performance, finance summary, and pending approvals pulled from all departments.
- **Staff directory & appraisal** — full staff list with performance review records.
- **Approvals inbox** — a single queue of pending requests from all three Assistant Headmasters (leave, procurement, budget, disciplinary escalations).
- **Reports & analytics** — generate termly/annual reports across academic, financial, and welfare data.
- **Communication** — broadcast messages to staff, students, or parents.
- **Discipline case log** — serious disciplinary matters escalated from Counselling or Boarding Houses.
- **Sync & data health** — a school-wide view of which devices/dashboards are behind on syncing.

### 3.4 Staff Dashboard
**Purpose:** a shared space for the general teaching/non-teaching staff body — communication and collective matters, separate from line management.
**Pages:**
- **Staff notice board** — circulars and memos from the administration.
- **Meeting minutes** — records of general staff meetings.
- **Resource library** — shared forms, templates, and teaching resources.
- **Leave requests** — submit and track leave applications (routes to the relevant Assistant Headmaster for approval).
- **Staff directory** — internal contact list.

### 3.5 Welfare Committee Dashboard
**Purpose:** manage staff welfare contributions and support during hardship or bereavement.
**Pages:**
- **Welfare fund ledger** — contributions in, disbursements out, running balance.
- **Support requests** — staff submit applications for welfare assistance.
- **Disbursement approvals** — committee reviews and approves/declines payout requests.
- **Membership register** — list of contributing staff and contribution status.

### 3.6 SRC Dashboard
**Purpose:** student government coordination.
**Pages:**
- **Student announcements** — SRC-to-student-body communication.
- **Event planner** — organize and track student events and activities.
- **Grievance log** — student complaints/suggestions submitted for SRC attention.
- **Prefect roster** — list of prefects and their portfolios.
- **Budget tracker** — SRC-managed funds (dues collected, event spending).

### 3.7 Electoral Commission Dashboard
**Purpose:** run SRC and prefectorial elections fairly and transparently.
**Pages:**
- **Election calendar** — nomination period, campaign window, and voting date.
- **Candidate registration** — nominee applications and eligibility vetting.
- **Voter roll** — eligible student voters by class/level.
- **Voting & live results** — digital ballot casting, fully offline-capable (votes cast on-device sync and tally once network is available; tallying logic runs locally per polling device to avoid any single point of failure).
- **Election reports** — final results, turnout, and audit trail.

### 3.8 Assistant Headmaster (Academic) Dashboard
**Purpose:** oversee all academic operations across subject departments and related units.
**Pages:**
- **Academic overview** — subject-by-subject performance summary, syllabus coverage percentage.
- **Timetable manager** — build and publish class/teacher schedules.
- **Exam management** — schedule exams, manage question papers, and oversee results entry.
- **HOD approvals** — review and act on reports/requests submitted by subject HODs.
- **Report cards** — generate, review, and approve report cards before release to parents.

#### 3.8.1 Subject HODs Dashboard
**Purpose:** manage a single subject department.
**Pages:**
- **Department overview** — teacher list and class coverage for the subject.
- **Syllabus tracker** — topic-by-topic coverage log per class.
- **Lesson plan review** — approve or comment on teachers' lesson plans.
- **Internal exam setting** — coordinate question paper creation and moderation.
- **Result entry** — input and verify subject scores per class.

#### 3.8.2 Counselling Unit Dashboard
**Purpose:** student welfare, guidance, and discipline referrals.
**Pages:**
- **Case log** — confidential student case records (access restricted to counselling staff).
- **Appointment scheduler** — book and track student counselling sessions.
- **Career guidance resources** — repository of university/course/scholarship information.
- **Referral tracker** — cases referred onward to external professionals.
- **Reports** — anonymized trend reports shared with the Headmaster.

#### 3.8.3 Library & ICT Dashboard
**Purpose:** manage the library's resources and the ICT lab.
**Pages:**
- **Catalogue** — book/resource inventory and availability.
- **Borrow/return log** — circulation tracking, works fully offline via barcode/manual entry.
- **ICT lab bookings** — class and computer lab scheduling.
- **Equipment inventory** — computers/devices and their maintenance status.
- **Digital resources** — e-books and past-questions repository.

#### 3.8.4 Sports & Clubs Dashboard
**Purpose:** manage co-curricular activities.
**Pages:**
- **Clubs & societies registry** — list of clubs, patrons, and membership.
- **Sports fixtures** — inter-house and inter-school match schedule.
- **Attendance/participation log** — track student involvement in activities.
- **Equipment & kits inventory**.
- **Achievements log** — trophies, awards, and records won.

#### 3.8.5 PLC (Professional Learning Community) Dashboard
**Purpose:** teacher collaboration and continuous improvement.
**Pages:**
- **Meeting schedule & minutes** — PLC session records.
- **Lesson study log** — shared observations and teaching strategies.
- **Performance data review** — student performance data discussed in sessions.
- **Resource sharing** — materials and best practices shared among teachers.
- **Action plan tracker** — follow-up commitments from each PLC session.

#### 3.8.6 Teaching Platform (Teacher Dashboard)
**Purpose:** the working dashboard a teacher uses to actually teach and assess their students — everything needed for teaching and learning in one place, plus direct access to their own students' scores.
**Provisioning:** a teacher does not get access by default. When a **Subject HOD** assigns a teacher to a subject/class, that assignment automatically provisions the teacher's dashboard — scoped only to the subjects and classes they've been assigned. If a teacher is assigned to more subjects/classes later, their dashboard updates accordingly; if unassigned, access is revoked.
**Pages:**
- **My subjects & classes** — the list of subjects/classes assigned to this teacher by their HOD.
- **Lesson materials** — upload and organize notes, slides, and past questions per topic.
- **Audio & video library** — record or upload audio and video lessons for a class/topic; supports offline playback on students' devices, syncing when online.
- **Live/virtual class session** — start or join a scheduled online class for remote or supplementary teaching.
- **Assignments & assessments** — create assignments/quizzes, set due dates, and collect submissions from assigned classes.
- **Gradebook** — enter and review scores for assessments and exams; feeds directly into the Academic dashboard's report card generation.
- **Class attendance** — mark attendance per lesson/class.
- **Student roster** — roll of students in each assigned class, with individual performance history for that subject.
- **Class announcements** — message all students in a specific assigned class.

### 3.9 Assistant Headmaster (Administration) Dashboard
**Purpose:** oversee finance, stores, registry, and security operations. This is also the office responsible for **student admissions** — new intake is processed here (via the Registry dashboard below) before students are handed off to Academic and Domestic/Boarding for placement.
**Pages:**
- **Admin overview** — combined snapshot of finance, stores, registry, and security status.
- **Approvals** — procurement and staff requests awaiting sign-off.
- **Compliance tracker** — GES/regulatory documentation deadlines.
- **Reports** — administrative reports compiled for the Headmaster.

#### 3.9.1 Bursary/Finance Dashboard
**Purpose:** manage all school finances.
**Pages:**
- **Fee/capitation ledger** — student fee status and Free SHS capitation tracking.
- **Payroll** — staff salary processing.
- **Expenditure log** — purchases and payments recorded as they happen (offline-capable).
- **Budget planner** — prepare termly/annual budgets for board approval.
- **Financial reports** — income/expenditure statements.

#### 3.9.2 Stores Dashboard
**Purpose:** manage inventory and supplies for the whole school.
**Pages:**
- **Stock inventory** — items, quantities, and reorder levels.
- **Goods received log** — incoming supplies with supplier details.
- **Requisition/issue log** — items issued out to departments (kitchen, cleaning, etc.).
- **Stock audit** — periodic count reconciliation.
- **Low-stock alerts** — automatic flags when items fall below reorder threshold.

#### 3.9.3 Registry Dashboard
**Purpose:** manage student and staff records and admissions.
**Pages:**
- **Student records** — bio-data and academic history.
- **Admissions** — new student intake processing, owned and actioned by the Assistant Headmaster (Administration); includes CSSPS placement data, document verification, and class/house assignment on entry.
- **Certificates & documents** — issue transcripts and testimonials.
- **Correspondence log** — incoming/outgoing official letters.
- **Staff records** — personnel files.

#### 3.9.4 Security Dashboard
**Purpose:** manage campus safety and access control.
**Pages:**
- **Gate log** — visitor and vehicle entry/exit records, fully offline-capable.
- **Incident reports** — security incident log.
- **Patrol schedule** — guard duty roster.
- **Visitor pre-registration** — pre-approved visitor list for expected guests.
- **Daily checklist** — perimeter and asset security checks.

### 3.10 Assistant Headmaster (Domestic/Boarding) Dashboard
**Purpose:** oversee boarding and all support services.
**Pages:**
- **Domestic overview** — boarding occupancy, health, and transport summary.
- **Approvals** — requisitions from catering, health, and transport units.
- **Compliance** — hygiene and safety inspection tracker.
- **Reports** — domestic operations report compiled for the Headmaster.

#### 3.10.1 Boarding Houses — supervision structure
Boarding is **not one merged entity**. Each individual house (e.g. "Aggrey House", "Mensah House") is its own separately-scoped dashboard, managed by the housemaster (boys' houses) or housemistress (girls' houses) in charge of that specific house — similar in spirit to how tenants are isolated from each other, but scoped to "house" rather than "school." Above the individual houses sits a **Senior Housemaster** (oversees all boys' houses) and a **Senior Housemistress** (oversees all girls' houses), each reporting to the Assistant Headmaster (Domestic/Boarding).

##### 3.10.1.1 Senior Housemaster / Senior Housemistress Dashboard
**Purpose:** oversee every house of one gender — one dashboard type, used by both roles, scoped automatically to "boys' houses" or "girls' houses" depending on who's logged in.
**Pages:**
- **Houses overview** — occupancy, headcount, and status across every house under their gender.
- **House supervisor roster** — which housemaster/housemistress is in charge of each individual house.
- **Cross-house discipline log** — incidents escalated up from individual houses.
- **Cross-house welfare summary** — welfare notes flagged for attention across all houses in their charge.
- **Reports** — a compiled boarding report handed up to the Assistant Headmaster (Domestic/Boarding).

##### 3.10.1.2 Individual House Dashboard
**Purpose:** the day-to-day dashboard for the housemaster/housemistress of one specific house. It only ever shows that house's own students and records — never another house's data, even though both may report to the same Senior Housemaster/Housemistress.
**Pages:**
- **House roster** — the students assigned to this specific house (assignment happens automatically at admission — see Section 7.3/7.4).
- **Room/bed allocation** — allocate this house's students to specific rooms/beds.
- **House roll call** — daily attendance/headcount for this house only, offline-capable.
- **Discipline log** — incidents specific to this house.
- **Welfare check log** — wellbeing notes on this house's students.

#### 3.10.2 Catering/Kitchen Dashboard
**Purpose:** manage boarding meals.
**Pages:**
- **Menu planner** — weekly meal schedule.
- **Food stock requisition** — linked to Stores for ingredient requests.
- **Meal headcount** — daily numbers fed, used for planning and reporting.
- **Kitchen staff roster**.
- **Hygiene inspection log**.

#### 3.10.3 Health/Sick Bay Dashboard
**Purpose:** manage student and staff health services.
**Pages:**
- **Patient log** — visits, symptoms, and treatment given, offline-capable and synced later.
- **Medical inventory** — medicine and supplies stock.
- **Referral tracker** — cases sent to hospital.
- **Health records** — chronic conditions/allergies flagged per student.
- **Health reports** — outbreak or trend monitoring for the Headmaster.

#### 3.10.4 Transport (Drivers) Dashboard
**Purpose:** manage school vehicles and transport logistics.
**Pages:**
- **Vehicle registry** — fleet list, documents, and insurance status.
- **Trip log** — routes, mileage, and purpose, entered offline.
- **Maintenance schedule** — service due dates and repair log.
- **Fuel log** — consumption tracking.
- **Driver roster & duty schedule**.

#### 3.10.5 Cleaning/Labourers Dashboard
**Purpose:** manage cleaning and grounds maintenance.
**Pages:**
- **Duty roster** — cleaning schedule by area.
- **Task checklist** — daily/weekly completion tracking.
- **Supply requests** — cleaning materials, linked to Stores.
- **Maintenance issue log** — report facility damage or repairs needed.
- **Inspection reports**.

### 3.11 Student Dashboard (Student Portal)
**Purpose:** the individual student's own window into their academic life, boarding status, and school communication — including the student-facing side of the Teaching Platform (Section 3.8.6). Everything a student needs, in one portal.
**Pages:**
- **Profile** — bio-data, class, house/dormitory, passport photo, guardian contact info.
- **Timetable** — personal class schedule pulled from the Academic dashboard.
- **My classes** — the subjects/classes the student is enrolled in, mirroring what their teachers see on the Teaching Platform; entry point to join a live/virtual class session.
- **Learning materials** — notes, slides, and the **audio & video library** shared by teachers for each subject, downloadable for offline viewing.
- **Assignments** — view assignments set by teachers and submit work (text, photo, or file), fully offline-capable and synced once online.
- **Results & report cards** — termly scores and report cards once released by the Academic office, plus continuous assessment scores as teachers enter them.
- **Attendance record** — personal attendance and house roll-call history.
- **Fees/capitation status** — a read-only view of fee/capitation balance synced from Bursary.
- **Library account** — currently borrowed books, due dates, fines if any.
- **Health record snapshot** — allergies/conditions on file, and a log of their own sick bay visits.
- **Elections** — view candidates and cast a vote when an election is open (offline-capable, syncs to the Electoral Commission's tally once online).
- **Grievance/feedback** — submit a complaint or suggestion directly to the SRC or Counselling Unit.

---

## 4. Cross-cutting / shared modules

These aren't separate dashboards, but shared services every dashboard plugs into:

- **Notifications engine** — in-app and push notifications, queued locally and delivered once synced.
- **Audit log** — every create/update/delete is timestamped and attributed to a user, per tenant, for accountability.
- **Role & permission management** — a super-admin-per-school screen (usually accessible to the Headmaster) to assign/revoke roles.
- **Multi-language support** — English plus major Ghanaian languages for parent-facing screens (announcements, SRC notices).
- **Backup & data export** — scheduled local backups and CSV/PDF export of key reports for offline record-keeping.
- **Sync engine** (described in 2.3) — shared by every dashboard; no dashboard implements its own sync logic.

---

## 5. Engineering conventions

- **Language:** TypeScript only — `strict: true`, no implicit `any`, no `.js`/`.jsx` files anywhere in the codebase.
- **Structure:** one feature module per dashboard (e.g. `src/dashboards/bursary/`, `src/dashboards/boardingHouses/`), each with its own typed navigation stack, screens, local data models, and sync handlers.
- **Shared code:** a `src/shared/` module for the sync engine, auth, UI components, and cross-cutting services listed in Section 4.
- **Data models:** each dashboard's local tables are defined once and shared between the offline database schema and the sync payload types, so the local and server shapes never drift apart.

---

## 6. Login screen & public admission flow

### 6.1 Login screen layout

One single login screen serves every role in the school — Headmaster, HODs, teachers, students, parents, security, everyone. The screen is built as four stacked sections:

1. **Header (banner)** — school name/logo and tagline, branded per-tenant (each school's logo/colors pulled from tenant config).
2. **Login box** — username/staff ID or student/parent ID, password, a "Login" button, and a "forgot password" link. This is the only section that requires an existing account.
3. **Apply for admission** — a public-facing panel, usable without logging in, that lets a parent/guardian start a new admission application (see 6.3 below).
4. **Footer** — small: copyright, contact info, app version.

### 6.2 Auth router

- After a successful login, an **auth router** reads the authenticated user's tenant and assigned role(s) from their token and sends them straight to the correct dashboard's landing page — the login screen itself never changes per role, only what happens after login does.
- If an account holds more than one role (e.g. a teacher who is also a Subject HOD), the router lands on a default/primary dashboard, with an in-app switcher to move between the dashboards that account has access to.
- The router enforces the same tenant + role scoping described in Section 2.5 — it is not just a UI convenience, the destination dashboard's data access is independently checked at the API layer too.

### 6.3 Admission application flow (pre-login, public)

1. **Pre-loading**: admissions staff — the Assistant Headmaster (Administration), via the Registry dashboard — load prospective students' data ahead of time (e.g. from a CSSPS placement list), creating placement records the system can match against.
2. **Parent search**: on the login screen's "Apply for admission" panel, a parent enters their ward's name (and optionally an index/placement number) — no account needed yet.
3. **Match check**: if the entered name matches a pre-loaded placement record, the parent is allowed to continue and fill in the rest of the application (parent/guardian details, contact info, supporting documents). If there's no match, the parent is told to contact the school directly rather than being allowed to submit a free-form application.
4. **Review**: the completed application lands in the Registry/Admissions queue for the Assistant Headmaster (Administration) to review and approve or reject.
5. **On approval**, the system automatically:
   - converts the application into a full `StudentRecord` (Section 7.3), including automatic house assignment where boarding applies (Section 7.4);
   - creates a **parent account**, linked to that student as a ward, and enrolls it directly into the **PTA Dashboard** — no separate manual account-creation step;
   - sends the parent their login credentials/invite for their new account.

### 6.4 Parent accounts & ward linkage

- A parent account can be linked to **more than one ward** if they have multiple children in the school — all wards appear under the one account, selectable within the PTA Dashboard's **My ward(s)** page.
- A parent only ever sees data for their own linked ward(s) — results/report cards, attendance, and fee/capitation status — never another student's records.
- If a second parent/guardian for the same ward later applies or is added, they get their own account linked to the same student, rather than sharing credentials.

---

## 7. Data model drafts

### 7.1 Teaching Platform

A first-pass TypeScript shape for the core entities behind the Teaching Platform (3.8.6) and its student-facing mirror in the Student Portal (3.11). Every table follows the same **sync envelope** so the offline-first engine can treat all of them uniformly.

```ts
// Shared by every synced record — do not duplicate per-entity.
interface SyncEnvelope {
  id: string;            // UUID, generated on-device
  tenantId: string;       // school/tenant scoping — enforced at API + DB layer
  createdAt: string;      // ISO timestamp, set on-device
  updatedAt: string;      // ISO timestamp, bumped on every local edit
  syncedAt: string | null; // null until first successful push to server
  deletedAt: string | null; // soft-delete, so deletions sync correctly
}

// A subject offered by the school (owned/created by Academic office).
interface Subject extends SyncEnvelope {
  name: string;                // e.g. "Elective Mathematics"
  code: string;                // e.g. "ELEC-MATH"
  departmentId: string;        // FK -> Subject HOD's department
}

// A class group (e.g. "SHS 2 Science A").
interface ClassSection extends SyncEnvelope {
  name: string;
  level: "SHS1" | "SHS2" | "SHS3";
  programme: "Science" | "Arts" | "Business" | "Technical" | "Agriculture" | "Visual Arts" | "Home Economics";
}

// Created by an HOD — this is what provisions a teacher's dashboard.
interface TeacherAssignment extends SyncEnvelope {
  teacherId: string;      // FK -> staff/user
  subjectId: string;      // FK -> Subject
  classSectionId: string; // FK -> ClassSection
  assignedByHodId: string; // FK -> the HOD who made the assignment
  active: boolean;        // false = access revoked, dashboard entry hidden
}

// A student's enrollment in a subject/class (drives what shows in their Student Portal).
interface Enrollment extends SyncEnvelope {
  studentId: string;
  subjectId: string;
  classSectionId: string;
}

// Lesson content a teacher publishes — including the audio/video library.
interface LessonMaterial extends SyncEnvelope {
  subjectId: string;
  classSectionId: string;
  teacherId: string;
  type: "note" | "slide" | "audio" | "video" | "pastQuestion";
  title: string;
  topic: string;
  localFilePath: string | null;   // present once downloaded/recorded on-device
  remoteFileUrl: string | null;   // present once uploaded/synced
  durationSeconds: number | null; // for audio/video only
}

// A live/virtual class session a teacher schedules or starts.
interface LiveClassSession extends SyncEnvelope {
  subjectId: string;
  classSectionId: string;
  teacherId: string;
  scheduledAt: string;
  status: "scheduled" | "live" | "ended" | "cancelled";
  recordingMaterialId: string | null; // FK -> LessonMaterial, once recorded
}

// An assignment/quiz set by a teacher.
interface Assignment extends SyncEnvelope {
  subjectId: string;
  classSectionId: string;
  teacherId: string;
  title: string;
  instructions: string;
  dueAt: string;
  attachmentMaterialIds: string[]; // FK[] -> LessonMaterial
}

// A student's submission for an assignment.
interface Submission extends SyncEnvelope {
  assignmentId: string;
  studentId: string;
  textResponse: string | null;
  attachmentLocalPaths: string[];
  attachmentRemoteUrls: string[];
  status: "draft" | "submitted" | "graded";
  score: number | null;
  maxScore: number | null;
  feedback: string | null;
  gradedByTeacherId: string | null;
  gradedAt: string | null;
}

// Standalone scores not tied to a specific assignment (classwork, tests, exams).
interface Assessment extends SyncEnvelope {
  subjectId: string;
  classSectionId: string;
  studentId: string;
  teacherId: string;
  term: "Term 1" | "Term 2" | "Term 3";
  type: "classwork" | "homework" | "test" | "exam";
  score: number;
  maxScore: number;
}

// Per-lesson attendance, taken by the teacher on the Teaching Platform.
interface ClassAttendance extends SyncEnvelope {
  subjectId: string;
  classSectionId: string;
  studentId: string;
  date: string;          // YYYY-MM-DD
  status: "present" | "absent" | "late";
  recordedByTeacherId: string;
}
```

**How this maps back to the dashboards:**
- `TeacherAssignment` is the record an HOD creates from the **HOD approvals**/department pages (3.8.1) — its existence is what provisions a teacher's Teaching Platform dashboard (3.8.6) and scopes it to only their subjects/classes.
- `Enrollment` similarly drives what a student sees under **My classes** in the Student Portal (3.11).
- `LessonMaterial`, `Assignment`, and `LiveClassSession` are created on the Teaching Platform and appear read-only (or submit-only, for assignments) on the Student Portal.
- `Assessment` and `Submission.score` both feed the **Gradebook** page (teacher side) and **Results & report cards** page (student side), and roll up into the Academic dashboard's report card generation (3.8).
- All file-bearing records (`LessonMaterial`, `Submission` attachments) store a `localFilePath` first; `remoteFileUrl`/`remoteUrls` populate only after a successful background upload, consistent with the offline-first rule that nothing blocks on network access.

### 7.2 Bursary/Finance

```ts
// A student's running fee/capitation position for a term.
interface StudentFeeLedger extends SyncEnvelope {
  studentId: string;
  term: "Term 1" | "Term 2" | "Term 3";
  academicYear: string;       // e.g. "2026/2027"
  totalDue: number;           // fees, or capitation shortfall if applicable
  amountPaid: number;
  balance: number;            // derived, but stored for fast offline reads
}

// A single payment towards a student's fees.
interface FeePayment extends SyncEnvelope {
  studentId: string;
  ledgerId: string;           // FK -> StudentFeeLedger
  amount: number;
  method: "cash" | "mobile_money" | "bank" | "capitation_grant";
  reference: string | null;   // receipt/transaction number
  recordedByStaffId: string;
  paidAt: string;
}

// Monthly payroll run for a staff member.
interface PayrollRecord extends SyncEnvelope {
  staffId: string;
  month: string;              // e.g. "2026-07"
  grossPay: number;
  deductions: number;
  netPay: number;
  status: "pending" | "processed" | "paid";
}

// Any non-payroll expenditure (procurement, utilities, repairs, etc.).
interface ExpenditureEntry extends SyncEnvelope {
  category: string;           // e.g. "Stores procurement", "Utilities"
  description: string;
  amount: number;
  linkedRequisitionId: string | null; // FK -> Stores requisition, if applicable
  approvedByStaffId: string;
  spentAt: string;
}

// A termly/annual budget line, submitted for Governing Board approval.
interface BudgetLine extends SyncEnvelope {
  term: "Term 1" | "Term 2" | "Term 3" | "Annual";
  academicYear: string;
  department: string;         // e.g. "Academic", "Domestic/Boarding"
  allocatedAmount: number;
  spentAmount: number;
  approvalStatus: "draft" | "submitted" | "approved" | "rejected";
}
```

**How this maps back to the dashboard:** `StudentFeeLedger` and `FeePayment` power the **Fee/capitation ledger** page and the read-only fee status shown on the Student Portal; `PayrollRecord` and `ExpenditureEntry` power **Payroll** and **Expenditure log**; `BudgetLine` powers **Budget planner** on this dashboard and **Budget approvals** on the Governing Board dashboard (3.1) — the same record simply changes `approvalStatus` as it moves between the two.

### 7.3 Registry

```ts
// The authoritative student record — created at admission, updated throughout.
interface StudentRecord extends SyncEnvelope {
  admissionNumber: string;
  firstName: string;
  lastName: string;
  dateOfBirth: string;
  gender: "male" | "female";
  classSectionId: string;
  houseId: string | null;      // auto-assigned at admission approval (least-populated house of matching gender); null only for day students
  guardianName: string;
  guardianPhone: string;
  guardianAddress: string;
  admissionDate: string;
  status: "active" | "graduated" | "withdrawn" | "transferred";
}

// An in-progress admission, owned by the Assistant Headmaster (Administration).
// A prospective student pre-loaded by admissions staff (e.g. from a CSSPS placement
// list) before any parent applies — this is what a parent's search is matched against
// on the public "Apply for admission" panel (Section 6.3).
interface PlacementRecord extends SyncEnvelope {
  fullName: string;
  csspsPlacementRef: string | null;
  intendedClassSectionId: string | null;
  preloadedByStaffId: string;      // the Assistant Headmaster (Administration) or Registry staff who loaded it
  matched: boolean;                // true once a parent has successfully found and applied against it
}

// The parent-submitted application — created only after a PlacementRecord match.
interface AdmissionApplication extends SyncEnvelope {
  placementRecordId: string;       // FK -> PlacementRecord it was matched against
  applicantName: string;
  parentName: string;
  parentPhone: string;
  parentEmail: string | null;
  documentsVerified: boolean;
  processedByStaffId: string | null;
  status: "received" | "under_review" | "approved" | "rejected";
  resultingStudentRecordId: string | null;  // FK -> StudentRecord, once approved
  resultingParentAccountId: string | null;  // FK -> ParentAccount, auto-created once approved
}

// A parent/guardian's login account — auto-created the moment their AdmissionApplication is approved.
interface ParentAccount extends SyncEnvelope {
  fullName: string;
  phone: string;
  email: string | null;
  wardStudentIds: string[];  // FK[] -> StudentRecord; grows if the parent has more than one child
}

// Transcripts, testimonials, and other issued documents.
interface Certificate extends SyncEnvelope {
  studentId: string;
  type: "transcript" | "testimonial" | "other";
  issuedByStaffId: string;
  issuedAt: string;
  fileLocalPath: string | null;
  fileRemoteUrl: string | null;
}

// Incoming/outgoing official correspondence.
interface CorrespondenceLog extends SyncEnvelope {
  direction: "incoming" | "outgoing";
  subject: string;
  counterparty: string;        // who it's from/to
  loggedByStaffId: string;
  loggedAt: string;
}

// Staff personnel file.
interface StaffRecord extends SyncEnvelope {
  firstName: string;
  lastName: string;
  position: string;
  role: string;                 // maps to a dashboard role, e.g. "hod_academic"
  dateOfEmployment: string;
  qualifications: string[];
  status: "active" | "on_leave" | "retired" | "resigned";
}
```

**How this maps back to the dashboard:** a parent's search on the login screen's **Apply for admission** panel (Section 6.3) checks for a matching `PlacementRecord`; only then can they submit an `AdmissionApplication`. Its `status` moving to `"approved"` is what creates both a `StudentRecord` and, automatically, a `ParentAccount` linked to it via `wardStudentIds` — the exact handoff point described in Section 3.9's note that admissions are owned by the Assistant Headmaster (Administration) before the student is placed into Academic (`classSectionId`) and Domestic/Boarding (`houseId`).

### 7.4 Boarding Houses

```ts
// A dormitory/house — the unit of isolation for boarding data.
// Housemaster/Housemistress dashboards (3.10.1.2) are scoped to a single houseId;
// Senior Housemaster/Housemistress dashboards (3.10.1.1) are scoped to every House
// with a matching `gender`.
interface House extends SyncEnvelope {
  name: string;                    // e.g. "Aggrey House"
  gender: "boys" | "girls";
  capacity: number;
  housemasterStaffId: string;      // in charge of this house only
  seniorSupervisorStaffId: string; // FK -> Senior Housemaster/Housemistress for this gender
}

// A student's room/bed assignment within a house for a term.
interface RoomAllocation extends SyncEnvelope {
  studentId: string;
  houseId: string;
  roomNumber: string;
  bedNumber: string;
  term: "Term 1" | "Term 2" | "Term 3";
  academicYear: string;
}

// Daily roll call, taken offline and synced later.
interface RollCallEntry extends SyncEnvelope {
  houseId: string;
  studentId: string;
  date: string;                // YYYY-MM-DD
  status: "present" | "absent" | "excused";
  recordedByStaffId: string;
}

// House-level discipline incidents.
interface HouseDisciplineLog extends SyncEnvelope {
  studentId: string;
  houseId: string;
  description: string;
  actionTaken: string | null;
  recordedByStaffId: string;
  occurredAt: string;
}

// Informal wellbeing notes from housemasters/housemistresses.
interface WelfareCheckLog extends SyncEnvelope {
  studentId: string;
  houseId: string;
  note: string;
  recordedByStaffId: string;
  checkedAt: string;
}
```

**How this maps back to the dashboard:** every query on the **Individual House Dashboard** (3.10.1.2) filters `RoomAllocation`, `RollCallEntry`, `HouseDisciplineLog`, and `WelfareCheckLog` by a single `houseId` — a housemaster/housemistress never sees another house's records. The **Senior Housemaster/Housemistress Dashboard** (3.10.1.1) instead filters by `House.gender`, aggregating across every house that matches. `House.seniorSupervisorStaffId` and `House.housemasterStaffId` are what drive this access scoping — assigned once and enforced on every query, not just in the UI.

**Automatic house assignment at admission:** a student's `houseId` (on `StudentRecord`, Section 7.3) is set automatically the moment an `AdmissionApplication` is approved — the system picks the least-populated `House` matching the student's gender, rather than requiring a manual assignment step. Housemasters/housemistresses then only handle room/bed allocation *within* the house they've already been assigned to.

**How this maps back to the dashboard:** `House` and `RoomAllocation` power the **Room/bed allocation** page; `RollCallEntry` powers **House roll call** (and also feeds the student's overall **Attendance record** on the Student Portal); `HouseDisciplineLog` escalates to the Headmaster's **Discipline case log** (3.3) when marked serious; `WelfareCheckLog` is what a housemaster/housemistress uses for the **Welfare check log** page.
