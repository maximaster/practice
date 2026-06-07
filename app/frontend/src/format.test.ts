import { describe, expect, it } from "vitest";
import { parseTags, tagLabel } from "./format";

describe("parseTags", () => {
  it("разбивает по запятой, обрезает пробелы и выкидывает пустые", () => {
    expect(parseTags("a, b ,, c ")).toEqual(["a", "b", "c"]);
  });

  it("на пустой строке возвращает пустой список", () => {
    expect(parseTags("   ")).toEqual([]);
  });
});

describe("tagLabel", () => {
  it("оборачивает теги в скобки", () => {
    expect(tagLabel(["x", "y"])).toBe(" [x, y]");
  });

  it("для пустого списка возвращает пустую строку", () => {
    expect(tagLabel([])).toBe("");
  });
});
