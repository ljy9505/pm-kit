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

# 엔진 (항상 갱신 OK — 회사무관)
cp -f "$KIT/agents/planning-reviewer.md" "$TARGET/.claude/agents/"
cp -f "$KIT/context/planning-kickoff.md" "$TARGET/.claude/context/"
echo "[OK] 엔진 복사: planning-reviewer, planning-kickoff"

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

echo
echo "--- 남은 수동 작업 2가지 ---"
echo "1) ponytail 설치 (Claude Code 입력창에서):"
echo "     /plugin marketplace add DietrichGebert/ponytail"
echo "     /plugin install ponytail@ponytail   그리고  /reload-plugins"
echo "2) .claude/context/domain-context.md 를 이 회사 값으로 채우기"
