<?php
// Classic theme configuration template
defined('MOODLE_INTERNAL') || die();

$THEME->name = 'classic';
$THEME->parents = ['boost'];
$THEME->sheets = ['classic'];

$THEME->layouts = [
    'base' => [
        'file' => 'columns.php',
        'regions' => ['side-pre'],
        'defaultregion' => 'side-pre',
    ],
];
