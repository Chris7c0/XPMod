-- XPMod uses a MySQL database to store player data, bans, and survivor picks.
-- Below is the SQL code to create the necessary database, tables, views, stored procedures, and scheduled events for XPMod.

-- Example of how to add the mysql db to sourcemod database config file:
-- Place this at the bottom of the file located at .../left4dead2/addons/sourcemod/configs/databases.cfg
-- "xpmod"
-- {
--     "driver" "mysql"
--     "host" "127.0.0.1"
--     "database" "xpmod_db"
--     "user" "xpmod"
--     "pass" "mysql_usr_pw_here"
-- }

-- Create the database
CREATE DATABASE IF NOT EXISTS xpmod_db;

-- Users Table
CREATE TABLE users (
    user_id int UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    user_name varchar(32) NOT NULL,
    steam_id BIGINT UNSIGNED UNIQUE NOT NULL,
    token varchar(40) DEFAULT "" NOT NULL,
    first_login TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    xp INT UNSIGNED DEFAULT 0 NOT NULL,
    survivor_id TINYINT UNSIGNED DEFAULT 0 NOT NULL,
    infected_id_1 TINYINT UNSIGNED DEFAULT 0 NOT NULL,
    infected_id_2 TINYINT UNSIGNED DEFAULT 0 NOT NULL,
    infected_id_3 TINYINT UNSIGNED DEFAULT 0 NOT NULL,
    equipment_primary TINYINT UNSIGNED DEFAULT 0 NOT NULL,
    equipment_secondary TINYINT UNSIGNED DEFAULT 0 NOT NULL,
    equipment_explosive TINYINT UNSIGNED DEFAULT 0 NOT NULL,
    equipment_health TINYINT UNSIGNED DEFAULT 0 NOT NULL,
    equipment_boost TINYINT UNSIGNED DEFAULT 0 NOT NULL,
    equipment_laser BOOLEAN DEFAULT 0 NOT NULL,
    option_announcer BOOLEAN DEFAULT 0 NOT NULL,
    option_display_xp BOOLEAN DEFAULT 0 NOT NULL,
    option_auto_confirm BOOLEAN DEFAULT 0 NOT NULL,
    prestige_points INT UNSIGNED DEFAULT 0 NOT NULL,
    push_update_from_db BOOLEAN DEFAULT 0 NOT NULL
);

-- Bans Table
CREATE TABLE bans (
    user_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    user_name VARCHAR(32) NOT NULL,
    steam_id BIGINT UNSIGNED UNIQUE NOT NULL,
    ban_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expiration_time DATETIME,
    reason VARCHAR(100),
    admin_user_name VARCHAR(32) NOT NULL DEFAULT '',
    admin_steam_id BIGINT UNSIGNED NOT NULL DEFAULT 0
);

-- Survivor Picks Table
CREATE TABLE survivor_picks (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    steam_id BIGINT UNSIGNED NOT NULL,
    survivor_id TINYINT UNSIGNED NOT NULL,
    picked_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_steam_date (steam_id, picked_at),
    INDEX idx_date_survivor (picked_at, survivor_id)
);

-- Views
CREATE OR REPLACE VIEW top10 AS
SELECT user_name, xp, steam_id FROM users ORDER BY xp DESC LIMIT 10;

-- Scheduled Events (Jobs)
SET GLOBAL event_scheduler = ON;

-- Create the stored procedure to remove bans that have expired
DELIMITER //
CREATE PROCEDURE RemoveExpiredBans()
BEGIN
DELETE FROM xpmod_db.bans WHERE expiration_time < NOW();
END //
DELIMITER ;

-- Event to remove_expired_bans;
CREATE EVENT remove_expired_bans
ON SCHEDULE EVERY 1 DAY
STARTS '2021-03-08 03:00:00'
DO
CALL xpmod_db.RemoveExpiredBans();

-- Prestige Points
-- DROP PROCEDURE IF EXISTS GivePlayersPrestigePointsAndResetXP;
DELIMITER ;;
CREATE PROCEDURE GivePlayersPrestigePointsAndResetXP()
BEGIN
  DECLARE done INT;
  DECLARE curs_user_id INT;
  DECLARE curs_xp INT;
  DECLARE curs_prestige_points INT;
  DECLARE top_player_bonus_points INT;
  DECLARE new_prestige_points INT;
  DECLARE xp_reset_amount INT;
  
  DECLARE curs CURSOR FOR SELECT user_id, xp, prestige_points FROM users ORDER BY xp DESC;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  
  OPEN curs;
  
  -- This sets the top X players that will get bonus points
  -- It decrements by 1 each time a point is given
  SET top_player_bonus_points = 5;
  SET xp_reset_amount = 1000000;
  
  SET done = 0;
  loop_through_rows: REPEAT
    FETCH curs INTO curs_user_id, curs_xp, curs_prestige_points;
    
    -- Exit if the next users aren't above the xp reset amount
    IF curs_xp <= xp_reset_amount THEN
      LEAVE loop_through_rows;
    END IF;
    
    -- Calculate the new points to set for this player
    Set new_prestige_points = curs_prestige_points + 1 + top_player_bonus_points;
	-- Cap it at 999 Prestige Points
    IF new_prestige_points > 999 THEN
      Set new_prestige_points = 999;
    END IF;
    
    -- Update the points for the user
    -- Give 1 point to everyone who participated
    -- Give bonus points for the top X players, decrementing by 1 each time a point is given
    -- Also reset XP for this player
    UPDATE users
    SET users.prestige_points = new_prestige_points, users.xp = xp_reset_amount, users.push_update_from_db = 1
	WHERE users.user_id = curs_user_id;
    
	-- Decrement bonus points by 1 if we are still in the top x
    IF top_player_bonus_points > 0 THEN
      Set top_player_bonus_points = top_player_bonus_points - 1;
    END IF;
  UNTIL done END REPEAT;
  
  CLOSE curs;
END

-- Event to give players prestige points and reset XP every month
CREATE EVENT monthly_prestige_reset_xp
ON SCHEDULE
    EVERY 1 MONTH
    STARTS CONCAT(DATE_FORMAT(CURRENT_DATE(), '%Y-%m-01'), ' 04:00:00')
DO
    CALL GivePlayersPrestigePointsAndResetXP();