# 좋은 테스트와 나쁜 테스트

## 좋은 테스트

**통합 스타일**: 내부 부분의 모킹이 아니라 실제 인터페이스로 테스트한다.

```typescript
// 좋음: 관찰 가능한 행동을 테스트한다
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

특징:

- 사용자/호출자가 신경 쓰는 행동을 테스트
- 공개 API만 사용
- 내부 리팩터링을 견딤
- 어떻게 동작하는지가 아니라 무엇을 하는지를 기술
- 테스트마다 하나의 논리적 단언

## 나쁜 테스트

**구현 세부사항 테스트**: 내부 구조에 결합.

```typescript
// 나쁨: 구현 세부사항을 테스트한다
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

위험 신호:

- 내부 협력자 모킹
- private 메서드 테스트
- 호출 횟수/순서 단언
- 행동이 바뀌지 않은 리팩터링에 테스트가 깨짐
- 테스트 이름이 무엇을 하는지가 아니라 어떻게 동작하는지를 기술
- 인터페이스 대신 외부 수단으로 검증

```typescript
// 나쁨: 인터페이스를 우회해서 검증한다
test("createUser saves to database", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// 좋음: 인터페이스를 통해 검증한다
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```

**동어반복 테스트**: 기대값이 구현을 그대로 되풀이하여, 구조상 테스트가 통과한다.

```typescript
// 나쁨: 기대값을 코드가 계산하는 방식 그대로 다시 계산한다
test("calculateTotal sums line items", () => {
  const items = [{ price: 10 }, { price: 5 }];
  const expected = items.reduce((sum, i) => sum + i.price, 0);
  expect(calculateTotal(items)).toBe(expected);
});

// 좋음: 기대값이 독립적으로 알려진 리터럴이다
test("calculateTotal sums line items", () => {
  expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
});
```
