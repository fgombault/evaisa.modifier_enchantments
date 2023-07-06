if (actions == nil) then
	reading_name = true
	dofile("data/scripts/gun/gun_actions.lua")
end

local function create_xorshift_prng()
	local g = {
		state = 0xdeadbeef,
		seed = function(self, num)
			if num then
				self.state = tonumber(num)
			end
		end,
		next_int = function(self)
			local x = self.state
			x = bit.bxor(x, bit.lshift(x, 13))
			x = bit.bxor(x, bit.rshift(x, 17))
			x = bit.bxor(x, bit.lshift(x, 5))
			self.state = x
			return x
		end,
	}
	return g
end
local rng = create_xorshift_prng()
rng:seed(StatsGetValue("gold"))

for k, v in pairs(actions) do
	local pass = ((rng:next_int()) % 10 == 0)
	-- if v.name contains "Eternal" then don't pass
	if string.find(v.name, "Eternal") then
		pass = false
	end
	if (v.type == ACTION_TYPE_MODIFIER and pass) then
		pretty_print = dofile("mods/evaisa.enchantments/files/scripts/pretty_print.lua")

		--pretty_print.table(v)

		table.insert(enchantments, {
			id = v.id .. "_enchantment",
			name = v.name,
			description = v.description,
			icon = v.sprite,
			author = "???",
			valid_spell_types = { ACTION_TYPE_PROJECTILE, ACTION_TYPE_STATIC_PROJECTILE, ACTION_TYPE_MODIFIER,
				ACTION_TYPE_DRAW_MANY, ACTION_TYPE_PASSIVE },
			is_stackable = true,
			card_extra_entities = { v.custom_xml_file },
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
