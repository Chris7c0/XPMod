#define DB_COL_INDEX_USERS_USER_ID               0
#define DB_COL_INDEX_USERS_USER_NAME             1
#define DB_COL_INDEX_USERS_STEAM_ID              2
#define DB_COL_INDEX_USERS_TOKEN                 3
#define DB_COL_INDEX_USERS_XP                    4
#define DB_COL_INDEX_USERS_SURVIVOR_ID           5
#define DB_COL_INDEX_USERS_INFECTED_ID_1         6
#define DB_COL_INDEX_USERS_INFECTED_ID_2         7
#define DB_COL_INDEX_USERS_INFECTED_ID_3         8
#define DB_COL_INDEX_USERS_EQUIPMENT_PRIMARY     9
#define DB_COL_INDEX_USERS_EQUIPMENT_SECONDARY   10
#define DB_COL_INDEX_USERS_EQUIPMENT_EXPLOSIVE   11
#define DB_COL_INDEX_USERS_EQUIPMENT_HEALTH      12
#define DB_COL_INDEX_USERS_EQUIPMENT_BOOST       13
#define DB_COL_INDEX_USERS_EQUIPMENT_LASER       14
#define DB_COL_INDEX_USERS_OPTION_ANNOUNCER      15
#define DB_COL_INDEX_USERS_OPTION_DISPLAY_XP     16
#define DB_COL_INDEX_PRESTIGE_POINTS             17
#define DB_COL_INDEX_PUSH_UPDATE_FROM_DB         18

new String:strUsersTableColumnNames[][] = {
    "user_id",
    "user_name",
    "steam_id",
    "token",
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
    "prestige_points",
    "push_update_from_db"
};

// enum UsersTableColumnIndex
// {
//     user_id,
//     user_name,
//     steam_id,
//     token,
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
//     int token;
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