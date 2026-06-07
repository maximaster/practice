<?php

declare(strict_types=1);

namespace Recall\Domain\ValueObject;

use InvalidArgumentException;

/** Тег в канонической форме: в нижнем регистре, без пробелов по краям, непустой. */
final readonly class Tag
{
    public function __construct(public string $value)
    {
        if ($value === '' || $value !== strtolower(trim($value))) {
            throw new InvalidArgumentException('тег должен быть непустым и в канонической форме');
        }
    }

    public static function fromString(string $raw): self
    {
        return new self(strtolower(trim($raw)));
    }

    public function equals(self $other): bool
    {
        return $this->value === $other->value;
    }
}
