<?php

declare(strict_types=1);

namespace Recall\Domain\ValueObject;

use Stringable;

/** Идентификатор заметки. */
final readonly class NoteId implements Stringable
{
    use UuidIdentity;
}
