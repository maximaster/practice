<?php

declare(strict_types=1);

namespace Recall\Domain\ValueObject;

use Stringable;

/** Идентификатор повторения. */
final readonly class ReviewId implements Stringable
{
    use UuidIdentity;
}
