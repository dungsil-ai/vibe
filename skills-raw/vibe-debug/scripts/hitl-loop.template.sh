#!/usr/bin/env bash
# 휴먼 인 더 루프 재현 루프.
# 이 파일을 복사하고 아래 단계를 편집한 뒤 실행하세요.
# 에이전트가 스크립트를 실행하고, 사용자는 자신의 터미널에서 프롬프트를 따라갑니다.
#
# 사용법:
#   bash hitl-loop.template.sh
#
# 두 도우미:
#   step "<지시>"          → 지시를 보여주고, Enter를 기다린다
#   capture VAR "<질문>"   → 질문을 보여주고, 응답을 VAR에 읽는다
#
# 마지막에, 캡처한 값이 에이전트가 파싱할 수 있도록 KEY=VALUE 형태로 출력된다.

set -euo pipefail

step() {
  printf '\n>>> %s\n' "$1"
  read -r -p "    [완료 시 Enter] " _
}

capture() {
  local var="$1" question="$2" answer
  printf '\n>>> %s\n' "$question"
  read -r -p "    > " answer
  printf -v "$var" '%s' "$answer"
}

# --- 아래를 편집 ---------------------------------------------------------

step "http://localhost:3000에서 앱을 열고 로그인하세요."

capture ERRORED "'내보내기' 버튼을 클릭하세요. 에러가 발생했나요? (y/n)"

capture ERROR_MSG "에러 메시지를 붙여넣으세요 (또는 'none'):"

# --- 위를 편집 ---------------------------------------------------------

printf '\n--- 캡처 결과 ---\n'
printf 'ERRORED=%s\n' "$ERRORED"
printf 'ERROR_MSG=%s\n' "$ERROR_MSG"
