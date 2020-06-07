@echo off
set  lreleasePath=C:\Qt\Qt5.12.3\5.12.3\msvc2017_64\bin\lrelease
set transPath=../../bin/trans/
%lreleasePath% trans_en.ts -qm %transPath%trans_en.qm
%lreleasePath% trans_zh.ts -qm %transPath%trans_zh.qm
%lreleasePath% trans_ja.ts -qm %transPath%trans_ja.qm
%lreleasePath% trans_ko.ts -qm %transPath%trans_ko.qm
%lreleasePath% trans_fr.ts -qm %transPath%trans_fr.qm
%lreleasePath% trans_es.ts -qm %transPath%trans_es.qm
%lreleasePath% trans_pt.ts -qm %transPath%trans_pt.qm
%lreleasePath% trans_it.ts -qm %transPath%trans_it.qm
%lreleasePath% trans_ru.ts -qm %transPath%trans_ru.qm
%lreleasePath% trans_vi.ts -qm %transPath%trans_vi.qm
%lreleasePath% trans_de.ts -qm %transPath%trans_de.qm
%lreleasePath% trans_ar.ts -qm %transPath%trans_ar.qm
pause