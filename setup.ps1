# pm-kit 부팅 (Windows / PowerShell)
# 사용: 새 회사 프로젝트 폴더에서  ->  powershell -ExecutionPolicy Bypass -File <kit>\setup.ps1 [-Target <프로젝트경로>]
# 하는 일: 엔진 파일을 대상 프로젝트의 .claude/ 에 깔고, 기존 실제 값은 절대 덮지 않는다.

param([string]$Target = (Get-Location).Path)

$Kit = $PSScriptRoot
Write-Host "kit  : $Kit"
Write-Host "대상 : $Target`n"

New-Item -ItemType Directory -Force -Path "$Target\.claude\agents","$Target\.claude\context" | Out-Null

# 엔진 (항상 최신으로 갱신 OK — 회사무관). TEMPLATE 은 아래에서 따로 다룬다.
Copy-Item "$Kit\agents\*.md" "$Target\.claude\agents\" -Force
Get-ChildItem "$Kit\context\*.md" -Exclude "domain-context.TEMPLATE.md" |
  Copy-Item -Destination "$Target\.claude\context\" -Force
Write-Host "[OK] 엔진 복사: agents\*, context\* (kickoff·ux-checklist·prediction-eval 등)"

# domain-context: 실제 값이 이미 있으면 절대 덮지 않는다 (회사 정책 보호)
$dc = "$Target\.claude\context\domain-context.md"
if (Test-Path $dc) {
  Write-Host "[SKIP] domain-context.md 이미 있음 — 유지 (덮지 않음)"
} else {
  Copy-Item "$Kit\context\domain-context.TEMPLATE.md" $dc
  Write-Host "[NEW] domain-context.md 템플릿 생성 — 회사 값을 채우세요"
}

# 루트 CLAUDE.md: 이미 있으면 덮지 않고 안내만
if (Test-Path "$Target\CLAUDE.md") {
  Write-Host "[SKIP] CLAUDE.md 이미 있음 — kit\CLAUDE.md 내용을 수동 병합 권장"
} else {
  Copy-Item "$Kit\CLAUDE.md" "$Target\CLAUDE.md"
  Write-Host "[NEW] CLAUDE.md (엔진) 복사"
}

Write-Host "`n--- 남은 수동 작업 2가지 ---"
Write-Host "1) ponytail 설치 (Claude Code 입력창에서):"
Write-Host "     /plugin marketplace add DietrichGebert/ponytail"
Write-Host "     /plugin install ponytail@ponytail   그리고  /reload-plugins"
Write-Host "2) .claude\context\domain-context.md 를 이 회사 값으로 채우기"
