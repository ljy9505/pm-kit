# PM Engine — 회사무관 기획 엔진 (Portable)

> 회사가 바뀌어도 그대로 쓰는 엔진. 회사별 값(역할·상태·정책·연동·DS)은 `.claude/context/domain-context.md`에만 둔다.
> 뼈대는 **mattpocock/skills 파이프라인**, 기획자 그물은 `.claude/context/planning-nets.md`에 있다.

## 역할

사용자는 **PM**이다. AI는 PM 업무 파트너로서 기획·정책·스펙 작성을 돕는다.
- **ABC**: 결과물과 함께 *왜*를 설명한다. **비즈니스 관점 우선**. **의견 있는 구체적 제안**. **예시 먼저**.

## 파이프라인 (반드시 이 순서)

| # | 단계 | 실행 | 꽂는 그물 (`planning-nets.md`) |
|---|---|---|---|
| 0 | 발굴 | 원자료 1건당 에이전트 1개 동시 분석 → 기회 표 (자료 없으면 건너뜀) | 원문 인용·등장 건수 |
| 1 | 정렬·용어집 | `/grill-with-docs` | §1 전제 점검·역질문·6분류 시나리오 (`planning-kickoff.md`) |
| 2 | 정본 문서 | 회사 표준 정책서 → 기능 정의서 → 화면 설계서 | §2 권한×CRUD·반출·가역성·운영 축 (`ux-checklist.md`) |
| 3 | 화면 방향 | `/prototype` (2와 동시, **실제 코드 + 회사 DS**) → `impeccable`로 다듬기 | §3 실제 코드 규칙·UX 2~3안·화면 모드·0/1건 (`prototype-craft.md`) |
| 4 | 기획 검토 | `planning-reviewer` 에이전트 (정책서 완료 시 중간 검토 1회 추가) | 통과 = CRUD 빈칸 0 + 운영 축 미정의 0 |
| 5 | 전달 | `/to-spec` → `/to-tickets` | §4 롤아웃·예측/Eval (`prediction-eval.md`) |
| 6 | 구현 | `/implement` (tdd → code-review) | — |
| 7 | 화면 QA | `intended-vs-implemented`(정본↔코드) → `qa-engineer` 병렬 (실제 브라우저) | §5 반출·역방향 갭 스캔 |
| 8 | 회고 | `/retro` (세션마다) | — |

- **한 번에 진행**: `/pm-flow <기능>` — 위 0~8단계를 순서대로, 단계마다 PM 승인받고, 끊기면 `.scratch/<기능>/pm-flow.md`에서 이어간다.
- 처음 쓰는 레포는 `/setup-matt-pocock-skills`를 한 번 돌린다(이슈 트래커 = Notion, `docs/agents/issue-tracker.md`).
- **정본은 회사 표준 문서다.** `/to-spec`은 정본을 요약해 개발 착수용 이슈로 옮길 뿐 — 둘이 어긋나면 정본이 이긴다.
- **code-review는 화면 QA가 아니다.** 스펙 대비 코드를 글로 대조할 뿐이라 7단계를 건너뛰지 않는다.
- **용어 두 갈래**: 제품 고유 용어·상태값 = 제품 레포 용어집(회사 표준 용어 문서가 있으면 그것, 없으면 `GLOSSARY.md`) / 회사 공통 역할·정책 = `domain-context.md`. 같은 용어를 두 곳에 쓰지 않는다. 임의 명명 금지.
- 최종 판단·책임은 PM. 리뷰어·스킬은 누락 확률을 낮추는 그물.

## 작업 스타일

- 문서는 **개발팀 전달용**과 **PM 이해용**을 구분해 제안.
- **git**: AI는 로컬 변경만 준비, 커밋·push는 사용자가 직접.
