<?php

declare(strict_types=1);

namespace Recall\Domain\ValueObject;

/** Набор тегов без повторов. */
final readonly class TagList
{
    /** @var list<Tag> */
    public array $tags;

    public function __construct(Tag ...$tags)
    {
        $unique = [];
        foreach ($tags as $tag) {
            foreach ($unique as $existing) {
                if ($existing->equals($tag)) {
                    continue 2;
                }
            }
            $unique[] = $tag;
        }
        $this->tags = $unique;
    }

    /** @param iterable<mixed> $raw */
    public static function fromStrings(iterable $raw): self
    {
        $tags = [];
        foreach ($raw as $value) {
            if (!is_scalar($value)) {
                continue;
            }
            $normalized = strtolower(trim((string) $value));
            if ($normalized !== '') {
                $tags[] = new Tag($normalized);
            }
        }

        return new self(...$tags);
    }

    public function contains(Tag $tag): bool
    {
        return array_any($this->tags, fn($existing) => $existing->equals($tag));
    }

    /** @return list<string> */
    public function toStrings(): array
    {
        return array_map(static fn(Tag $tag): string => $tag->value, $this->tags);
    }
}
