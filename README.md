# pm-kit — 휴대용 PM 기획 엔진

어느 PC·어느 회사에서든 **한 번에** 내 기획 방식을 세팅하는 개인 kit.
핵심 설계: **엔진(회사무관) / 도메인(회사별) 분리** — 회사가 바뀌면 `domain-context.md`만 갈아끼운다.

## 구성

```
pm-kit/
├── CLAUDE.md                        엔진: 역할·워크플로우·UX 규칙·문서 규칙 (회사무관)
├── agents/
│   ├── planning-reviewer.md         기획서 적대적 검토 에이전트 — 개발 넘기기 전 (엔진)
│   └── qa-engineer.md               브라우저 탐색적 QA 에이전트 — 개발 완료 후 (엔진)
├── context/
│   ├── planning-kickoff.md          작성 전 역질문 + 권한 CRUD 매트릭스 (엔진)
│   ├── ux-checklist.md              화면 상태 그물: 로딩·빈상태·중복·폼·접근성 (엔진)
│   ├── prediction-eval.md           예측 일지 + Eval 세트: 넘기기 직전 채점 장치 (엔진)
│   └── domain-context.TEMPLATE.md   회사별 값 빈 골격 (실제 값은 여기 X)
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
