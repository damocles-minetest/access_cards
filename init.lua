local MP = minetest.get_modpath("access_cards")

access_cards = {}

dofile(MP.."/form.accesscard.lua")
dofile(MP.."/cards.lua")

if minetest.get_modpath("scifi_nodes") and minetest.get_modpath("mesecons") then
  dofile(MP.."/card_scanner.lua")
end

print("[OK] access_cards")
