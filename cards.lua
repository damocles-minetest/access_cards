

minetest.register_craftitem("access_cards:access_card_1", {
	description = "Access card",
  inventory_image = "access_card_1.png",
	stack_max = 1,
	on_use = function(_, player)
		access_cards.name_form(player)
	end
})

minetest.register_craftitem("access_cards:access_card_1_colored", {
	description = "Access card",
	groups = {ud_param2_colorable = 1, not_in_creative_inventory = 1},
  inventory_image = "access_card_1.png",
  palette = "unifieddyes_palette_extended.png",
	stack_max = 1,
  paramtype2 = "color",
	on_use = function(_, player)
		access_cards.name_form(player)
	end
})

unifieddyes.register_color_craft({
	output = "access_cards:access_card_1_colored",
	palette = "extended",
	neutral_node = "access_cards:access_card_1",
	recipe = { "NEUTRAL_NODE", "MAIN_DYE" },
  type = "shapeless"
})
