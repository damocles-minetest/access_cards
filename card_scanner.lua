-- stolen and adapted from https://github.com/D00Med/scifi_nodes/blob/master/palm_scanner.lua

local function starts_with(str, start)
   return str:sub(1, #start) == start
end

local function activate_palm_scanner(pos, node, player)
	local name = player and player:get_player_name()
	name = name or ""

  local stack = player:get_wielded_item()
	local key_name = nil

	if starts_with(stack:get_name(), "access_cards") then
		-- an access card
		local meta = stack:get_meta()
		if meta:get_int("configured") then
			key_name = meta:get_string("name")
		end
	end

  local meta = minetest.get_meta(pos)
  if meta:get_int("configured") ~= 1 then

    if key_name then
      minetest.sound_play("access_cards_scanning", {max_hear_distance = 8, pos = pos, gain = 1.0})
      meta:set_string("key", key_name)
      meta:set_int("configured", 1)
      minetest.chat_send_player(name, "Scanner-key set to '" .. key_name .. "'")
		else
			minetest.chat_send_player(name, "Please provide a configured access card")
    end
    return
  end

	-- check key
  local key = meta:get_string("key")

	if key ~= key_name then
    node.name = "access_cards:palm_scanner_off"
    minetest.swap_node(pos, node)

		minetest.chat_send_player(name, "Access denied !")
		minetest.sound_play("access_cards_refused", {max_hear_distance = 8, pos = pos, gain = 1.0})

	else
    node.name = "access_cards:palm_scanner_on"
		minetest.swap_node(pos, node)

		minetest.chat_send_player(name, "Access granted !")
    minetest.sound_play("access_cards_granted", {max_hear_distance = 8, pos = pos, gain = 1.0})
		mesecon.receptor_on(pos)

    -- reset state
    minetest.after(2, function()
      node.name = "access_cards:palm_scanner_off"
      minetest.swap_node(pos, node)
      mesecon.receptor_off(pos)
    end)

	end
end

minetest.register_node("access_cards:palm_scanner_off", {
	description = "Palm scanner",
	tiles = {"access_cards_scanner_off.png",},
	inventory_image = "access_cards_scanner_off.png",
	wield_image = "access_cards_scanner_on.png",
	drawtype = "signlike",
	sunlight_propagates = true,
	buildable_to = false,
	node_box = {type = "wallmounted",},
	selection_box = {type = "wallmounted",},
	paramtype = "light",
	paramtype2 = "wallmounted",
	groups = {cracky=1, oddly_breakable_by_hand=1, mesecon_needs_receiver = 1},
	mesecons = {
		receptor = {
			state = mesecon.state.off
		}
	},
	on_rightclick = activate_palm_scanner,
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("access_cards:palm_scanner_on", {
	description = "Palm scanner",
	sunlight_propagates = true,
	buildable_to = false,
	tiles = {"access_cards_scanner_on.png",},
	inventory_image = "access_cards_scanner_on.png",
	wield_image = "access_cards_scanner_on.png",
	drawtype = "signlike",
	node_box = {type = "wallmounted",},
	selection_box = {type = "wallmounted",},
	paramtype = "light",
	paramtype2 = "wallmounted",
	light_source = 5,
	groups = {cracky=1, oddly_breakable_by_hand=1, not_in_creative_inventory=1, mesecon_needs_receiver = 1},
	drop = "access_cards:palm_scanner_off",
	mesecons = {
		receptor = {
			state = mesecon.state.on
		}
	},
	sounds = default.node_sound_glass_defaults(),
})
