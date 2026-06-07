<?php

declare(strict_types=1);

namespace Recall\Http;

use BackedEnum;
use DateTimeImmutable;
use Recall\Domain\ValueObject\CardText;
use Recall\Domain\ValueObject\Day;
use Recall\Domain\ValueObject\Ease;
use Recall\Domain\ValueObject\Interval;
use Recall\Domain\ValueObject\NoteIdList;
use Recall\Domain\ValueObject\TagList;
use Recall\Domain\ValueObject\Title;
use ReflectionObject;
use ReflectionProperty;
use Stringable;

/**
 * Единая политика сериализации домена в JSON. Разворачивает value-объекты,
 * переводит имена свойств в snake_case и добавляет created_at из UUIDv7.
 * Домен об этом не знает.
 */
final class Serializer
{
    /** @return array<string, mixed> */
    public function serialize(object $entity): array
    {
        $out = [];
        foreach ((new ReflectionObject($entity))->getProperties(ReflectionProperty::IS_PUBLIC) as $property) {
            $out[$this->snake($property->getName())] = $this->unwrap($property->getValue($entity));
        }

        if (method_exists($entity, 'createdAt')) {
            $created = $entity->createdAt();
            if ($created instanceof DateTimeImmutable) {
                $out['created_at'] = $created->format(DateTimeImmutable::ATOM);
            }
        }

        return $out;
    }

    private function unwrap(mixed $value): mixed
    {
        return match (true) {
            $value instanceof BackedEnum => $value->value,
            $value instanceof DateTimeImmutable => $value->format(DateTimeImmutable::ATOM),
            $value instanceof Stringable => (string) $value,
            $value instanceof Title, $value instanceof CardText, $value instanceof Day => $value->value,
            $value instanceof Ease => $value->value,
            $value instanceof Interval => $value->days,
            $value instanceof TagList, $value instanceof NoteIdList => $value->toStrings(),
            default => $value,
        };
    }

    private function snake(string $name): string
    {
        return strtolower((string) preg_replace('/[A-Z]/', '_$0', $name));
    }
}
