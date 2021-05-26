-- noinspection SpellCheckingInspectionForFile

SELECT groups.name, count(rgs.student_id)
FROM groups
         LEFT JOIN relation_group_student rgs ON groups.id = rgs.group_id
GROUP BY groups.name;

SELECT teachers.name, count(rtg.group_id)
FROM teachers
         LEFT JOIN relation_teaher_group rtg ON teachers.id = rtg.teacher_id
GROUP BY teachers.name;

SELECT groups.name, count(rtg.teacher_id)
FROM groups
         LEFT JOIN relation_teaher_group rtg ON groups.id = rtg.group_id
GROUP BY groups.name;


SELECT students.id, students.name, groups.name, count(rtg.teacher_id)
FROM groups
         JOIN relation_group_student rgs ON groups.id = rgs.group_id
         JOIN relation_teaher_group rtg ON groups.id = rtg.group_id
         JOIN students ON students.id = rgs.student_id
GROUP BY students.id, students.name, groups.name, rgs.student_id;

