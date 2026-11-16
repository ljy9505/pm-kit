---
description: 기획 하나를 pm-kit 파이프라인 0~8단계로 순서대로 진행한다 (단계마다 PM 승인, 이어하기 가능)
argument-hint: <기능 이름 또는 한 줄 설명>
---

대상 기능: **$ARGUMENTS**

당신은 이 파이프라인의 **진행자**다. `CLAUDE.md`의 파이프라인 표와 `.claude/context/planning-nets.md`가 정본이고, 이 명령은 그걸 순서대로 실행하는 방법만 정한다.

> **레포에 엔진 파일이 없을 때** (pm-kit을 설치하지 않은 레포에서 전역 명령으로 실행한 경우):
> - 파이프라인 표·`planning-nets.md`·`planning-kickoff.md`·`ux-checklist.md`·`prototype-craft.md`·`prediction-eval.md`는 이 PC에 clone한 pm-kit 원본(`CLAUDE.md`, `context/`)에서 읽는다. 위치를 모르면 `find ~ -maxdepth 4 -type d -name pm-kit`로 찾거나 PM에게 묻는다.
> - `domain-context.md`(회사별 값)는 원본에서 대신 읽지 않는다. 없으면 PM에게 "이 레포에 `domain-context.md`가 없음 — `bash <pm-kit 경로>/setup.sh .`로 설치 권장"이라고 한 번 알리고, 회사값이 필요한 판단은 PM에게 물어 진행한다.

## 0. 시작 — 어디서부터인지 찾는다

1. 기능 이름으로 짧은 영문 slug를 정한다(예: 출석 체크 → `attendance-check`).
2. `.scratch/<slug>/pm-flow.md`가 있으면 읽고 **멈춘 단계부터 이어간다.** 끝난 단계는 다시 돌지 않는다. 옛 파일에 `0 발굴` 줄이 없으면 이미 지난 단계로 보고 넘어간다.
3. 없으면 아래 양식으로 만들고 1단계부터 시작한다.

```markdown
# pm-flow: <기능 이름>
시작일: YYYY-MM-DD

- [ ] 0 발굴 (자료 없으면 `건너뜀`)
- [ ] 1 정렬·용어집
- [ ] 2 정본 문서
- [ ] 3 프로토타입
- [ ] 4 기획 검토
- [ ] 5 스펙·티켓
- [ ] 6 구현
- [ ] 7 화면 QA
- [ ] 8 회고

## 단계 기록
(단계가 끝날 때마다 한 줄: 날짜 · 단계 · 결과물 경로/링크 · PM 승인 여부)
```

4. 사전 준비를 확인한다. 하나라도 없으면 진행하지 말고 PM에게 무엇을 해야 하는지 알린다.
   - mattpocock 스킬 설치됨(아래 "Matt 스킬 읽는 법"의 find 결과가 있음)
   - `docs/agents/issue-tracker.md`에 `<NOTION_DB_URL>`이 실제 링크로 바뀌어 있음
   - `.claude/context/domain-context.md`에 DS 패키지가 적혀 있음

## Matt 스킬 읽는 법

`/to-spec`·`/to-tickets`·`/implement`·`/retro`는 사람만 부를 수 있게 막혀 있어 Skill 도구로 부를 수 없다. 대신 SKILL.md를 찾아 읽고 **그 절차를 그대로 따른다.**

```bash
find "$HOME/.claude/plugins" "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/plugins" -path '*mattpocock-skills*' -path '*/<스킬이름>/SKILL.md' 2>/dev/null | sort -V | tail -1
```

`grilling`·`domain-modeling`·`prototype`·`tdd`·`code-review`는 Skill 도구로 바로 부른다. 이름은 반드시 접두어까지 — `mattpocock-skills:grilling`처럼. 접두어 없는 같은 이름(다른 플러그인·내장 `code-review` 등)은 Matt 것이 아니다.

## 단계

각 단계는 **실행 → 게이트 확인 → PM에게 3줄 보고(무엇이 됐나 / 게이트 통과했나 / 되돌아온 것) → PM이 "다음"이라고 할 때 진행**. PM 승인 없이 다음 단계로 넘어가지 않는다.

| # | 실행 | 그물 | 게이트 (못 넘으면 앞 단계로) |
|---|---|---|---|
| 0 | 원자료(인터뷰 녹취·VOC·문의·경쟁사 자료)를 **1건당 Agent `general-purpose` 1개**로 동시에 읽힌다 → 결과를 합쳐 `.scratch/<slug>/discovery.md`에 기회 표로 정리 (아래 "0 발굴 규칙") | `pm-product-discovery` 스킬(있으면) | 모든 주장에 원문 인용·출처 · 기회별 등장 건수 · PM이 다룰 기회 선택 |
| 1 | Skill `mattpocock-skills:grilling` + `mattpocock-skills:domain-modeling` (= `/grill-with-docs`) | nets §1, `planning-kickoff.md` | 역질문 답 받음 · 전제마다 확인됨/추정/모름 · 어드민 범위 확정 · 용어가 `GLOSSARY.md`에 들어감 |
| 2 | `/planning` 절차 STEP A·B·C로 회사 표준 정책서 → 기능 정의서 → 화면 설계서 (`.claude/commands/planning.md`를 읽고 따름 — 없으면 pm-kit 원본 `commands/planning.md`. A0·A+는 1단계에서 끝났으면 건너뜀). **정책서를 끝내면 기능 정의서로 넘어가기 전에** Agent `planning-reviewer`를 정책서 계층만 보게 한 번 돌린다(중간 검토) | nets §2, `ux-checklist.md` | 회사 표준 양식·경로 준수 · 예외 3단 작성 · 중간 검토 `[HIGH]` 0 |
| 3 | Skill `mattpocock-skills:prototype` (2단계와 번갈아) → `impeccable`로 다듬기 | nets §3, `prototype-craft.md` | 실제 코드·DS 사용 · 0/1건 상태 있음 · 세 화면 폭 스크린샷 · PM이 안 선택 |
| 4 | Agent `planning-reviewer` | nets §2 | 권한×CRUD 빈칸 0 · 반출 정의됨 · 운영 축 미정의 0 · `[HIGH]` 0 |
| 5 | to-spec → to-tickets (SKILL.md 읽고 따름) | nets §4, `prediction-eval.md` | 롤아웃·예측 일지 작성 · Notion에 올리기 전 목록 승인 · 스펙에 정본 경로·기능 ID |
| 6 | implement (SKILL.md 읽고 따름) | — | 테스트 통과 · code-review 지적 처리 |
| 7 | **7a** 정본↔코드 대조: Agent `general-purpose`(읽기 전용 — 파일 수정 금지라고 지시)에게 `intended-vs-implemented` 스킬을 따르게 한다 → **7b** Agent `qa-engineer` 병렬 실행 (실제 브라우저, 아래 "7b 병렬 규칙") | nets §5 | 7a 결함 0 또는 PM 판정 · `[HIGH]` 0 · 역방향 갭은 PM에게 되돌림(문서 누락) |
| 8 | retro (SKILL.md 읽고 따름) | — | 개선 후보를 심각도 순으로 제시 |

- 2와 3은 같이 돈다 — 기능 정의서를 쓰다 화면이 애매해지면 바로 3으로 갔다가 돌아온다. 체크는 둘 다 끝났을 때.
- 6은 개발자가 따로 맡을 수 있다. PM이 "6은 건너뛰어"라고 하면 기록에 `건너뜀(담당: …)`으로 남기고 7은 구현이 끝난 뒤 다시 부른다. 6을 건너뛰어도 7a는 건너뛰지 않는다.
- 2단계 중간 검토는 4단계를 대신하지 않는다 — 4는 세 문서·프로토타입 전체를 본다. 중간 검토에서 정책이 바뀌면 그 자리에서 정책서부터 고친다.
- 7a 결과는 표로 받고 「코드가 틀림(결함)」과 「문서가 낡음(갱신)」을 갈라 PM에게 올린다. 결함은 7b 전에 고칠지 PM이 정한다.

### 0 발굴 규칙

- **자료부터 묻는다.** PM에게 "이 기능 관련 원자료(폴더·파일·링크)가 있나요?"를 묻는다. 없으면 `건너뜀(자료 없음)`으로 기록하고 1단계로 간다. 자료를 지어내거나 웹 일반론으로 대신하지 않는다.
- **에이전트 수는 자료 크기에 맞춘다.** 1~2건이면 에이전트 없이 직접 읽는다. 3건 이상이면 1건당 1개, 10건이 넘으면 비슷한 자료를 묶어 최대 10개.
- 각 에이전트에게 주는 지시(전부 명시):
  - 범위: 맡은 자료만 읽는다. 파일 수정·외부 전송 금지.
  - 결과 형식: 표 하나 — `문제/불편 | 원문 인용 | 누가(역할) | 지금 어떻게 때우나 | 강도(상/중/하)`.
  - 자료에 없는 것은 쓰지 않는다. 해석은 `[짐작]`으로 표시.
- **합치기는 메인이 한다.** 같은 뜻의 문제를 묶고, 문제마다 등장 건수와 대표 인용 1~2개를 남겨 기회 표를 만든다. 등장 건수 순으로 정렬.
- **1단계로 넘기는 법.** PM이 고른 기회와 인용이 1단계 전제 점검의 근거가 된다. 인용이 있는 전제는 `확인됨`, 없는 전제는 `추정`이다.

### 7b 병렬 규칙

`qa-engineer` 여럿을 **한 메시지에서 동시에** 띄운다. 단, 모두 같은 Chrome을 쓰므로 로그인 세션과 창 크기를 서로 덮어쓴다. 그래서:

- **시나리오 묶음으로 나눈다** — 예: ① 예외/에러 표 ② 권한×CRUD ③ 상태 전이·수용 기준. 묶음당 에이전트 1개, 최대 3개.
- **역할은 라운드로 나눈다** — 한 라운드 = 한 역할(계정). 라운드 안에서만 병렬, 역할 전환은 라운드 사이에 순서대로.
- 병렬 에이전트에게는 **로그아웃·계정 전환·창 크기 변경 금지, 자기가 만든 탭만 사용**이라고 지시한다.
- 화면 폭(모바일/태블릿/데스크톱) 확인은 마지막에 에이전트 1개가 혼자 돈다.
- 끝나면 결과를 합쳐 중복을 지우고 심각도 순으로 PM에게 보고한다.

## 진행 규칙

- 단계가 끝나면 `pm-flow.md`의 체크박스와 "단계 기록"을 바로 갱신한다. 세션이 끊겨도 다음 `/pm-flow`가 이어갈 수 있어야 한다.
- 에이전트나 스킬이 "미정의라 못 했다"를 돌려주면 실패가 아니라 그물이 작동한 것이다. 추측으로 채우지 말고 PM에게 올린다.
- 앞 단계의 결정이 뒤집히면(예: 4단계에서 정책 변경) 해당 단계 체크를 풀고 그 단계부터 다시 돈다. 프로토타입도 같이 고친다.
- Notion 페이지 생성·수정, 브랜치 생성처럼 남에게 보이거나 되돌리기 어려운 일은 하기 전에 PM에게 묻는다. 커밋·push는 PM이 한다.
