<?php

declare(strict_types=1);

namespace Recall\Infrastructure\Persistence;

use Cycle\ORM\EntityManager;
use Cycle\ORM\ORMInterface;
use Recall\Domain\Review;

/** Доступ к повторениям через Cycle ORM. */
final readonly class ReviewRepository
{
    public function __construct(private ORMInterface $orm) {}

    public function save(Review $review): void
    {
        (new EntityManager($this->orm))->persist($review)->run();
    }
}
