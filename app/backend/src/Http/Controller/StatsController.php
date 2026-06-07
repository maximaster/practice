<?php

declare(strict_types=1);

namespace Recall\Http\Controller;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Recall\Domain\Stats;
use Recall\Http\Json;
use Recall\Http\Serializer;
use Recall\Infrastructure\Persistence\CardRepository;

final readonly class StatsController
{
    public function __construct(
        private CardRepository $cards,
        private Serializer $serializer,
    ) {}

    public function index(Request $request, Response $response): Response
    {
        $total = $this->cards->count();

        // TODO: заглушка. Считает все карточки как «на сегодня» и «за неделю»,
        // игнорируя даты, а серию всегда отдаёт нулём. Определите настоящие
        // правила: сколько повторить сегодня, сколько за неделю и как считать
        // серию дней.
        $stats = new Stats(dueToday: $total, dueWeek: $total, streak: 0);

        return Json::write($response, $this->serializer->serialize($stats));
    }
}
