#!/usr/bin/env bash
# 사용자가 단계를 직접 수행하며 버그를 재현하는 루프다.
# 이 파일을 복사하고 아래 단계를 편집한 뒤 실행한다.
# 에이전트가 스크립트를 실행하고, 사용자는 자신의 터미널에서 프롬프트를 따라갑니다.
#
# 사용법:
#   bash hitl-loop.template.sh
#
# 두 도우미:
#   step "<지시>"          → 지시를 보여주고, Enter를 기다린다
#   capture VAR "<질문>"   → 질문을 보여주고, 응답을 VAR에 읽는다
#
# 마지막에 스크립트가 캡처한 값을 KEY=VALUE 형태로 출력한다.
# 에이전트는 이 출력을 파싱한다.
# 사용자는 비밀값을 가린 관찰 결과만 `capture`에 입력한다.
# 로그인은 사용자가 `step` 함수로 직접 한다.
# 이 스크립트는 입력을 자동으로 가리지 않는다.

set -euo pipefail

step() {
  printf '\n>>> %s\n' "$1"
  read -r -p "    [완료 시 Enter] " _
}

capture() {
  local var="$1" question="$2" answer
  printf '\n>>> %s\n' "$question"
  printf '    토큰, 비밀번호, 쿠키, 개인 식별 정보를 <REDACTED>로 바꾼 관찰 결과만 입력하세요. 입력은 그대로 출력됩니다.\n'
  read -r -p "    > " answer
  printf -v "$var" '%s' "$answer"
}

# --- 편집 영역 시작 ---

step "http://localhost:3000에서 앱을 열고 로그인하세요."

capture ERRORED "'내보내기' 버튼을 클릭하세요. 에러가 발생했나요? (y/n)"

capture ERROR_MSG "비밀값을 가린 에러 메시지를 붙여넣으세요 (또는 'none'):"

# --- 편집 영역 끝 ---

printf '\n--- 캡처 결과 ---\n'
printf 'ERRORED=%s\n' "$ERRORED"
printf 'ERROR_MSG=%s\n' "$ERROR_MSG"
