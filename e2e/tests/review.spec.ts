import { test, expect } from "@playwright/test";

test("grading a due card removes it from the queue", async ({ page }) => {
  await page.goto("/");

  const cards = page.locator("[data-testid='queue-card']");
  await expect(cards.first()).toBeVisible();

  const firstId = await cards.first().getAttribute("data-id");
  const before = await cards.count();

  await page.locator("[data-testid='queue-card']").first()
    .locator("[data-testid='grade-good']")
    .click();

  // The graded card is rescheduled into the future, so it leaves today's queue.
  await expect(
    page.locator(`[data-testid='queue-card'][data-id='${firstId}']`),
  ).toHaveCount(0);

  const after = await page.locator("[data-testid='queue-card']").count();
  expect(after).toBeLessThan(before);
});
