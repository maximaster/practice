<?php

declare(strict_types=1);

namespace Recall\Domain\ValueObject;

use InvalidArgumentException;

/** Коэффициент лёгкости карточки (SM-2): не опускается ниже минимума. */
final readonly class Ease
{
    private const float MINIMUM = 1.3;
    private const float DEFAULT = 2.5;

    public function __construct(public float $value)
    {
        if ($value < self::MINIMUM) {
            throw new InvalidArgumentException('коэффициент лёгкости ниже минимума ' . self::MINIMUM);
        }
    }

    public static function default(): self
    {
        return new self(self::DEFAULT);
    }

    public function loweredBy(float $delta): self
    {
        return new self(max(self::MINIMUM, $this->value - $delta));
    }

    public function raisedBy(float $delta): self
    {
        return new self($this->value + $delta);
    }
}
