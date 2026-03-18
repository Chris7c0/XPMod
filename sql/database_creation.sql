-- XPMod uses a MySQL database to store player data, bans, and class picks.
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

-- Survivor Class Names Lookup Table
CREATE TABLE survivor_classes (
    class_id TINYINT UNSIGNED PRIMARY KEY,
    class_name VARCHAR(20) NOT NULL
);
INSERT INTO survivor_classes (class_id, class_name) VALUES
    (0, 'Bill'),
    (1, 'Rochelle'),
    (2, 'Coach'),
    (3, 'Ellis'),
    (4, 'Nick'),
    (5, 'Louis'),
    (6, 'Zoey'),
    (7, 'Francis');

-- Infected Class Names Lookup Table
CREATE TABLE infected_classes (
    class_id TINYINT UNSIGNED PRIMARY KEY,
    class_name VARCHAR(20) NOT NULL
);
INSERT INTO infected_classes (class_id, class_name) VALUES
    (1, 'Smoker'),
    (2, 'Boomer'),
    (3, 'Hunter'),
    (4, 'Spitter'),
    (5, 'Jockey'),
    (6, 'Charger'),
    (7, 'Witch'),
    (8, 'Tank');

-- Tank Class Names Lookup Table
CREATE TABLE tank_classes (
    class_id TINYINT UNSIGNED PRIMARY KEY,
    class_name VARCHAR(20) NOT NULL
);
INSERT INTO tank_classes (class_id, class_name) VALUES
    (0, 'Not Chosen'),
    (1, 'Fire Tank'),
    (2, 'Ice Tank'),
    (3, 'NecroTanker'),
    (4, 'Vampiric Tank');

-- Survivor Picks Table
CREATE TABLE survivor_stats (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    steam_id BIGINT UNSIGNED NOT NULL,
    survivor_id TINYINT UNSIGNED NOT NULL,
    server_name VARCHAR(64) NOT NULL,
    game_mode VARCHAR(20) NOT NULL,
    map_name VARCHAR(32) NOT NULL,
    picked_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    si_kills INT UNSIGNED NOT NULL DEFAULT 0,
    ci_kills INT UNSIGNED NOT NULL DEFAULT 0,
    headshots INT UNSIGNED NOT NULL DEFAULT 0,
    damage_taken INT UNSIGNED NOT NULL DEFAULT 0,
    friendly_fire_damage INT UNSIGNED NOT NULL DEFAULT 0,
    time_played INT UNSIGNED NOT NULL DEFAULT 0,
    round_win BOOLEAN DEFAULT NULL,
    INDEX idx_steam_date (steam_id, picked_at),
    INDEX idx_date_survivor (picked_at, survivor_id)
);

-- Infected Stats Table
CREATE TABLE infected_stats (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    steam_id BIGINT UNSIGNED NOT NULL,
    infected_id_1 TINYINT UNSIGNED NOT NULL,
    infected_id_2 TINYINT UNSIGNED NOT NULL,
    infected_id_3 TINYINT UNSIGNED NOT NULL,
    tank_chosen TINYINT UNSIGNED DEFAULT NULL,
    server_name VARCHAR(64) NOT NULL,
    game_mode VARCHAR(20) NOT NULL,
    map_name VARCHAR(32) NOT NULL,
    picked_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    survivor_kills INT UNSIGNED NOT NULL DEFAULT 0,
    survivor_incaps INT UNSIGNED NOT NULL DEFAULT 0,
    damage_smoker INT UNSIGNED NOT NULL DEFAULT 0,
    damage_boomer INT UNSIGNED NOT NULL DEFAULT 0,
    damage_hunter INT UNSIGNED NOT NULL DEFAULT 0,
    damage_spitter INT UNSIGNED NOT NULL DEFAULT 0,
    damage_jockey INT UNSIGNED NOT NULL DEFAULT 0,
    damage_charger INT UNSIGNED NOT NULL DEFAULT 0,
    damage_tank INT UNSIGNED NOT NULL DEFAULT 0,
    damage_taken INT UNSIGNED NOT NULL DEFAULT 0,
    time_played INT UNSIGNED NOT NULL DEFAULT 0,
    round_win BOOLEAN DEFAULT NULL,
    INDEX idx_steam_date (steam_id, picked_at)
);

-- Views

CREATE OR REPLACE VIEW survivor_stats_view AS
SELECT sp.id, sp.steam_id, u.user_name, u.xp, u.prestige_points, sc.class_name AS survivor_name,
    sp.server_name, sp.game_mode, sp.map_name, sp.picked_at,
    sp.si_kills, sp.ci_kills, sp.headshots, sp.damage_taken, sp.friendly_fire_damage, sp.time_played, sp.round_win
FROM survivor_stats sp
JOIN users u ON sp.steam_id = u.steam_id
JOIN survivor_classes sc ON sp.survivor_id = sc.class_id;

CREATE OR REPLACE VIEW infected_stats_view AS
SELECT ist.id, ist.steam_id, u.user_name, u.xp, u.prestige_points,
    ic1.class_name AS infected_name_1, ic2.class_name AS infected_name_2, ic3.class_name AS infected_name_3,
    tc.class_name AS tank_name,
    ist.server_name, ist.game_mode, ist.map_name, ist.picked_at,
    ist.survivor_kills, ist.survivor_incaps,
    ist.damage_smoker, ist.damage_boomer, ist.damage_hunter,
    ist.damage_spitter, ist.damage_jockey, ist.damage_charger, ist.damage_tank,
    ist.damage_smoker + ist.damage_boomer + ist.damage_hunter + ist.damage_spitter + ist.damage_jockey + ist.damage_charger + ist.damage_tank AS damage_to_survivors,
    ist.damage_taken, ist.time_played, ist.round_win
FROM infected_stats ist
JOIN users u ON ist.steam_id = u.steam_id
JOIN infected_classes ic1 ON ist.infected_id_1 = ic1.class_id
JOIN infected_classes ic2 ON ist.infected_id_2 = ic2.class_id
JOIN infected_classes ic3 ON ist.infected_id_3 = ic3.class_id
LEFT JOIN tank_classes tc ON ist.tank_chosen = tc.class_id;

CREATE OR REPLACE VIEW survivor_stats_averages AS
SELECT ss.steam_id, u.user_name, sc.class_name AS survivor_name,
    COUNT(*) AS rounds_played,
    ROUND(AVG(ss.si_kills), 1) AS avg_si_kills,
    ROUND(AVG(ss.ci_kills), 1) AS avg_ci_kills,
    ROUND(AVG(ss.headshots), 1) AS avg_headshots,
    ROUND(AVG(ss.damage_taken), 1) AS avg_damage_taken,
    ROUND(AVG(ss.friendly_fire_damage), 1) AS avg_friendly_fire_damage,
    ROUND(AVG(ss.time_played), 0) AS avg_time_played,
    SUM(ss.round_win = 1) AS wins,
    SUM(ss.round_win = 0) AS losses
FROM survivor_stats ss
JOIN users u ON ss.steam_id = u.steam_id
JOIN survivor_classes sc ON ss.survivor_id = sc.class_id
GROUP BY ss.steam_id, ss.survivor_id;

CREATE OR REPLACE VIEW infected_stats_averages AS
SELECT ist.steam_id, u.user_name,
    ic1.class_name AS infected_name_1, ic2.class_name AS infected_name_2, ic3.class_name AS infected_name_3,
    tc.class_name AS tank_name,
    COUNT(*) AS rounds_played,
    ROUND(AVG(ist.survivor_kills), 1) AS avg_survivor_kills,
    ROUND(AVG(ist.survivor_incaps), 1) AS avg_survivor_incaps,
    ROUND(AVG(ist.damage_smoker + ist.damage_boomer + ist.damage_hunter + ist.damage_spitter + ist.damage_jockey + ist.damage_charger + ist.damage_tank), 1) AS avg_damage_to_survivors,
    ROUND(AVG(ist.damage_smoker), 1) AS avg_damage_smoker,
    ROUND(AVG(ist.damage_boomer), 1) AS avg_damage_boomer,
    ROUND(AVG(ist.damage_hunter), 1) AS avg_damage_hunter,
    ROUND(AVG(ist.damage_spitter), 1) AS avg_damage_spitter,
    ROUND(AVG(ist.damage_jockey), 1) AS avg_damage_jockey,
    ROUND(AVG(ist.damage_charger), 1) AS avg_damage_charger,
    ROUND(AVG(ist.damage_tank), 1) AS avg_damage_tank,
    ROUND(AVG(ist.damage_taken), 1) AS avg_damage_taken,
    ROUND(AVG(ist.time_played), 0) AS avg_time_played,
    SUM(ist.round_win = 1) AS wins,
    SUM(ist.round_win = 0) AS losses
FROM infected_stats ist
JOIN users u ON ist.steam_id = u.steam_id
JOIN infected_classes ic1 ON ist.infected_id_1 = ic1.class_id
JOIN infected_classes ic2 ON ist.infected_id_2 = ic2.class_id
JOIN infected_classes ic3 ON ist.infected_id_3 = ic3.class_id
LEFT JOIN tank_classes tc ON ist.tank_chosen = tc.class_id
GROUP BY ist.steam_id, ist.infected_id_1, ist.infected_id_2, ist.infected_id_3, ist.tank_chosen;

CREATE OR REPLACE VIEW survivor_pick_counts AS
SELECT sc.class_name AS survivor_name, COUNT(*) AS pick_count
FROM survivor_stats sp
JOIN survivor_classes sc ON sp.survivor_id = sc.class_id
GROUP BY sp.survivor_id
ORDER BY pick_count DESC;

CREATE OR REPLACE VIEW infected_pick_counts AS
SELECT ic.class_name AS infected_name, COUNT(*) AS pick_count
FROM (
    SELECT infected_id_1 AS infected_id FROM infected_stats
    UNION ALL
    SELECT infected_id_2 FROM infected_stats
    UNION ALL
    SELECT infected_id_3 FROM infected_stats
) picks
JOIN infected_classes ic ON picks.infected_id = ic.class_id
GROUP BY picks.infected_id
ORDER BY pick_count DESC;

CREATE OR REPLACE VIEW tank_pick_counts AS
SELECT tc.class_name AS tank_name, COUNT(*) AS pick_count
FROM infected_stats ist
JOIN tank_classes tc ON ist.tank_chosen = tc.class_id
WHERE ist.tank_chosen IS NOT NULL
GROUP BY ist.tank_chosen
ORDER BY pick_count DESC;

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
