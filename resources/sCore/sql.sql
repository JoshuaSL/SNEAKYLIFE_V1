SET @job_name = 'jashari';
SET @society_name = 'society_jashari';
SET @job_Label = "Mafia Jashari";

INSERT INTO `addon_account` (name, label, shared) VALUES
	(@society_name, @job_Label, 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	(@society_name, @job_Label, 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	(@society_name, @job_Label, 1)
;


INSERT INTO `jobs` (name, label) VALUES
	(@job_name, @job_Label)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
(@job_name,0,'nouveaux','Nouveaux',55,'{}','{}'),
(@job_name,1,'homme_de_mains','Homme de main',60,'{}','{}'),
(@job_name,2,'gestionnaire','Gestionnaire',65,'{}','{}'),
(@job_name,3,'caporal','Caporal',65,'{}','{}'),
(@job_name,4,'bras_droit','Bras droit',65,'{}','{}'),
(@job_name,5,'boss','Parrain',95,'{}','{}')
;