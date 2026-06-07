<?php

declare(strict_types=1);

namespace Recall\Domain;

/** Статистика повторений для дашборда. */
final readonly class Stats
{
    public function __construct(
        public int $dueToday,
        public int $dueWeek,
        public int $streak,
    ) {}
}
