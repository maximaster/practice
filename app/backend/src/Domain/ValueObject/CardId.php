<?php

declare(strict_types=1);

namespace Recall\Domain\ValueObject;

use Stringable;

/** Идентификатор карточки. */
final readonly class CardId implements Stringable
{
    use UuidIdentity;
}
