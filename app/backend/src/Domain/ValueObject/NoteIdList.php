<?php

declare(strict_types=1);

namespace Recall\Domain\ValueObject;

/** Ссылки заметки на другие заметки. */
final readonly class NoteIdList
{
    /** @var list<NoteId> */
    public array $ids;

    public function __construct(NoteId ...$ids)
    {
        $this->ids = array_values($ids);
    }

    /** @param iterable<mixed> $raw */
    public static function fromStrings(iterable $raw): self
    {
        $ids = [];
        foreach ($raw as $value) {
            if (is_string($value) && $value !== '') {
                $ids[] = NoteId::fromString($value);
            }
        }

        return new self(...$ids);
    }

    /** @return list<string> */
    public function toStrings(): array
    {
        return array_map(static fn(NoteId $id): string => $id->toString(), $this->ids);
    }
}
