# Secrets,not checked into source control
hcloud_token        = "<HCLOUD TOKEN>"
hetznerdns_token    = "<HETZNER DNS TOKEN>"
server_ssh_keys     = ["<KEY NAME USED WITH HETZNER>"]
minecraft_whitelist = ["<MINECRAFT USERLIST>"]
minecraft_opslist   = ["<MINECRAFT OPERATORS>"]

# Settings, checked into source control
server_type           = "cx21"
minecraft_public_port = 8001
minecraft_enable_rcon = "false"
minecraft_settings = {
  "TYPE"                       = "FABRIC"
  "REMOVE_OLD_MODS"            = "TRUE"
  "OVERRIDE_SERVER_PROPERTIES" = "true"
  "MEMORY"                     = "1536M"
  "SERVER_NAME"                = "Private Server for testing"
  #DIFFICULTY peaceful, easy, normal, and hard
  "DIFFICULTY" = "peaceful"
  "ICON"       = "<ICON URL>"
  #MAX_PLAYERS is limit on players normally 20
  "MAX_PLAYERS"                  = "10"
  "MAX_WORLD_SIZE"               = "10000"
  "ALLOW_NETHER"                 = "true"
  "ANNOUNCE_PLAYER_ACHIEVEMENTS" = "true"
  "ENABLE_COMMAND_BLOCK"         = "true"
  "FORCE_GAMEMODE"               = "false"
  "GENERATE_STRUCTURES"          = "true"
  "HARDCORE"                     = "false"
  "SNOOPER_ENABLED"              = "false"
  "MAX_BUILD_HEIGHT"             = "256"
  "MAX_TICK_TIME"                = "60000"
  "SPAWN_ANIMALS"                = "true"
  "SPAWN_MONSTERS"               = "true"
  "SPAWN_NPCS"                   = "true"
  "SPAWN_PROTECTION"             = "0"
  "VIEW_DISTANCE"                = "10"
  #MODE creative survival adventure spectator
  "MODE"       = "survival"
  "MOTD"       = "Go wisely into the world"
  "PVP"        = "false"
  "LEVEL_TYPE" = "flat"
}
