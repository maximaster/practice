<?php

declare(strict_types=1);

namespace Recall\Http\Input;

use InvalidArgumentException;
use Recall\Domain\ValueObject\NoteIdList;
use Recall\Domain\ValueObject\TagList;
use Recall\Domain\ValueObject\Title;
use Recall\Http\ValidationException;

/** Разбор тела запроса для создания/изменения заметки. */
final readonly class NoteInput
{
    private const int MAX_BODY_LENGTH = 20000;

    public function __construct(
        public Title $title,
        public string $body,
        public TagList $tags,
        public NoteIdList $links,
    ) {}

    /** @param array<array-key, mixed> $data */
    public static function fromArray(array $data): self
    {
        $errors = [];
        $title = null;
        $links = null;

        try {
            $title = Title::fromString(self::str($data['title'] ?? ''));
        } catch (InvalidArgumentException $e) {
            $errors['title'] = $e->getMessage();
        }

        $body = self::str($data['body'] ?? '');
        if (mb_strlen($body) > self::MAX_BODY_LENGTH) {
            $errors['body'] = 'текст длиннее ' . self::MAX_BODY_LENGTH . ' символов';
        }

        try {
            $links = NoteIdList::fromStrings(self::list($data['links'] ?? []));
        } catch (InvalidArgumentException $e) {
            $errors['links'] = $e->getMessage();
        }

        if ($errors !== [] || $title === null || $links === null) {
            throw new ValidationException('проверьте поля заметки', $errors);
        }

        return new self($title, $body, TagList::fromStrings(self::list($data['tags'] ?? [])), $links);
    }

    private static function str(mixed $value): string
    {
        return is_scalar($value) ? (string) $value : '';
    }

    /** @return list<mixed> */
    private static function list(mixed $value): array
    {
        return is_array($value) ? array_values($value) : [];
    }
}
