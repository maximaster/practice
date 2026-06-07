<?php

declare(strict_types=1);

namespace Recall\Tests;

use DateTimeImmutable;
use Recall\Domain\Card;
use Recall\Domain\Grade;
use Recall\Domain\ValueObject\CardText;
use Recall\Domain\ValueObject\NoteId;
use Testo\Assert;
use Testo\Test;

/**
 * Поведение домена без БД: пересчёт расписания при оценке карточки.
 *
 * Запуск: vendor/bin/testo  (или: just test)
 */
final class CardGradeTest
{
    #[Test]
    public function gradingGoodMovesAFreshCardOneDayForward(): void
    {
        $now = new DateTimeImmutable('2026-06-06');
        $card = $this->freshCard($now);

        $review = $card->grade(Grade::Good, $now);

        Assert::same($card->interval->days, 1);
        Assert::same($card->due->value, '2026-06-07');
        Assert::same($review->grade, Grade::Good);
    }

    #[Test]
    public function gradingAgainResetsIntervalAndLowersEase(): void
    {
        $now = new DateTimeImmutable('2026-06-06');
        $card = $this->freshCard($now);

        $card->grade(Grade::Good, $now);
        $card->grade(Grade::Again, $now);

        Assert::same($card->interval->days, 0);
        Assert::true($card->ease->value < 2.5);
    }

    private function freshCard(DateTimeImmutable $now): Card
    {
        return Card::create(NoteId::generate(), CardText::fromString('Q'), CardText::fromString('A'), $now);
    }
}
