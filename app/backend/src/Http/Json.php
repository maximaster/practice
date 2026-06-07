<?php

declare(strict_types=1);

namespace Recall\Http;

use Psr\Http\Message\ResponseInterface;

/** Хелпер для JSON-ответов поверх PSR-7. */
final class Json
{
    public static function write(ResponseInterface $response, mixed $data, int $status = 200): ResponseInterface
    {
        $response->getBody()->write(
            json_encode($data, JSON_THROW_ON_ERROR | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES),
        );

        return $response->withHeader('Content-Type', 'application/json')->withStatus($status);
    }

    /** @param array<string, string> $details */
    public static function error(ResponseInterface $response, string $message, int $status, array $details = []): ResponseInterface
    {
        $payload = ['error' => $message];
        if ($details !== []) {
            $payload['details'] = $details;
        }

        return self::write($response, $payload, $status);
    }
}
