if(actions == nil)then
	reading_name = true
	dofile("data/scripts/gun/gun_actions.lua")
end
for k, v in pairs(actions)do
	if(v.type == ACTION_TYPE_MODIFIER)then
		pretty_print = dofile("mods/evaisa.enchantments/files/scripts/pretty_print.lua")

		--pretty_print.table(v)

		table.insert(enchantments, {
			id = v.id.."_enchantment",
			name = v.name,
			description = v.description,
			icon = v.sprite,
			author = "???",
			valid_spell_types = {ACTION_TYPE_PROJECTILE, ACTION_TYPE_STATIC_PROJECTILE, ACTION_TYPE_MODIFIER, ACTION_TYPE_DRAW_MANY, ACTION_TYPE_PASSIVE},
			is_stackable = true,
			card_extra_entities = {v.custom_xml_file},
			weight = 1.0,
			check = function(action)
				return true
			end,
			hook = function(orig, recursion_level, iteration)
				local old_modifier_enchantment_data = draw_actions
				draw_actions = function(...) end
				disable_enchantments = true
				v.action(recursion_level, iteration)
				disable_enchantments = false
				draw_actions = old_modifier_enchantment_data

				orig(recursion_level, iteration)
				
			end,
			projectile_spawn = function(projectile_entity) 

			end
		})
	end
end