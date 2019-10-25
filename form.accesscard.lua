
local FORMNAME = "access_card_name"

local function starts_with(str, start)
   return str:sub(1, #start) == start
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end

	local stack = player:get_wielded_item()

	if not starts_with(stack:get_name(), "access_cards") then
		-- not an access card
		return
	end

	local meta = stack:get_meta()

	if meta:get_int("configured") == 1 then
		-- already configured
		return
	end

	meta:set_int("configured", 1)
	meta:set_string("name", fields.name)
	meta:set_string("description", "Access card: '" .. fields.name .. "'")

	player:set_wielded_item(stack)
end)


access_cards.name_form = function(player)
	local formspec = "size[8,1;]" ..
		"field[0,0.5;6,1;name;Name;]" ..
		"button_exit[6,0.1;2,1;save;Save]"

	minetest.show_formspec(player:get_player_name(),
		FORMNAME,
		formspec
	)
end
