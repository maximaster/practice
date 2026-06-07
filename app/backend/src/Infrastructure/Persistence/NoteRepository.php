<?php

declare(strict_types=1);

namespace Recall\Infrastructure\Persistence;

use Cycle\ORM\EntityManager;
use Cycle\ORM\ORMInterface;
use Cycle\ORM\Select;
use Recall\Domain\Note;
use Recall\Domain\ValueObject\NoteId;
use Recall\Domain\ValueObject\Tag;

/** Доступ к заметкам через Cycle ORM. */
final readonly class NoteRepository
{
    public function __construct(private ORMInterface $orm) {}

    /** @return list<Note> */
    public function all(?Tag $tag): array
    {
        $notes = [];
        foreach ((new Select($this->orm, Note::class))->orderBy('id')->fetchAll() as $note) {
            if ($note instanceof Note && ($tag === null || $note->tags->contains($tag))) {
                $notes[] = $note;
            }
        }

        return $notes;
    }

    public function find(NoteId $id): ?Note
    {
        foreach ((new Select($this->orm, Note::class))->where('id', $id->toString())->fetchAll() as $note) {
            if ($note instanceof Note) {
                return $note;
            }
        }

        return null;
    }

    public function save(Note $note): void
    {
        (new EntityManager($this->orm))->persist($note)->run();
    }

    public function delete(Note $note): void
    {
        (new EntityManager($this->orm))->delete($note)->run();
    }
}
