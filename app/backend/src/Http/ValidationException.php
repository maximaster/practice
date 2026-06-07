<?php

declare(strict_types=1);

namespace Recall\Http;

use InvalidArgumentException;

/** Ошибка валидации входных данных: несёт привязку сообщений к полям. */
final class ValidationException extends InvalidArgumentException
{
    /** @param array<string, string> $details */
    public function __construct(string $message, private readonly array $details = [])
    {
        parent::__construct($message);
    }

    /** @return array<string, string> */
    public function details(): array
    {
        return $this->details;
    }
}
