# Issue tracker: Notion

이 레포의 스펙·티켓은 **Notion 데이터베이스**에 둔다. `/to-spec`·`/to-tickets`·`/implement`가 이 파일을 읽는다.
Notion MCP(`notion-search`·`notion-fetch`·`notion-create-pages`·`notion-update-page`)로 다룬다.

## 위치

- 데이터베이스: `<NOTION_DB_URL>`  ← 이 레포에 쓸 Notion DB 링크로 바꾼다
- 처음 쓰기 전에 `notion-fetch`로 DB를 읽어 실제 속성 이름을 확인하고, 아래 표와 다르면 이 파일을 고친다.

## 속성 매핑

| 스킬이 쓰는 개념 | Notion 속성 (기본값) | 타입 |
|---|---|---|
| 제목 | `이름` | title |
| 종류 (spec / ticket) | `종류` | select |
| 트리아지 라벨 (`ready-for-agent` 등) | `상태` | select |
| 부모 스펙 | `상위 항목` | relation (같은 DB) |
| Blocked by | `선행 티켓` | relation (같은 DB) |
| 정본 문서 | `정본` | url 또는 text (기능 ID AF-/SF- + 문서 경로) |

## 동작

- **스펙 만들기** (`/to-spec`): 페이지 1개, `종류=spec`, `상태=ready-for-agent`, 본문 = 스펙 템플릿. `정본`에 회사 표준 문서 경로·기능 ID를 반드시 건다.
- **티켓 만들기** (`/to-tickets`): 의존 순서대로(선행 먼저) 페이지 생성, `종류=ticket`, `상위 항목` = 스펙 페이지, `선행 티켓` = 막는 티켓들. 부모 스펙은 수정하지 않는다.
- **읽기**: 사용자가 Notion 링크나 제목을 주면 `notion-fetch`로 본문과 댓글까지 읽는다.
- **진행 가능 티켓(frontier)**: `선행 티켓`이 전부 완료인 티켓.
- **완료 처리**: `상태`를 완료 값으로 바꾼다(DB에 있는 값 사용).
- 페이지 생성·수정은 사용자에게 보이는 쓰기다 — 만들기 전에 목록을 보여주고 승인받는다.
