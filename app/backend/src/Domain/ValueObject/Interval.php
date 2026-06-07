<?php

declare(strict_types=1);

namespace Recall\Domain\ValueObject;

use InvalidArgumentException;

/** Интервал повторения в днях: неотрицательный. */
final readonly class Interval
{
    public function __construct(public int $days)
    {
        if ($days < 0) {
            throw new InvalidArgumentException('интервал не может быть отрицательным');
        }
    }

    public static function none(): self
    {
        return new self(0);
    }

    public static function ofDays(int $days): self
    {
        return new self($days);
    }

    public function isNone(): bool
    {
        return $this->days === 0;
    }

    public function scaledBy(float $factor): self
    {
        return new self((int) round($this->days * $factor));
    }

    public function atLeast(int $days): self
    {
        return new self(max($this->days, $days));
    }
}
