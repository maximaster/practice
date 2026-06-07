<?php

declare(strict_types=1);

namespace Recall\Domain\ValueObject;

use DateTimeImmutable;
use Symfony\Component\Uid\TimeBasedUidInterface;
use Symfony\Component\Uid\Uuid;

/**
 * Идентификатор на UUIDv7. Версия 7 упорядочена по времени, поэтому хорошо
 * ложится в индекс и хранит момент создания — отдельное поле created_at не нужно.
 */
trait UuidIdentity
{
    public function __construct(public readonly Uuid $value) {}

    public static function generate(): self
    {
        return new self(Uuid::v7());
    }

    public static function fromString(string $id): self
    {
        return new self(Uuid::fromString($id));
    }

    public function toString(): string
    {
        return $this->value->toRfc4122();
    }

    public function __toString(): string
    {
        return $this->toString();
    }

    public function equals(self $other): bool
    {
        return $this->value->equals($other->value);
    }

    public function createdAt(): DateTimeImmutable
    {
        \assert($this->value instanceof TimeBasedUidInterface);

        return $this->value->getDateTime();
    }
}
