<?php

declare(strict_types=1);

namespace Recall\Domain;

/** Оценка вспоминания карточки. */
enum Grade: string
{
    case Again = 'again';
    case Hard = 'hard';
    case Good = 'good';
    case Easy = 'easy';

    /** @return list<string> */
    public static function values(): array
    {
        return array_map(static fn(self $grade): string => $grade->value, self::cases());
    }
}
