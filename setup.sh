#!/usr/bin/env bash
# pm-kit 부팅 (macOS / Linux / Git Bash)
# 사용: 새 회사 프로젝트 폴더에서  ->  bash <kit>/setup.sh [대상경로]
# 하는 일: 엔진 파일을 대상 프로젝트의 .claude/ 에 깔고, 기존 실제 값은 절대 덮지 않는다.
set -e
KIT="$(cd "$(dirname "$0")" && pwd)"
TARGET="${1:-$(pwd)}"
echo "kit  : $KIT"
echo "대상 : $TARGET"
echo

mkdir -p "$TARGET/.claude/agents" "$TARGET/.claude/context"

# 엔진 (항상 갱신 OK — 회사무관). TEMPLATE 은 아래에서 따로 다룬다.
cp -f "$KIT"/agents/*.md "$TARGET/.claude/agents/"
for f in "$KIT"/context/*.md; do
  [ "$(basename "$f")" = "domain-context.TEMPLATE.md" ] && continue
  cp -f "$f" "$TARGET/.claude/context/"
done
echo "[OK] 엔진 복사: agents/*, context/* (kickoff·ux-checklist·prediction-eval 등)"

mkdir -p "$TARGET/.claude/commands"
cp -f "$KIT"/commands/*.md "$TARGET/.claude/commands/"
echo "[OK] 명령어 복사: /pm-flow (파이프라인 한 번에 진행)"

# domain-context: 실제 값이 있으면 절대 덮지 않는다 (회사 정책 보호)
dc="$TARGET/.claude/context/domain-context.md"
if [ -f "$dc" ]; then
  echo "[SKIP] domain-context.md 이미 있음 — 유지 (덮지 않음)"
else
  cp "$KIT/context/domain-context.TEMPLATE.md" "$dc"
  echo "[NEW] domain-context.md 템플릿 생성 — 회사 값을 채우세요"
fi

# 루트 CLAUDE.md: 있으면 덮지 않고 안내만
if [ -f "$TARGET/CLAUDE.md" ]; then
  echo "[SKIP] CLAUDE.md 이미 있음 — kit/CLAUDE.md 내용을 수동 병합 권장"
else
  cp "$KIT/CLAUDE.md" "$TARGET/CLAUDE.md"
  echo "[NEW] CLAUDE.md (엔진) 복사"
fi

# 이슈 트래커(Notion) 설정: mattpocock 스킬(to-spec·to-tickets)이 읽는다. 있으면 덮지 않는다
it="$TARGET/docs/agents/issue-tracker.md"
if [ -f "$it" ]; then
  echo "[SKIP] docs/agents/issue-tracker.md 이미 있음 — 유지"
else
  mkdir -p "$TARGET/docs/agents"
  cp "$KIT/templates/issue-tracker-notion.md" "$it"
  echo "[NEW] docs/agents/issue-tracker.md (Notion) 생성 — <NOTION_DB_URL> 을 채우세요"
fi

echo
echo "--- 남은 수동 작업 4가지 ---"
echo "1) mattpocock 스킬 설치 (터미널):"
echo "     claude plugin install mattpocock-skills@claude-plugins-official"
echo "2) ponytail 설치 (Claude Code 입력창에서):"
echo "     /plugin marketplace add DietrichGebert/ponytail"
echo "     /plugin install ponytail@ponytail   그리고  /reload-plugins"
echo "3) .claude/context/domain-context.md 를 이 회사 값으로, docs/agents/issue-tracker.md 의 Notion DB 링크 채우기"
echo "4) Claude Code 에서 /setup-matt-pocock-skills 한 번 실행 (트래커 질문엔 'Other — docs/agents/issue-tracker.md 그대로')"
