# 영어 작성 규칙

영어 글은 ASD-STE100 Simplified Technical English(STE) 규칙으로 쓴다. STE는 기술 문서를 위한 통제 언어이며, 영어에 익숙하지 않은 독자도 뜻을 분명하게 이해하도록 문장 형태와 어휘를 제한한다. 이 파일에는 STE 규칙 가운데 가장 중요한 규칙을 담았다. 전체 규칙은 `references/english/writing-rules.md`에, 승인 단어는 `references/english/word-list.md`에 있다. 이 파일에 적은 경로는 모두 이 스킬 디렉터리를 기준으로 한다.

## 적용 기준

- 이 스킬의 적용 범위에 속하는 영어 글에 적용한다. 한국어 문장 안에 쓴 영어 용어에는 적용하지 않는다.
- 마케팅이나 브랜드 문구, 시, 이야기, 기술 내용이 없는 일상 대화에는 적용하지 않는다.
- 코드 블록, 식별자, 명령, 파일 경로, 인용한 오류 메시지, 인용문, 제품, 부품, 문서의 공식 이름은 바꾸지 않는다.
- `SKILL.md`의 `확정된 도메인 용어 보호` 절과 `references/repo-writing.md`의 규범은 영어 글에도 적용한다. 확정된 도메인 용어는 STE의 기술 이름으로 다루므로, 승인 단어 목록에 없어도 그대로 쓴다.
- 사용자가 다른 문체를 요청하면 그 요청이 이 파일의 규칙보다 우선한다.
- 이 규칙은 ASD-STE100 Issue 7(2017)을 바탕으로 만든 비공식 요약이다. 검사를 통과한 글이라도 공식 규격을 완전히 지켰다고 표현하지 않는다.

## 1단계: 글의 종류 구분

쓰기 전에 글의 각 부분을 아래 두 종류로 나눈다. 두 종류는 문장 길이 제한이 다르므로, 한 문단에 섞지 않는다.

- 절차 글(procedural text)은 읽는 이에게 할 일을 지시한다. 예: `Remove the four bolts.`
- 설명 글(descriptive text)은 정보를 전달한다. 예: `The pump supplies fuel to the engine.`

## 2단계: 동사 규칙

- 동사는 부정사, 명령형, 단순 현재, 단순 과거, `will`을 쓴 미래, 형용사로 쓰는 과거분사로만 쓴다.
- 동사의 `-ing` 형태를 쓰지 않는다. 승인된 `-ing` 단어는 `mating`, `missing`, `remaining`, `lighting`, `opening`, `routing`, `servicing`, `during`뿐이다. 기술 이름의 수식어(`grinding wheel`)나 제목에 쓰는 `-ing` 형태는 예외다.
- 과거분사와 함께 조동사를 쓰지 않는다. `the operator has adjusted the linkage`가 아니라 `the operator adjusted the linkage`로 쓴다.
- 능동태로 쓴다. `the circuits are connected by a relay`가 아니라 `a relay connects the circuits`로 쓴다.
- 절차 글은 명령형으로 쓴다. 예: `Set the switch to ON.`
- 행위자가 없으면 `you`나 `we`를 주어로 쓴다.
- 조동사는 `can`, `must`, `will`만 쓴다. `should`, `would`, `may`, `might`, `shall`은 쓰지 않는다.
- `is`나 `are` 뒤의 과거분사는 상태를 나타내므로 쓸 수 있다. 예: `The wires are disconnected.`

## 3단계: 문장 규칙

- 절차 문장은 최대 20단어, 설명 문장은 최대 25단어로 쓴다. 숫자와 단위, 약어, 식별자, 따옴표로 묶은 문구, 하이픈으로 이은 묶음은 각각 한 단어로 센다.
- 문단은 최대 6문장으로 쓰고, 문단 하나에서 주제를 하나만 다룬다.
- 한 문장에는 지시를 하나만 쓴다. 두 동작은 동시에 일어날 때만 한 문장에 쓴다.
- 한 문장에는 주제를 하나만 쓴다.
- 조건이 명령보다 앞에 오면 조건 뒤에 쉼표를 둔다. 예: `If the light comes on, stop the engine.`
- 관사, 주어, 동사, 접속사 `that`을 빼지 않는다. 예: `make sure that the file exists`
- 축약형을 쓰지 않는다. `don't`가 아니라 `do not`으로 쓴다.
- 세미콜론을 쓰지 않고 두 문장으로 나눈다.
- 복잡한 내용은 세로 목록으로 쓴다. `not`이 들어간 명령을 목록으로 나열할 때는 항목마다 `not`을 다시 쓴다.

## 4단계: 단어 규칙

- 단어는 `references/english/word-list.md`의 승인 단어, 기술 이름, 기술 동사만 쓴다.
- 기술 이름은 부품, 도구, 재료, 시스템, 문서의 공식 이름이나 그 분야의 용어다. 예: `engine`, `firewall`, `torque wrench`, `SKILL.md`
- 승인 단어는 목록에 적힌 품사로만 쓴다. `test`는 명사이므로 `test the system`이 아니라 `do a test`로 쓴다.
- 글 전체에서 한 대상에는 한 이름만 쓰고, 같은 대상을 다른 이름으로 바꿔 부르지 않는다.
- 명사 묶음은 최대 3단어로 쓴다. 더 긴 묶음은 `of`, `on`, `in`, `for`로 나눈다.
- 구동사를 만들지 않는다. `put out the fire`가 아니라 `extinguish the fire`로 쓴다.
- 막연한 단어 대신 구체적인 수량, 이름, 동작을 쓴다.
- 철자는 미국 영어를 따른다.
- 자주 쓰이는 대체어는 `references/english/substitutions.md`에 있다.

## 5단계: 안전 지시

- 사람이 다치거나 죽을 위험에는 `WARNING`을 쓴다.
- 물건이 손상될 위험에는 `CAUTION`을 쓴다.
- 간단한 명령이나 조건으로 시작하고, 이어서 위험을 설명한다. 예: `WARNING: Do not touch the connector. The connector can have a dangerous voltage.`

## 6단계: 검사

영어 글을 쓴 뒤에는 아래 순서로 검사한다.

1. 스크립트를 실행할 수 있으면 아래 명령을 실행한다. `scripts/english/check.py`는 이 스킬 디렉터리를 기준으로 한 경로다.

   ```bash
   python3 scripts/english/check.py --mode <procedural|descriptive|mixed> <file>
   ```

   절차 글과 설명 글이 함께 있는 글은 `mixed`로 검사한다. 커밋 메시지나 PR 본문처럼 파일이 아닌 글은 UTF-8 임시 파일로 저장한다. 코드 주석은 주석 기호(`//`, `#`, `/*`, `*`)와 주석 태그를 뺀 문장만 임시 파일로 옮긴다. 스크립트는 `#`로 시작하는 문단을 제목으로 보고 건너뛰기 때문이다.

2. 스크립트를 실행할 수 없으면 아래 목록으로 직접 검사한다.
3. 찾은 오류를 모두 고친다.
4. 다시 검사하고, 오류가 없을 때만 멈춘다.

직접 검사할 항목은 다음과 같다.

- 세미콜론과 축약형을 찾아 없앤다.
- 과거분사 앞의 `has`, `have`, `had`를 찾아 단순 과거로 바꾼다.
- `should`, `would`, `may`, `might`, `shall`을 찾아 바꾸거나 없앤다.
- 승인되지 않았고 기술 이름에도 속하지 않는 `-ing` 단어를 찾아 다시 쓴다.
- 수동태를 찾아 행위자를 주어로 쓰거나 명령형으로 바꾼다.
- 가장 긴 문장들의 단어 수를 세고, 제한을 넘는 문장을 나눈다.
- 문단마다 문장 수를 세고, 6문장을 넘는 문단을 나눈다.
- 승인되지 않았고 기술 이름도 아닌 단어를 찾아 바꾼다.

스크립트는 모든 오류를 찾지 못하고, 단어가 승인된 뜻으로 쓰였는지도 판단하지 못한다. 따라서 스크립트를 실행한 뒤에도 쓴 단어를 `references/english/word-list.md`와 비교한다. 스크립트가 `CHECK`로 나열한 단어는 기술 이름이나 기술 동사인지 확인하고, 둘 다 아니면 대체어로 바꾼다.
