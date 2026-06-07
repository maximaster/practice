// Чистые помощники без DOM — их удобно покрыть юнит-тестами.

// Разобрать строку тегов «через запятую» в список без пустых значений.
export function parseTags(input: string): string[] {
  return input
    .split(",")
    .map((tag) => tag.trim())
    .filter((tag) => tag.length > 0);
}

// Подпись тегов рядом с заметкой.
export function tagLabel(tags: string[]): string {
  return tags.length > 0 ? ` [${tags.join(", ")}]` : "";
}
