# HTML 보고서 형식

아키텍처 검토는 OS 임시 디렉터리의 단일 자체 완결 HTML 파일로 렌더링된다. Tailwind와 Mermaid 모두 CDN에서 불러온다. Mermaid는 그래프 모양 다이어그램을 안정적으로 처리하고, 손으로 만든 div와 인라인 SVG는 더 편집적인 시각화(매스 다이어그램, 단면도)를 처리한다. 둘을 섞어라 — Mermaid에만 의존하지 마라, 그러면 획일적으로 보인다.

보고서는 한국어로 쓴다. 제목, 범례, 카드, 성과, 다이어그램 라벨 모두 한국어. CSS 클래스 이름만 영어여도 된다.

## 목차

- 뼈대 — 자체 완결 HTML 전체 골격
- 머리말 — 보고서 제목 블록
- 후보 카드 — 후보별 마크업
- 다이어그램 패턴 — Mermaid 그래프, 손으로 만든 박스, 단면도, 매스 다이어그램, 호출 그래프 접기
- 스타일 안내 — Tailwind 관례
- 최우선 권고 섹션
- 어조

## 뼈대

```html
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="utf-8" />
    <title>아키텍처 검토 — {{repo name}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      /* Tailwind가 깔끔하게 처리하지 못하는 작은 커스텀 층:
         점선 경계, 손그림 느낌의 화살촉 등 */
      .join { stroke-dasharray: 4 4; }
      .leak { stroke: #dc2626; }
      .deep { background: linear-gradient(135deg, #0f172a, #1e293b); }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-5xl mx-auto px-6 py-12 space-y-12">
      <header>...</header>
      <section id="candidates" class="space-y-10">...</section>
      <section id="top-recommendation">...</section>
    </main>
  </body>
</html>
```

## 머리말

저장소 이름, 날짜, 간결한 범례: 실선 박스 = 모듈, 점선 = 경계, 빨간 화살표 = 새어나감, 굵은 어두운 박스 = 깊은 모듈. 서론 문단 없이 — 곧바로 후보로.

## 후보 카드

다이어그램이 무게를 지탱한다. 산문은 드물고, 평이한 한국어로 쓴다. [VOCABULARY.md](VOCABULARY.md)의 개념을 쓰되, 영어 전문용어를 라벨처럼 붙이지 마라.

각 후보는 하나의 `<article>`:

- **제목** — 짧고, 심화를 명명한다 (예: "주문 접수 파이프라인 접기").
- **배지 행** — 권고 강도(`추천` = 에메랄드, `검토` = 앰버, `불확실` = 슬레이트), 더해 의존성 분류 태그(`프로세스 안`, `로컬 대체`, `포트와 어댑터`, `모의`).
- **파일** — 모노스페이스 목록, `font-mono text-sm`.
- **전/후 다이어그램** — 핵심. 두 단, 나란히. 아래 패턴을 본다.
- **문제** — 한 문장. 무엇이 아픈가.
- **해결** — 한 문장. 무엇이 바뀌는가.
- **성과** — 불릿, 각각 ≤8 단어. 예: "테스트가 인터페이스 하나만 본다", "가격 로직 새어나감 멈춤", "얕은 전달 모듈 4개 삭제".
- **ADR 콜아웃** (해당 시) — 앰버 색조 박스에 한 줄.

설명 문단 없이. 다이어그램이 이해되려면 문단이 필요하다면, 다이어그램을 다시 그려라.

## 다이어그램 패턴

후보에 맞는 패턴을 고르라. 섞어라. 모든 다이어그램이 같아 보이게 만들지 마라 — 다양성이 요점이다.

코드 식별자(타입·파일 이름)는 그대로 두고, 개념 라벨(깊은 모듈, 경계, 구현)은 한국어로 써라.

### Mermaid 그래프 (의존성 / 호출 흐름의 일용품)

요점이 "X가 Y를, Y가 Z를 호출하고, 저 난장판을 봐라"일 때 Mermaid `flowchart` 또는 `graph`를 써라. Tailwind 스타일 카드로 감싸 갑자기 떨어진 느낌을 주지 마라. classDef로 새어나가는 간선을 빨간색, 깊은 모듈을 어둡게 칠하라. 시퀀스 다이어그램은 "전: 6번 왕복; 후: 1번"에 적합하다.

```html
<div class="rounded-lg border border-slate-200 bg-white p-4">
  <pre class="mermaid">
    flowchart LR
      A[OrderHandler] --> B[OrderValidator]
      B --> C[OrderRepo]
      C -.leak.-> D[PricingClient]
      classDef leak stroke:#dc2626,stroke-width:2px;
      class C,D leak
  </pre>
</div>
```

### 손으로 만든 박스와 화살표 (Mermaid 레이아웃이 거슬릴 때)

모듈은 테두리와 라벨이 있는 `<div>`. 화살표는 상대 컨테이너 위에 절대 배치한 인라인 SVG `<line>` 또는 `<path>`. "후" 다이어그램이 하나의 굵은 테두리 깊은 모듈에 회색 처리된 내부를 갖게 하고 싶을 때 써라 — Mermaid는 그 무게감을 제대로 렌더링하지 못한다.

### 단면도 (겹친 얕음에 적합)

호출이 지나는 계층을 보여주는 가로 밴드(`h-12 border-l-4`) 스택. 전: 아무것도 안 하는 얇은 계층 6개. 후: 통합된 책임으로 라벨된 두꺼운 밴드 1개.

### 매스 다이어그램 (인터페이스가 구현만큼 넓은 경우에 적합)

모듈마다 두 직사각형 — 하나는 인터페이스 표면적, 하나는 구현. 전: 인터페이스 직사각형이 구현 직사각형과 거의 같은 높이 (얕음). 후: 인터페이스 직사각형은 짧고, 구현 직사각형은 길다 (깊음).

### 호출 그래프 접기

전: 중첩 박스로 렌더링된 함수 호출 트리. 후: 같은 트리가 하나의 박스로 접히고, 이제 내부가 된 호출은 페이드되어 박스 안에 보인다.

## 스타일 안내

- 기업 대시보드가 아닌 편집적 느낌으로. 넉넉한 여백. 제목에 세리프 선택 가능 (`font-serif`는 stone/slate와 잘 어울린다).
- 색은 절제: 강조색 하나(에메랄드 또는 인디고)에 새어나감에는 빨강, 경고에는 앰버.
- 전/후가 스크롤 없이 편안하게 나란히 앉도록 다이어그램 높이를 ~320px로 유지.
- 다이어그램 안의 모듈 라벨은 한국어로, `text-xs tracking-wide` 정도면 된다. 영어 대문자 도면 라벨(`SEAM`, `MODULE`)을 쓰지 마라.
- 스크립트는 Tailwind CDN과 Mermaid ESM 임포트뿐. 보고서는 그 외에 정적이다 — 앱 코드 없음, Mermaid 자체 렌더링 외에 상호작용 없음.

## 최우선 권고 섹션

더 큰 카드 하나. 후보 이름, 이유 한 문장, 해당 카드로의 앵커 링크. 그것뿐.

## 어조

평이하고 간결한 한국어. 한국어 표현에는 CEFR B1 이하 어휘를 쓴다. 관용구, 비유, 문화에 따라 뜻이 달라지는 표현은 쓰지 않는다.

아키텍처 개념은 [VOCABULARY.md](VOCABULARY.md)를 따르되, 사용자 글에는 풀어써라.

**사용자 글에 쓰지 마라:** `seam`, `leverage`, `locality`, `depth`, `golden`, `deepening`.

**써도 되는 통용어:** 모듈, 인터페이스, 구현, 어댑터.

**스타일에 맞는 표현:**

- "주문 접수 모듈이 얕다 — 인터페이스가 구현과 거의 같다."
- "가격이 경계 너머로 새어나간다."
- "심화: 인터페이스 하나, 테스트할 곳 하나."
- "어댑터가 둘이면 경계를 둔다: 프로덕션은 HTTP, 테스트는 메모리."

**성과 불릿**은 쉬운 한국어로 이득을 말한다: *"버그가 한 모듈에 모인다"*, *"인터페이스 하나, 호출 지점 여러 개"*, *"인터페이스가 줄고 구현이 전달 모듈을 흡수한다"*. "고치기 쉬워짐"처럼 평이한 말도 된다. `locality:`, `leverage:` 같은 영어 머리말을 붙이지 마라.

헷징 없음, 서론 없음, "참고할 가치가 있는 것은…" 없음. 문장이 불릿이 될 수 있으면 불릿으로. 불릿이 잘리면 잘라라.
