<?php
// Modern theme configuration template
defined('MOODLE_INTERNAL') || die();

$THEME->name = 'modern';
$THEME->parents = ['boost'];
$THEME->sheets = ['modern'];

$THEME->layouts = [
    'base' => [
        'file' => 'columns.php',
        'regions' => ['side-pre'],
        'defaultregion' => 'side-pre',
    ],
];
