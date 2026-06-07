<?php

declare(strict_types=1);

namespace Recall\Domain\ValueObject;

use InvalidArgumentException;

/** Заголовок заметки: непустая строка ограниченной длины. */
final readonly class Title
{
    private const int MAX_LENGTH = 200;

    public function __construct(public string $value)
    {
        if (trim($value) === '') {
            throw new InvalidArgumentException('заголовок не может быть пустым');
        }
        if (mb_strlen($value) > self::MAX_LENGTH) {
            throw new InvalidArgumentException('заголовок длиннее ' . self::MAX_LENGTH . ' символов');
        }
    }

    public static function fromString(string $value): self
    {
        return new self(trim($value));
    }
}
