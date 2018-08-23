USE `essentialmode`;

CREATE TABLE `jsfour_incidents` (
	`pk` INT NOT NULL,
	`number` VARCHAR(255) NULL,
	`text` VARCHAR(255) NULL,
	`uploader` VARCHAR(255) NULL,
	`date` VARCHAR(255) NULL,
	PRIMARY KEY (`pk`));
);

CREATE TABLE `jsfour_carinspection` (
	`pk` INT NOT NULL,
	`plate` VARCHAR(255) NULL,
	`owner` VARCHAR(255) NULL,
	`incident` VARCHAR(255) NULL,
	`inspected` VARCHAR(255) NULL,
	PRIMARY KEY (`pk`));
);

CREATE TABLE `jsfour_logs` (
	`pk` int(11) NOT NULL AUTO_INCREMENT,
	`type` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
	`remover` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
	`wanted` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
	PRIMARY KEY (`pk`);
);

CREATE TABLE `jsfour_efterlysningar` (
	`pk` INT NOT NULL,
	`wanted` VARCHAR(255) NULL,
	`dob` VARCHAR(255) NULL,
	`crime` VARCHAR(255) NULL,
	`uploader` VARCHAR(255) NULL,
	`date` VARCHAR(255) NULL,
	`incident` VARCHAR(255) NULL,
	PRIMARY KEY (`pk`)
);