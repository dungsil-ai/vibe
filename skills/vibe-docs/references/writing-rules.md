# STE 작성 규칙

이 파일은 ASD-STE100(Issue 7)의 작성 규칙 53개와 일반 권고 4개를 담고 있다.
이 규칙은 공식 원문이 아니다. 원작자가 STE로 다시 쓴 요약을 한국어로 옮겼다.

## 목차

- 1절: 단어 (규칙 1.1~1.14)
- 2절: 명사 묶음 (규칙 2.1~2.3)
- 3절: 동사 (규칙 3.1~3.7)
- 4절: 문장 (규칙 4.1~4.4)
- 5절: 절차 글 (규칙 5.1~5.5)
- 6절: 설명 글 (규칙 6.1~6.6)
- 7절: 안전 지시 (규칙 7.1~7.3)
- 8절: 문장 부호와 단어 수 (규칙 8.1~8.7)
- 9절: 작성 관행 (규칙 9.1~9.4)
- 일반 권고 (GR-1~GR-4)

예시에서 `STE 아님`은 고쳐야 할 글을 나타내고, `STE`는 올바른 글을 나타낸다. 

## 1절: 단어

**규칙 1.1**: 사전이 승인한 단어, 기술 이름, 기술 동사만 쓸 수 있다.

**규칙 1.2**: 승인 단어는 사전에 적힌 품사로만 쓴다.
- STE 아님: `Test the system for leaks.` (`test`는 명사로만 승인되어 있다.)
- STE: `Do a leak test of the system.`

**규칙 1.3**: 승인 단어는 승인된 뜻으로만 쓴다. 승인된 뜻은 일상적인 뜻보다 좁은 경우가 많다.
- STE 아님: `Follow the safety instructions.` (`follow`의 승인된 뜻은 `come after`뿐이다.)
- STE: `Obey the safety instructions.`

**규칙 1.4**: 동사와 형용사는 승인된 형태로만 쓴다. 승인된 형태는 단어 목록에 있다.

**규칙 1.5**: 기술 이름 범주에 속하는 단어는 쓸 수 있다. 19개 범주는 `substitutions.md`에 있다.

**규칙 1.6**: 승인되지 않은 단어는 기술 이름이거나 기술 이름의 일부일 때만 쓸 수 있다.
- 허용: `the base of the triangle` (수학 용어)
- STE 아님: `at the base of the unit`. STE: `at the bottom of the unit`.

**규칙 1.7**: 기술 이름을 동사로 쓰지 않는다.
- STE 아님: `Oil the steel surfaces.`
- STE: `Apply oil to the steel surfaces.`

**규칙 1.8**: 기술 이름은 프로젝트나 회사의 공식 명명 체계에 맞게 쓴다.

**규칙 1.9**: 기술 이름을 직접 골라야 하면 짧고 이해하기 쉬운 이름을 고른다.

**규칙 1.10**: 속어나 은어를 기술 이름으로 쓰지 않는다.
- STE 아님: `Make a sandwich with two washers and the spacer.`
- STE: `Install the spacer between the two washers.`

**규칙 1.11**: 한 대상에는 기술 이름을 하나만 쓴다. 여러 이름을 번갈아 쓰지 않는다.

**규칙 1.12**: 기술 동사 범주에 속하는 동사는 쓸 수 있다. 다만 쓸 수 있는 승인 동사가 있으면 승인 동사를 쓴다.
- STE 아님: `If you detect broken wires, repair them.`
- STE: `If you find broken wires, repair them.`

**규칙 1.13**: 기술 동사를 명사로 쓰지 않는다. 기술 동사의 과거분사는 형용사로 쓸 수 있다(`the reamed hole`).

**규칙 1.14**: 미국 영어 철자를 쓴다. `colour`가 아니라 `color`로 쓴다.

## 2절: 명사 묶음

**규칙 2.1**: 명사 묶음은 최대 3단어로 쓴다. 관사와 전치사는 세지 않는다. 긴 묶음은 전치사로 나눈다.
- STE 아님: `the runway light connection resistance calibration`
- STE: `the calibration of the resistance of the runway light connection`

**규칙 2.2**: 기술 이름이 3단어보다 길면 처음 한 번은 전체 이름을 쓴다. 그다음에는 짧은 이름을 정해서 쓰거나, 한 단위를 이루는 단어 사이에 하이픈을 넣는다.
- 예: `landing-light cutoff-switch power connection`
- 하이픈으로 4단어 이상을 잇지 않는다.

**규칙 2.3**: 명사 앞에는 관사(`the`, `a`, `an`)나 지시 형용사(`this`, `these`)를 쓴다.
- STE 아님: `Turn shaft assembly.`
- STE: `Turn the shaft assembly.`
- 예외: 식별자가 붙은 명사 앞에는 `the`를 쓰지 않는다. `circuit breaker 36L7`처럼 쓴다.

## 3절: 동사

**규칙 3.1**: 동사는 단어 목록에 있는 형태로만 쓴다.

**규칙 3.2**: 동사는 부정사, 명령형, 단순 현재, 단순 과거, 형용사로 쓰는 과거분사, 미래 시제를 만들 때만 쓴다. 다른 시제는 쓸 수 없다.

**규칙 3.3**: 과거분사는 명사 앞이나 `to be`, `to become` 뒤에서 형용사로만 쓴다. 이 형태는 상태를 나타내며 수동태가 아니다.
- 허용: `The wires are disconnected.`

**규칙 3.4**: 조동사로 복잡한 동사 구조를 만들지 않는다.
- STE 아님: `The operator has adjusted the linkage.` STE: `The operator adjusted the linkage.`
- STE 아님: `The volume control can be adjusted.` STE: `You can adjust the volume control.`
- STE 아님: `The temperature must be adjusted.` STE: `Adjust the temperature.`

**규칙 3.5**: `-ing` 형태는 기술 이름의 수식어(`grinding wheel`, `air conditioning system`)나 제목에서만 쓴다.
- STE 아님: `When you are doing this procedure...`
- STE: `When you do this procedure...`
- 승인된 `-ing` 단어는 `mating`, `missing`, `remaining`, `lighting`, `opening`, `routing`, `servicing`, `during`뿐이다.

**규칙 3.6**: 절차 글에서는 능동태를 쓴다. 설명 글에서도 가능한 한 능동태를 쓴다.
- 행위자를 주어로 쓴다: `A switching relay connects the circuits.`
- 명령형을 쓴다: `Continue the test.`
- 행위자가 없으면 `you`(읽는 이)나 `we`(쓰는 이)를 주어로 쓴다.

**규칙 3.7**: 동작은 승인 동사로 나타낸다. 명사나 다른 품사로 동작을 나타내지 않는다.
- STE 아님: `The ohmmeter gives an indication of 450 ohms.`
- STE: `The ohmmeter shows 450 ohms.`

## 4절: 문장

**규칙 4.1**: 짧고 분명한 문장을 쓴다. 구체적인 정보를 준다. 한 문장에는 주제를 하나만 쓴다.
- STE 아님: `No leaks permitted.`
- STE: `Make sure that there are no leaks.`

**규칙 4.2**: 필요한 단어를 모두 쓴다. 축약형을 쓰지 않는다.
- 주어를 빼지 않는다: `If shims are installed, remove them.` (STE 아님: `If installed, remove the shims.`)
- 동사, 관사, `that`을 빼지 않는다.
- `don't`가 아니라 `do not`으로 쓴다.

**규칙 4.3**: 복잡한 내용은 세로 목록으로 쓴다. 첫 줄 끝에는 콜론을 둔다. `not`이 들어간 명령을 목록으로 쓸 때는 항목마다 `not`을 다시 쓴다.

**규칙 4.4**: 주제가 이어지는 문장은 연결어로 잇는다. 예: `and`, `but`, `then`, `thus`, `as a result`

## 5절: 절차 글

**규칙 5.1**: 짧은 문장을 쓴다. 문장마다 최대 20단어를 쓴다. 이 제한은 경고와 주의에도 적용한다.

**규칙 5.2**: 한 문장에는 지시를 하나만 쓴다. 둘 이상의 동작은 동시에 일어날 때만 한 문장에 쓸 수 있다.
- 허용: `Hold the panel in its position and install the fastener.`

**규칙 5.3**: 모든 지시는 명령형으로 쓴다.
- STE: `Set the switch to ON.`

**규칙 5.4**: 조건이나 설명이 명령보다 앞에 오면 둘 사이에 쉼표를 둔다.
- STE: `When the light comes on, set the switch to NORMAL.`

**규칙 5.5**: 참고(note)는 정보를 줄 때만 쓴다. 참고에는 지시나 요구 사항을 넣지 않는다. 그 정보가 손상이나 부상을 막는다면 주의(caution)나 경고(warning)로 쓴다. 참고는 최대 25단어로 쓴다.

## 6절: 설명 글

**규칙 6.1**: 정보를 단계적으로 준다. 한 문장에는 주제를 하나만 쓴다.

**규칙 6.2**: 핵심어와 연결어로 글의 구조를 분명하게 드러낸다. 이어지는 문장에서 같은 핵심어를 다시 쓴다.

**규칙 6.3**: 짧은 문장을 쓴다. 문장마다 최대 25단어를 쓴다.

**규칙 6.4**: 관련된 정보는 문단으로 묶는다. 문단은 주제 문장으로 시작하고, 나머지 문장은 그 주제에 관한 정보를 더한다.

**규칙 6.5**: 한 문단에는 주제를 하나만 쓴다.

**규칙 6.6**: 문단마다 최대 6문장을 쓴다.

## 7절: 안전 지시

경고(warning)는 사람이 다치거나 죽을 위험을 나타낸다. 주의(caution)는 물건이 손상될 위험을 나타낸다.

**규칙 7.1**: `WARNING`이나 `CAUTION`처럼 알맞은 단어로 위험의 수준을 나타낸다. 위험을 분석해서 알맞은 단어를 고른다.

**규칙 7.2**: 안전 지시는 분명하고 간단한 명령이나 조건으로 시작한다.
- STE: `DO NOT SWALLOW THE SOLVENT.`
- STE: `WHILE YOU USE THE SPRAY PAINT, POINT THE SPRAY AWAY FROM YOUR FACE.`

**규칙 7.3**: 위험이나 일어날 수 있는 결과를 설명한다.
- STE: `SOLVENTS ARE POISONOUS AND CAN CAUSE INJURY OR DEATH TO PERSONNEL.`

## 8절: 문장 부호와 단어 수

**규칙 8.1**: 영어의 표준 문장 부호는 모두 쓸 수 있지만, 세미콜론은 쓰지 않는다. 세미콜론 대신 두 문장으로 나눈다.

**규칙 8.2**: 밀접하게 관련된 단어는 하이픈으로 잇는다. 예: `low-altitude flight`, `quick-release fastener`, `O-ring`, `de-energize`, `forty-seven`

**규칙 8.3**: 괄호는 참조(`refer to Figure 1`), 항목 번호(`the hoses (2) and (12)`), 약어(`Liquid Crystal Display (LCD)`), 짧은 설명에 쓸 수 있다.

**규칙 8.4**: 세로 목록에서 콜론은 단어 수를 셀 때 마침표와 같게 본다. 목록의 각 항목은 새 문장으로 센다.

**규칙 8.5**: 괄호 안의 글은 그 문장에서 한 단어로 센다. 같은 글은 따로 하나의 문장으로도 센다.

**규칙 8.6**: 숫자, 단위가 붙은 숫자, 약어, 두문자어, 식별자, 따옴표로 묶은 글, 제목이나 명판의 글은 각각 한 단어로 센다.

**규칙 8.7**: 하이픈으로 이은 묶음은 한 단어로 센다. `Main-gear-door retraction-winch handle`은 3단어로 센다.

## 9절: 작성 관행

**규칙 9.1**: 단어만 바꿔서는 부족하면 문장 구조를 바꾼다. 새 문장이 원래 뜻을 정확하게 유지하는지 확인한다. 가장 중요한 목표는 읽는 이가 모든 문장을 바로 이해하는 것이다.
- STE 아님: `The oil level must be visible during the test.`
- STE: `Make sure that you can see the oil level during the test.`

**규칙 9.2**: 승인 단어를 정확하게 쓴다. 단어를 쓰기 전에 승인된 뜻을 확인한다.
- `wear`는 명사다. `wear protective clothing`이 아니라 `put on protective clothing`으로 쓴다.
- `see`는 눈으로 보는 것만 뜻한다. `see if`가 아니라 `make sure that`으로 쓴다.
- `turn`은 축을 중심으로 도는 움직임만 뜻한다. 색이 바뀌는 것은 `the color of the indicator changes to green`처럼 쓴다.

**규칙 9.3**: 두 단어를 합쳐 구동사를 만들지 않는다.
- STE 아님: `put out the fire`. STE: `extinguish the fire`.
- STE 아님: `give off fumes`. STE: `release fumes`.

**규칙 9.4**: 일관된 문체를 쓴다. 절차 글에서는 같은 종류의 단계에 같은 단어를 쓰고, 같은 대상에 같은 이름을 쓴다. 설명 글에서는 읽기 쉽게 하려고 문장 구조를 바꿀 수 있다.

## 일반 권고

**GR-1**: `make sure`, `show` 같은 동사 뒤의 접속사 `that`을 빼지 않는다. 예: `Make sure that the valve is open.`

**GR-2**: 전치사 `with`는 문장의 뜻을 흐릴 수 있다. 문장을 다시 읽고 뜻을 분명하게 쓴다.
- 불분명: `Seal the opening with the specified tool.`
- 분명: `Use the specified tool to seal the opening.`

**GR-3**: 대명사가 둘 이상의 명사를 가리킬 수 있으면 대명사를 그 명사로 바꾼다.
- 불분명: `...they can become damaged.` 분명: `...the pins can become damaged.`

**GR-4**: `this`가 둘 이상의 대상을 가리킬 수 있으면 전체 맥락을 다시 쓴다.
- 분명: `If the cover is locked, damage to the probe can occur.`
