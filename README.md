# pm-kit — 휴대용 PM 기획 엔진

어느 PC·어느 회사에서든 **한 번에** 내 기획 방식을 세팅하는 개인 kit.
핵심 설계: **엔진(회사무관) / 도메인(회사별) 분리** — 회사가 바뀌면 `domain-context.md`만 갈아끼운다.

## 파이프라인 (2026-10 개편)

뼈대는 [mattpocock/skills](https://github.com/mattpocock/skills), 기획자 그물은 `context/planning-nets.md`.

```
/grill-with-docs → 회사 표준 문서(+ /prototype 동시 · 실제 코드+DS · impeccable로 다듬기) → planning-reviewer
  → /to-spec → /to-tickets → /implement → qa-engineer(브라우저) → /retro
```

- **한 명령으로**: `/pm-flow <기능 이름>` — 8단계를 순서대로, 단계마다 승인, 끊기면 이어하기.
- 정본은 회사 표준 문서. `/to-spec`은 그걸 요약한 개발 전달용 이슈(Notion).
- code-review는 화면 QA가 아니다. 브라우저 QA(`qa-engineer`)는 그대로 돈다.
- 용어: 제품 고유 = 제품 레포 용어집(회사 표준 용어 문서 우선, 없으면 `GLOSSARY.md`) / 회사 공통 = `domain-context.md`.

## 구성

```
pm-kit/
├── CLAUDE.md                        엔진: 역할·워크플로우·UX 규칙·문서 규칙 (회사무관)
├── agents/
│   ├── planning-reviewer.md         기획서 적대적 검토 에이전트 — 개발 넘기기 전 (엔진)
│   └── qa-engineer.md               브라우저 탐색적 QA 에이전트 — 개발 완료 후 (엔진)
├── context/
│   ├── planning-nets.md             파이프라인 단계별 기획 그물: 6분류·CRUD·반출·운영 축·UX 2~3안 (엔진)
│   ├── planning-kickoff.md          작성 전 역질문 + 권한 CRUD 매트릭스 (엔진)
│   ├── ux-checklist.md              화면 상태 그물: 로딩·빈상태·중복·폼·접근성 (엔진)
│   ├── prototype-craft.md           프로토타입 완성도 그물: 화면 «모드»·AI 슬롭 금지·사전점검 (엔진)
│   ├── prediction-eval.md           예측 일지 + Eval 세트: 넘기기 직전 채점 장치 (엔진)
│   └── domain-context.TEMPLATE.md   회사별 값 빈 골격 (실제 값은 여기 X)
├── commands/pm-flow.md              /pm-flow: 파이프라인 8단계 진행자 (.claude/commands/로 복사됨)
├── templates/issue-tracker-notion.md  to-spec·to-tickets용 Notion 트래커 설정 (docs/agents/로 복사됨)
├── setup.ps1 / setup.sh             새 프로젝트에 엔진 배치
└── skills/                          내 커스텀 스킬(선택) — 필요 시 여기 모음
```

## 새 PC / 새 회사에서 부팅 (3단계)

```bash
# 1. kit 받기
git clone <ljy9505/pm-kit private repo>

# 2. 일할 회사 프로젝트 폴더에서 엔진 배치
#    Windows:  powershell -ExecutionPolicy Bypass -File <kit>\setup.ps1
#    mac/Linux: bash <kit>/setup.sh
#    -> .claude/agents, .claude/context, CLAUDE.md 가 깔린다 (기존 실제 값은 안 덮음)

# 3. 회사 값 채우기
#    .claude/context/domain-context.md 를 이 회사 역할·상태·정책·디자인시스템으로 작성
```

그리고 ponytail 설치(전역 플러그인, 회사무관):
```
/plugin marketplace add DietrichGebert/ponytail
/plugin install ponytail@ponytail
/reload-plugins
```

## 보안 규칙 (중요)

- **`domain-context.md`(채운 실제 값)는 절대 커밋하지 않는다.** `.gitignore`가 막아둠. 공유되는 건 `.TEMPLATE.md`뿐.
- kit 자체는 **private 레포**(ljy9505). push는 사용자가 직접.

## 메모리 → kit 승격 원칙

Claude Code의 세션 메모리(`~/.claude/projects/...`)는 그 PC·그 폴더 경로에 묶여 **안 따라온다.**
"평생 쓸 회사무관 규칙"은 메모리에 두지 말고 이 **CLAUDE.md로 승격**시켜라(그래야 clone하면 어디서든 로드됨).
회사별 사실은 `domain-context.md`로.
