# DUNGSIL's Vibe Skills

바이브 코딩용 [에이전트 스킬](https://agentskills.io/home) 모음집

## 설치

스킬이 올바르게 작동하기 위해서 모든 스킬을 받아야 합니다.

```
pnpm dlx skills add dungsil-ai/vibe -g -y --skill *
```

`vibe-init`은 필수 선행 작업이 아닙니다. 설정 파일이 없으면 `.agents/plans/`의 로컬 Markdown 형식으로 바로 진행하며, 이미 지정한 트래커와 사용자 선택은 유지합니다.

## 개선점 조사와 실행 계획

`improve`의 기능은 기존 스킬의 책임에 맞게 나눕니다. 별도의 `vibe-improve` 진입점은 만들지 않습니다.

| 스킬 | 담당 기능 |
| --- | --- |
| [vibe-audit](skills/vibe-audit) | 전체·범주별·`branch` 감사, `quick`·`deep` 조사 수준, 검증된 개선점과 계획 인계 |
| [vibe-next-plan](skills/vibe-next-plan) | `next`·`features`·`roadmap` 방향 조사, 선택한 제안의 설계·타당성 조사 계획 인계 |
| [vibe-plan](skills/vibe-plan) | `plan` 실행 계획 작성, `review-plan` 검토·보완, `reconcile` 상태 재검증, 명시적인 `--issues` 게시 |
| [vibe-implement](skills/vibe-implement) | `execute <plan>` 격리 실행과 독립 검증, 결과 반환 |

조사 스킬은 파일이나 트래커를 변경하지 않습니다. 선택된 항목의 실행 계획은 `vibe-plan`이 작성합니다. 새 실행 계획은 `.agents/plans/<work-slug>/execution-plan.md`, 색인은 `.agents/plans/execution-index.md`에 두며 기존 명세·티켓과 구분합니다. 실행 계획의 `DONE`은 검토된 실행 완료를 뜻하며, 원본 브랜치 반영이나 이슈 닫기를 뜻하지 않습니다.

## 출처

`vibe-docs`는 Agent Skill 작업의 한국어 문서, 커밋 메시지, 이슈와 PR을 작성하고 검토합니다. `fluent-korean`의 전체 지침은 `vibe-docs` 안에 직접 포함되어 있으므로 외부 문서를 읽지 않아도 됩니다.

| 스킬 | 출처 |
| --- | --- |
| [vibe-docs](skills/vibe-docs) | [snflkd/fluent-korean](https://github.com/snflkd/fluent-korean)의 코딩 버전 (MIT) |
| [vibe-init](skills/vibe-init) | [mattpocock/skills](https://github.com/mattpocock/skills/)의 `setup-matt-pocock-skills` (MIT) |
| [vibe-goal](skills/vibe-goal) | 이 프로젝트에서 추가 |
| [vibe-plan](skills/vibe-plan) | [mattpocock/skills](https://github.com/mattpocock/skills/)의 `grill-with-docs`, `to-spec`, `to-tickets`, `triage`와 [shadcn/improve](https://github.com/shadcn/improve)의 실행 계획 작성·관리 흐름 (MIT) |
| [vibe-deep-plan](skills/vibe-deep-plan) | [mattpocock/skills](https://github.com/mattpocock/skills/)의 `wayfinder`, `research`, `prototype` (MIT) |
| [vibe-implement](skills/vibe-implement) | [mattpocock/skills](https://github.com/mattpocock/skills/)의 `implement`, `tdd`, `resolving-merge-conflicts`와 `pr`의 검증 근거·위험 설명 규칙, [shadcn/improve](https://github.com/shadcn/improve)의 `execute` 흐름 (MIT) |
| [vibe-review](skills/vibe-review) | [mattpocock/skills](https://github.com/mattpocock/skills/)의 `code-review`와 `retro`의 자동 검사 분류 규칙 (MIT) |
| [vibe-refactor](skills/vibe-refactor) | [mattpocock/skills](https://github.com/mattpocock/skills/)의 `improve-codebase-architecture` (MIT) |
| [vibe-audit](skills/vibe-audit) | [shadcn/improve](https://github.com/shadcn/improve)의 전체·범주별·브랜치 감사 흐름 (MIT) |
| [vibe-next-plan](skills/vibe-next-plan) | [shadcn/improve](https://github.com/shadcn/improve)의 `improve`를 `next` 흐름으로 바꾼 버전 (MIT) |
| [vibe-handoff](skills/vibe-handoff) | [mattpocock/skills](https://github.com/mattpocock/skills/)의 `handoff` (MIT) |
| [vibe-debug](skills/vibe-debug) | [mattpocock/skills](https://github.com/mattpocock/skills/)의 `diagnosing-bugs` (MIT) |
| [vibe-modeling](skills/vibe-modeling) | [mattpocock/skills](https://github.com/mattpocock/skills/)의 `domain-modeling` (MIT) |
| [vibe-grilling](skills/vibe-grilling) | [mattpocock/skills](https://github.com/mattpocock/skills/)의 `grilling` (MIT) |
