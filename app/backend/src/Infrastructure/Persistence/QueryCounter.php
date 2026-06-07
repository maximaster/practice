<?php

declare(strict_types=1);

namespace Recall\Infrastructure\Persistence;

use Psr\Log\AbstractLogger;
use Stringable;

/**
 * Считает запросы к БД (Cycle логирует каждый запрос сюда). Не гейтит сборку —
 * число запросов отдаётся в заголовке, чтобы видеть, кто оптимизировал лучше.
 */
final class QueryCounter extends AbstractLogger
{
    private int $count = 0;

    /** @param array<array-key, mixed> $context */
    public function log(mixed $level, string|Stringable $message, array $context = []): void
    {
        ++$this->count;
    }

    public function count(): int
    {
        return $this->count;
    }
}
