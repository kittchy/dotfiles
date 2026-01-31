#!/usr/bin/env perl

#$latex            = 'uplatex -shell-escape -kanji=utf8 -synctex=1 -halt-on-error -interaction=nonstopmode -file-line-error %O %S';
#$latex_silent     = 'uplatex -shell-escape -kanji=utf8 -synctex=1 -halt-on-error -interaction=batchmode %O %S';

$latex            = 'platex -shell-escape -kanji=utf8 -synctex=1 -halt-on-error -interaction=nonstopmode -file-line-error %O %S';
$latex_silent     = 'platex -shell-escape -kanji=utf8 -synctex=1 -halt-on-error -interaction=batchmode %O %S';

$bibtex           = 'pbibtex %O %S';
$biber            = 'biber --bblencoding=utf8 -u -U --output_safechars';
$dvipdf           = 'dvipdfmx %O -o %D %S';
$makeindex        = 'mendex %O -o %D %S';
$max_repeat       = 5;
$pdf_mode         = 3;
$pvc_view_file_via_temporary = 0;

# clean up
$clean_full_ext = "%R.synctex.gz"
