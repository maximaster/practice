<?php

declare(strict_types=1);

namespace Recall\Domain\ValueObject;

use InvalidArgumentException;

/** Сторона карточки (вопрос или ответ): непустой текст ограниченной длины. */
final readonly class CardText
{
    private const int MAX_LENGTH = 4000;

    public function __construct(public string $value)
    {
        if (trim($value) === '') {
            throw new InvalidArgumentException('сторона карточки не может быть пустой');
        }
        if (mb_strlen($value) > self::MAX_LENGTH) {
            throw new InvalidArgumentException('сторона карточки длиннее ' . self::MAX_LENGTH . ' символов');
        }
    }

    public static function fromString(string $value): self
    {
        return new self(trim($value));
    }
}
