# 언제 모킹할까

시스템 경계에서만 모킹한다:

- 외부 API(결제, 이메일 등)
- 데이터베이스(때로는 테스트 DB를 선호)
- 시간/무작위
- 파일 시스템(때로는)

모킹하지 않는 것:

- 자기가 만든 클래스/모듈
- 내부 협력자
- 제어할 수 있는 모든 것

## 모킹 가능성을 위한 설계

시스템 경계에서 모킹하기 쉬운 인터페이스를 설계한다:

**1. 의존성 주입을 사용한다**

외부 의존성을 내부에서 만들지 말고 전달한다:

```typescript
// 모킹하기 쉬움
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}

// 모킹하기 어려움
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

**2. 범용 fetch 헬퍼보다 SDK 형태의 인터페이스를 선호한다**

조건부 로직이 있는 하나의 범용 함수 대신, 각 외부 작업마다 특정 함수를 만든다:

```typescript
// 좋음: 각 함수가 독립적으로 모킹 가능
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
};

// 나쁨: 모킹에 조건부 로직이 필요
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

SDK 방식의 의미:
- 각 모킹이 하나의 특정 형태를 반환
- 테스트 설정에 조건부 로직이 없음
- 어떤 엔드포인트를 테스트가 사용하는지 더 쉽게 파악
- 엔드포인트별 타입 안전성
