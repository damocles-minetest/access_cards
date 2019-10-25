-- stolen and adapted from https://github.com/D00Med/scifi_nodes/blob/master/palm_scanner.lua


local function activate_palm_scanner(pos, node, player)
	local name = player and player:get_player_name()
	name = name or ""

  local wield_item = player:get_wielded_item()
  local wield_str = wield_item:to_string()

  local meta = minetest.get_meta(pos)
  if meta:get_int("configured") ~= 1 then

    if wield_str then
      minetest.sound_play("scifi_nodes_palm_scanner", {max_hear_distance = 8, pos = pos, gain = 1.0})
      meta:set_string("key", wield_str)
      meta:set_int("configured", 1)
      minetest.chat_send_player(name, "Scanner-key set to '" .. wield_str .. "'")
    end
    return
  end

	-- check key
  local key = meta:get_string("key")

	if key ~= wield_str then
    node.name = "access_cards:palm_scanner_off"
    minetest.swap_node(pos, node)

		minetest.chat_send_player(name, "Access denied !")
		minetest.sound_play("scifi_nodes_scanner_refused", {max_hear_distance = 8, pos = pos, gain = 1.0})

	else
    node.name = "access_cards:palm_scanner_on"
		minetest.swap_node(pos, node)

		minetest.chat_send_player(name, "Access granted !")
		mesecon.receptor_on(pos, scifi_nodes.get_switch_rules(node.param2))

		player:set_wielded_item(nil)

    -- reset state
    minetest.after(2, function()
      node.name = "access_cards:palm_scanner_off"
      minetest.swap_node(pos, node)
      mesecon.receptor_off(pos, scifi_nodes.get_switch_rules(node.param2))
    end)

	end
end

minetest.register_node("access_cards:palm_scanner_off", {
	description = "Palm scanner",
	tiles = {"scifi_nodes_palm_scanner_off.png",},
	inventory_image = "scifi_nodes_palm_scanner_off.png",
	wield_image = "scifi_nodes_palm_scanner_on.png",
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

minetest.register_node("access_cards:palm_scanner_checking", {
	description = "Palm scanner",
	tiles = {{
		name = "scifi_nodes_palm_scanner_checking.png",
		animation = {type = "vertical_frames",aspect_w = 16,aspect_h = 16,length = 1.5}
	}},
	drawtype = "signlike",
	sunlight_propagates = true,
	buildable_to = false,
	node_box = {type = "wallmounted",},
	selection_box = {type = "wallmounted",},
	paramtype = "light",
	paramtype2 = "wallmounted",
	groups = {cracky=1, oddly_breakable_by_hand=1, not_in_creative_inventory=1, mesecon_needs_receiver = 1},
	drop = "access_cards:palm_scanner_off",
	sounds = default.node_sound_glass_defaults()
})

minetest.register_node("access_cards:palm_scanner_on", {
	description = "Palm scanner",
	sunlight_propagates = true,
	buildable_to = false,
	tiles = {"scifi_nodes_palm_scanner_on.png",},
	inventory_image = "scifi_nodes_palm_scanner_on.png",
	wield_image = "scifi_nodes_palm_scanner_on.png",
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
