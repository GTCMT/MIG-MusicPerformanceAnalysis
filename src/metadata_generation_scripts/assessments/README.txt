README

These scripts generate the <student_id>_assessments.txt files. To use them, run:
-ParseMiddleSchoolStudentAssessments to generate the files for the Middle 
 School Band.
-ParseHighSchoolStudentAssessments to generate the files for the High School
 Band.

A few notes:
-Reading Timpani assessments are present in the data, but there was no sight-
 reading timpani part of auditions for any students. The script will output
 some warnings about not finding this data--don't worry about those messages.
-The Scales Articulation & Style assessment is only used in Middle School
 Piccolo auditions.

An easy to read description at the assessments.txt format:
Rows (10 segments):
1. lyricalEtude
2. technicalEtude
3. scalesChromatic
4. scalesMajor
5. sightReading
6. malletEtude
7. snareEtude
8. timpaniEtude
9. readingMallet
10. readingSnare

Columns (26 categories):
1. articulation
2. artistry
3. musicalityTempoStyle
4. noteAccuracy
5. rhythmicAccuracy
6. toneQuality
7. articulationStyle
8. musicalityPhrasingStyle
9. noteAccuracyConsistency
10. tempoConsistency
11. Ab
12. A
13. Bb
14. B
15. C
16. Db
17. D
18. Eb
19. E
20. F
21. Gb
22. G
23. chromatic
24. musicalityStyle
25. noteAccuracyTone
26. rhythmicAccuracyArticulation