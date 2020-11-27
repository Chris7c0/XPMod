#define DB_COL_INDEX_USERS_USER_ID               0
#define DB_COL_INDEX_USERS_USER_NAME             1
#define DB_COL_INDEX_USERS_STEAM_ID              2
#define DB_COL_INDEX_USERS_HASH_VALUE            3
#define DB_COL_INDEX_USERS_SALT                  4
#define DB_COL_INDEX_USERS_XP                    5
#define DB_COL_INDEX_USERS_SURVIVOR_ID           6
#define DB_COL_INDEX_USERS_INFECTED_ID_1         7
#define DB_COL_INDEX_USERS_INFECTED_ID_2         8
#define DB_COL_INDEX_USERS_INFECTED_ID_3         9
#define DB_COL_INDEX_USERS_EQUIPMENT_PRIMARY     10
#define DB_COL_INDEX_USERS_EQUIPMENT_SECONDARY   11
#define DB_COL_INDEX_USERS_EQUIPMENT_EXPLOSIVE   12
#define DB_COL_INDEX_USERS_EQUIPMENT_HEALTH      13
#define DB_COL_INDEX_USERS_EQUIPMENT_BOOST       14
#define DB_COL_INDEX_USERS_EQUIPMENT_LASER       15
#define DB_COL_INDEX_USERS_OPTION_ANNOUNCER      16
#define DB_COL_INDEX_USERS_OPTION_DISPLAY_XP     17

new String:strUsersTableColumnNames[][] = {
    "user_id",
    "user_name",
    "steam_id",
    "hash_value",
    "salt",
    "xp",
	"survivor_id",
	"infected_id_1",
    "infected_id_2",
    "infected_id_3",
    "equipment_primary",
    "equipment_secondary",
    "equipment_explosive",
    "equipment_health",
    "equipment_boost",
    "equipment_laser",
    "option_announcer",
    "option_display_xp",
};

// enum UsersTableColumnIndex
// {
//     user_id,
//     user_name,
//     steam_id,
//     hash_value,
//     salt,
//     XP,
// 	survivor_id,
// 	infected_id_1,
//     infected_id_2,
//     infected_id_3,
//     equipment_primary,
//     equipment_secondary,
//     equipment_explosive,
//     equipment_health,
//     equipment_boost,
//     equipment_laser,
//     option_announcer,
//     option_display_xp
// }

// enum struct UsersTableColumnIndex
// {
//     int user_id 0;
//     int user_name;
//     int steam_id;
//     int hash_value;
//     int salt;
//     int XP;
// 	int survivor_id;
// 	int infected_id_1;
//     int infected_id_2;
//     int infected_id_3;
//     int equipment_primary;
//     int equipment_secondary;
//     int equipment_explosive;
//     int equipment_health;
//     int equipment_boost;
//     int equipment_laser;
//     int option_announcer;
//     int option_display_xp;
// }