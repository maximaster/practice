<?php

declare(strict_types=1);

use Rector\CodeQuality\Rector\Identical\FlipTypeControlToUseExclusiveTypeRector;
use Rector\Config\RectorConfig;
use Rector\DeadCode\Rector\ClassMethod\RemoveUnusedPublicMethodParameterRector;
use Rector\Php84\Rector\MethodCall\NewMethodCallWithoutParenthesesRector;

return RectorConfig::configure()
    ->withPaths([
        __DIR__ . '/src',
        __DIR__ . '/public',
        __DIR__ . '/tests',
    ])
    ->withPhpSets()
    ->withPreparedSets(
        deadCode: true,
        codeQuality: true,
        typeDeclarations: true,
        earlyReturn: true,
    )
    ->withSkip([
        // PHP 8.4 parens-less `new` is unparseable by PHPMD's pdepend; keep parentheses.
        NewMethodCallWithoutParenthesesRector::class,
        // `if ($x === null)` reads better than `if (!$x instanceof Type)` here.
        FlipTypeControlToUseExclusiveTypeRector::class,
        // Controller actions keep a uniform (Request, int) signature even when
        // an action ignores the request; do not strip the parameter.
        RemoveUnusedPublicMethodParameterRector::class,
    ])
    ->withImportNames(importShortClasses: false);
