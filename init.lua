if not farming or farming.mod ~= "redo" then return end
local fs_f = 2--foodspoil fast (2 ingame days)
local fs_m = 7--foodspoil medium (7 ingame days)
local fs_s = 14--foodspoil slow (14 ingame days)
if not foodspoil_register then foodspoil_register = function() end end
--foodspoil_register("cooking:bread_sliced", fs_f)
local function season_salt_butter_garlic(itemname, newitemname, satpoints, description, inventory_image, replace_item, nocraft, foodspoil_time)
	if not newitemname then newitemname = itemname end
	local s1 = satpoints+1
	local s2 = satpoints+2
	local s3 = satpoints+3
	if satpoints < 1 then--if satpoints is 0 or less (poison) adding salt/butter/garlic isnt going to help.
		s1 = satpoints
		s2 = satpoints
		s3 = satpoints
	end
	minetest.register_craftitem(newitemname.."_1", {
		description = "Salted "..description,
		inventory_image = inventory_image,
		on_use = minetest.item_eat(s1, replace_item),
		_cookingsimple = true
		--groups = {not_in_creative_inventory = 1}
	})
	minetest.register_craftitem(newitemname.."_2", {
		description = "Buttered "..description,
		inventory_image = inventory_image.."^cooking_buttery.png",
		on_use = minetest.item_eat(s2, replace_item),
		--groups = {not_in_creative_inventory = 1}
	})
	minetest.register_craftitem(newitemname.."_3", {
		description = "Garlic "..description,
		inventory_image = inventory_image.."^cooking_buttery.png^(cooking_garlicky.png^[mask:"..inventory_image..")",
		on_use = minetest.item_eat(s3, replace_item),
		groups = {not_in_creative_inventory = 1}
	})
	if foodspoil_time then
		foodspoil_register(newitemname.."_1", foodspoil_time+1)
		foodspoil_register(newitemname.."_2", foodspoil_time+1)
		foodspoil_register(newitemname.."_3", foodspoil_time+1)
	end
	if nocraft ~= true then
		cooking.register_craft({
			type = "mix",
			recipe = {itemname, "farming:salt"},
			output = newitemname.."_1"
		})
		cooking.register_craft({
			type = "mix",
			recipe = {itemname, "farming:salt", "cooking_fr:butter"},
			output = newitemname.."_2"
		})
		cooking.register_craft({
			type = "mix",
			recipe = {itemname, "farming:salt", "cooking_fr:butter", "cooking_fr:garlic_powder"},
			output = newitemname.."_3"
		})
	end
end

minetest.override_item("farming:salt", {groups = {food_salt = 1, dig_immediate = 3,attached_node = 1}})

minetest.register_craftitem("cooking_fr:colander", {
	description = "Colander",
	inventory_image = "cooking_colander.png",
	_soup_swap = false
})
minetest.register_craft({
	recipe = {
		{"xpanes:bar_flat", "", "xpanes:bar_flat"},
		{"", "xpanes:bar_flat", ""}
	},
	output = "cooking_fr:colander"
})

--chopped/sliced items
minetest.register_craftitem("cooking_fr:pepper_sliced", {
	description = "Sliced Pepper",
	inventory_image = "cooking_pepper_sliced.png",
})
foodspoil_register("cooking_fr:pepper_sliced", fs_f)

minetest.register_craftitem("cooking_fr:garlic_chopped", {
	description = "Chopped Garlic",
	inventory_image = "cooking_garlic_chopped.png",
})
foodspoil_register("cooking_fr:garlic_chopped", fs_f)

minetest.register_craftitem("cooking_fr:onion_sliced", {
	description = "Sliced Onion",
	inventory_image = "cooking_onion_sliced.png",
})
foodspoil_register("cooking_fr:onion_sliced", fs_f)

minetest.register_craftitem("cooking_fr:tomato_sliced", {
	description = "Sliced Tomato",
	inventory_image = "cooking_tomato_sliced.png",
})
foodspoil_register("cooking_fr:tomato_sliced", fs_f)

cooking.register_craft({
	type = "cut",
	recipe = "farming:pepper",
	output = {"cooking_fr:pepper_sliced 4"}
})
cooking.register_craft({
	type = "cut",
	recipe = "farming:garlic_clove",
	output = {"cooking_fr:garlic_chopped"}
})
cooking.register_craft({
	type = "cut",
	recipe = "farming:onion",
	output = {"cooking_fr:onion_sliced 4"}
})
cooking.register_craft({
	type = "cut",
	recipe = "farming:tomato",
	output = {"cooking_fr:tomato_sliced 4"}
})

--butter and cheese
minetest.register_craftitem("cooking_fr:butter", {
	description = "Butter",
	inventory_image = "mobs_butter.png",
})
foodspoil_register("cooking_fr:butter", fs_s)

minetest.register_craftitem("cooking_fr:cheese", {
	description = "Cheese",
	inventory_image = "mobs_cheese.png",
})
foodspoil_register("cooking_fr:cheese", 60)

minetest.register_craftitem("cooking_fr:cheese_sliced", {
	description = "Sliced Cheese",
	inventory_image = "cooking_cheese_sliced.png",
})
foodspoil_register("cooking_fr:cheese_sliced", fs_s)

cooking.register_craft({
	type = "press",
	recipe = "mobs:bucket_milk",
	output = {"cooking_fr:butter 8", "bucket:bucket_empty"}
})
cooking.register_craft({
	type = "stove",
	recipe = "mobs:bucket_milk",
	replacements = {"bucket:bucket_empty"},
	output = {"cooking_fr:cheese"}
})
cooking.register_craft({
	type = "cut",
	recipe = "cooking_fr:cheese",
	output = {"cooking_fr:cheese_sliced 8"}
})

--garlic powder
minetest.register_craftitem("cooking_fr:garlic_powder", {
	description = "Garlic Powder",
	inventory_image = "cooking_garlic_powder.png",
})
foodspoil_register("cooking_fr:garlic_powder", 180)

cooking.register_craft({
	type = "press",
	recipe = "farming:garlic_clove",
	output = "cooking_fr:garlic_powder 2"
})

--vegetables
for itemname, tbl in pairs({
	["beans"] = {c1 = 94, c2 = 157},
	["beetroot"] = {c1 = 94, c2 = 46},
	["carrot"] = {c1 = 94, c2 = 236, sat = 2},
	["corn"] = {c1 = 94, c2 = 223, sat = 2},
	["pea_pod"] = {c1 = 94, c2 = 191}}) do
	
	local fullname = "farming:"..itemname
	local boiledname = "cooking_fr:"..itemname.."_boiled"
	local def = minetest.registered_items[fullname]
	assert(def, fullname.." has no registration")
	local desc = def.description
	local sat = tbl.sat or 1 	
	local tex = "farming_"..itemname..".png^[multiply:#cacaca"
	minetest.register_craftitem("cooking_fr:"..itemname.."_uncooked", {
		description = desc,
		inventory_image = tex,
		param2 = tbl.c1,
		_soup_item = fullname,
		_soup_container ="cooking_fr:colander",
		_cookingsimple = true
		--groups = {not_in_creative_inventory = 1}
	})
	minetest.register_craftitem(boiledname, {
		description = "Boiled "..desc,
		inventory_image = tex,
		param2 = tbl.c2,
		_soup_container ="cooking_fr:colander",
		on_use = minetest.item_eat(sat+1),
		--groups = {not_in_creative_inventory = 1}
	})
	foodspoil_register(boiledname, fs_m)
	minetest.register_craftitem(boiledname.."_1", {
		description = "Salted "..desc,
		inventory_image = tex,
		on_use = minetest.item_eat(sat+2),
		--groups = {not_in_creative_inventory = 1}
	})
	foodspoil_register(boiledname.."_1", fs_m)
	minetest.register_craftitem(boiledname.."_2", {
		description = "Buttered "..desc,
		inventory_image = tex.."^cooking_buttery.png",
		on_use = minetest.item_eat(sat+3),
		groups = {not_in_creative_inventory = 1}
	})
	foodspoil_register(boiledname.."_2", fs_m)
	cooking.register_craft({
		type = "soup",
		param2 = 6,
		recipe = {fullname, fullname, fullname, fullname},
		output = "cooking_fr:"..itemname.."_uncooked"
	})
	cooking.register_craft({
		type = "stove",
		cooktime = 10,
		recipe = "cooking_fr:"..itemname.."_uncooked",
		output = boiledname
	})
	cooking.register_craft({
		type = "mix",
		recipe = {boiledname, "farming:salt"},
		output = boiledname.."_1"
	})
	cooking.register_craft({
		type = "mix",
		recipe = {boiledname, "farming:salt", "cooking_fr:butter"},
		output = boiledname.."_2"
	})
end

--beef stroganoff

minetest.register_craftitem("cooking_fr:beef_stroganoff", {
	description = "Beef Stroganoff",
	inventory_image = "cooking_beef_stroganoff.png",
	on_use = minetest.item_eat(10, "cooking:bowl")
})
foodspoil_register("cooking_fr:beef_stroganoff", fs_m)
cooking.register_craft({
	type = "mix",
	recipe = {"cooking:mushroom_soup", "cooking_fr:rice", "cooking_fr:ground_beef"},
	output = {"cooking_fr:beef_stroganoff", "cooking:bowl"}
})

--porridge
minetest.register_craftitem("cooking_fr:porridge_uncooked", {
	description = "Uncooked Porridge",
	--stack_max = 1,
	inventory_image = "farming_porridge.png",
	param2 = 238,
	on_use = minetest.item_eat(2, "cooking:bowl"),
	_cookingsimple = true
})
foodspoil_register("cooking_fr:porridge_uncooked", fs_m)

minetest.register_craftitem("cooking_fr:porridge", {
	description = "Porridge",
	--stack_max = 1,
	inventory_image = "farming_porridge.png",
	param2 = 240,
	on_use = minetest.item_eat(6, "cooking:bowl")
})
foodspoil_register("cooking_fr:porridge", fs_m)

minetest.register_craftitem("cooking_fr:porridge_sweetened", {
	description = "Sweetened Porridge",
	--stack_max = 1,
	inventory_image = "farming_porridge.png",
	param2 = 240,
	on_use = minetest.item_eat(8, "cooking:bowl"),
	_cookingsimple = true
})
foodspoil_register("cooking_fr:porridge_sweetened", fs_m)

for i, craftname in pairs({"farming:barley","farming:rye","farming:oat","farming:wheat"}) do
	cooking.register_craft({
		type = "soup",
		param2 = 6,
		recipe = {craftname, craftname, craftname},
		output = "cooking_fr:porridge_uncooked"
	})
end
cooking.register_craft({
	type = "stove",
	cooktime = 10,
	recipe = "cooking_fr:porridge_uncooked",
	output = "cooking_fr:porridge"
})
cooking.register_craft({
	type = "stack",
	recipe = {"cooking_fr:porridge", "cooking:sugar"},
	output = "cooking_fr:porridge_sweetened",
})

--hamburgers

minetest.register_craftitem("cooking_fr:ground_beef_uncooked", {
	description = "Uncooked Ground Beef",
	inventory_image = "cooking_ground_beef_uncooked.png",
})
foodspoil_register("cooking_fr:ground_beef_uncooked", fs_f)

minetest.register_craftitem("cooking_fr:ground_beef", {
	description = "Ground Beef",
	inventory_image = "cooking_ground_beef.png",
})
foodspoil_register("cooking_fr:ground_beef", fs_m)

minetest.register_craftitem("cooking_fr:hamburger_patty_uncooked", {
	description = "Uncooked Hamburger Patty",
	inventory_image = "cooking_hamburger_patty_uncooked.png",
})
foodspoil_register("cooking_fr:hamburger_patty_uncooked", fs_f)

minetest.register_craftitem("cooking_fr:hamburger", {
	description = "Hamburger",
	inventory_image = "cooking_hamburger.png",
	on_use = minetest.item_eat(6)
})
foodspoil_register("cooking_fr:hamburger", fs_f)

minetest.register_craftitem("cooking_fr:cheeseburger", {
	description = "Cheeseburger",
	inventory_image = "cooking_cheeseburger.png",
	on_use = minetest.item_eat(8)
})
foodspoil_register("cooking_fr:cheeseburger", fs_f)

minetest.register_craftitem("cooking_fr:cheeseburger_double", {
	description = "Double Cheeseburger",
	inventory_image = "cooking_cheeseburger_double.png",
	on_use = minetest.item_eat(12)
})
foodspoil_register("cooking_fr:cheeseburger_double", fs_f)

minetest.register_craftitem("cooking_fr:cheeseburger_supreme", {
	description = "Supreme Cheeseburger",
	inventory_image = "cooking_cheeseburger_supreme.png",
	on_use = minetest.item_eat(16)
})
foodspoil_register("cooking_fr:cheeseburger_supreme", fs_f)

minetest.register_craftitem("cooking_fr:cheeseburger_supreme_no_onion", {
	description = "Supreme Cheeseburger (no onion)",
	inventory_image = "cooking_cheeseburger_supreme_no_onion.png",
	on_use = minetest.item_eat(14)
})
foodspoil_register("cooking_fr:cheeseburger_supreme_no_onion", fs_f)

minetest.register_craftitem("cooking_fr:cheeseburger_supreme_no_tomato", {
	description = "Supreme Cheeseburger (no tomato)",
	inventory_image = "cooking_cheeseburger_supreme_no_tomato.png",
	on_use = minetest.item_eat(14)
})
foodspoil_register("cooking_fr:cheeseburger_supreme_no_tomato", fs_f)

minetest.register_craftitem("cooking_fr:heartstopper", {
	description = "Heartstopper Burger",
	inventory_image = "cooking_heartstopper.png",
	on_use = minetest.item_eat(24)
})
foodspoil_register("cooking_fr:heartstopper", fs_f)

minetest.register_craftitem("cooking_fr:hamburger_patty", {
	description = "Hamburger Patty",
	inventory_image = "cooking_hamburger_patty.png",
})
foodspoil_register("cooking_fr:hamburger_patty", fs_m)

minetest.register_craftitem("cooking_fr:bun_top", {
	description = "Bun Top",
	inventory_image = "cooking_bun_top.png",
})
foodspoil_register("cooking_fr:bun_top", fs_m)

minetest.register_craftitem("cooking_fr:bun_bottom", {
	description = "Bun Bottom",
	inventory_image = "cooking_bun_bottom.png",
})
foodspoil_register("cooking_fr:bun_bottom", fs_m)

cooking.register_craft({
	type = "cut",
	recipe = "cooking:bun",
	output = "cooking_fr:bun_top,cooking_fr:bun_bottom"
})
cooking.register_craft({
	type = "stack",
	recipe = {"cooking_fr:bun_bottom", "cooking_fr:hamburger_patty", "cooking_fr:bun_top"},
	output = "cooking_fr:hamburger"
})
cooking.register_craft({
	type = "stack",
	recipe = {"cooking_fr:bun_bottom", "cooking_fr:hamburger_patty", "cooking_fr:cheese_sliced", "cooking_fr:bun_top"},
	output = "cooking_fr:cheeseburger"
})
cooking.register_craft({
	type = "stack",
	recipe = {"cooking_fr:bun_bottom", "cooking_fr:hamburger_patty", "cooking_fr:cheese_sliced", "cooking_fr:hamburger_patty", "cooking_fr:cheese_sliced", "cooking_fr:bun_top"},
	output = "cooking_fr:cheeseburger_double"
})
cooking.register_craft({
	type = "stack",
	recipe = {"cooking_fr:bun_bottom", "cooking_fr:hamburger_patty", "cooking_fr:cheese_sliced", "cooking_fr:onion_sliced", "cooking_fr:tomato_sliced", "cooking_fr:bun_top"},
	output = "cooking_fr:cheeseburger_supreme"
})
cooking.register_craft({
	type = "stack",
	recipe = {"cooking_fr:bun_bottom", "cooking_fr:hamburger_patty", "cooking_fr:cheese_sliced", "cooking_fr:tomato_sliced", "cooking_fr:bun_top"},
	output = "cooking_fr:cheeseburger_supreme_no_onion"
})
cooking.register_craft({
	type = "stack",
	recipe = {"cooking_fr:bun_bottom", "cooking_fr:hamburger_patty", "cooking_fr:cheese_sliced", "cooking_fr:onion_sliced", "cooking_fr:bun_top"},
	output = "cooking_fr:cheeseburger_supreme_no_tomato"
})
cooking.register_craft({
	type = "stack",
	recipe = {"cooking_fr:bun_bottom", "cooking_fr:hamburger_patty", "cooking_fr:cheese_sliced", "cooking_fr:onion_sliced", "cooking_fr:tomato_sliced", "cooking_fr:hamburger_patty", "cooking_fr:cheese_sliced", "cooking_fr:onion_sliced", "cooking_fr:tomato_sliced", "cooking_fr:bun_top"},
	output = "cooking_fr:heartstopper"
})
cooking.register_craft({
	type = "cut",
	recipe = "cooking_fr:bun_cooked",
	output = "cooking_fr:bun_top,cooking_fr:bun_bottom"
})
cooking.register_craft({
	type = "press",
	recipe = "mobs:meat_raw",
	output = "cooking_fr:ground_beef_uncooked 2"
})
cooking.register_craft({
	type = "roll",
	recipe = "cooking_fr:ground_beef_uncooked",
	output = "cooking_fr:hamburger_patty_uncooked"
})
cooking.register_craft({
	type = "stove",
	cooktime = 10,
	recipe = "cooking_fr:hamburger_patty_uncooked",
	output = "cooking_fr:hamburger_patty"
})
cooking.register_craft({
	type = "stove",
	cooktime = 10,
	recipe = "cooking_fr:ground_beef_uncooked",
	output = "cooking_fr:ground_beef"
})

--rice
minetest.register_craftitem("cooking_fr:rice_uncooked", {
	description = "Uncooked Rice",
	--stack_max = 1,
	inventory_image = "cooking_rice_uncooked.png",
	param2 = 94,
	_cookingsimple = true
})
foodspoil_register("cooking_fr:rice_uncooked", fs_s)

minetest.register_craftitem("cooking_fr:rice", {
	description = "Rice",
	--stack_max = 1,
	inventory_image = "cooking_rice.png",
	param2 = 204,
	on_use = minetest.item_eat(6, "cooking:bowl")
})
foodspoil_register("cooking_fr:rice", fs_m)

cooking.register_craft({
	type = "soup",
	param2 = 6,
	recipe = {"farming:rice", "farming:rice", "farming:rice"},
	output = "cooking_fr:rice_uncooked"
})
cooking.register_craft({
	type = "stove",
	cooktime = 10,
	recipe = "cooking_fr:rice_uncooked",
	output = "cooking_fr:rice"
})
season_salt_butter_garlic("cooking_fr:rice", nil, 6, "Rice", "cooking_rice.png", "cooking:bowl", nil, fs_m)

--applesauce
minetest.register_craftitem("cooking_fr:apple_stewed_uncooked", {
	description = "Uncooked Stewed Apples",
	inventory_image = "cooking_apple_stewed.png",
	_soup_container = "cooking_fr:colander",
	_soup_item = "cooking:chopped_apple",
	param2 = 3,
	_cookingsimple = true
})
foodspoil_register("cooking_fr:apple_stewed_uncooked", fs_f)

minetest.register_craftitem("cooking_fr:apple_stewed", {
	description = "Stewed Apples",
	inventory_image = "cooking_apple_stewed.png",
	param2 = 4,
	on_use = minetest.item_eat(2, "cooking:bowl")
})
foodspoil_register("cooking_fr:apple_stewed", fs_m)

minetest.register_craftitem("cooking_fr:applesauce", {
	description = "Applesauce",
	inventory_image = "cooking_applesauce.png",
	on_use = minetest.item_eat(3, "cooking:bowl")
})
foodspoil_register("cooking_fr:applesauce", fs_s)

cooking.register_craft({
	type = "soup",
	param2 = 6,
	recipe = {"cooking:chopped_apple", "cooking:chopped_apple", "cooking:chopped_apple", "cooking:chopped_apple"},
	output = "cooking_fr:apple_stewed_uncooked"
})
cooking.register_craft({
	type = "stove",
	cooktime = 10,
	recipe = "cooking_fr:apple_stewed_uncooked",
	output = "cooking_fr:apple_stewed"
})
cooking.register_craft({
	type = "press",
	recipe = "cooking_fr:apple_stewed",
	output = {"cooking_fr:applesauce"}
})
--potatoes
minetest.register_craftitem("cooking_fr:potato_baked", {
	description = "Baked Potato",
	inventory_image = "farming_baked_potato.png",
	on_use = minetest.item_eat(4)
})
foodspoil_register("cooking_fr:potato_baked", fs_m)

cooking.register_craft({
	type = "oven",
	cooktime = 10,
	recipe = "farming:potato",
	output = "cooking_fr:potato_baked"
})
season_salt_butter_garlic("cooking_fr:potato_baked", nil, 4, "Baked Potato", "farming_baked_potato.png", nil, nil, fs_m)

minetest.register_craftitem("cooking_fr:potato_chopped", {
	description = "Chopped Potato",
	inventory_image = "cooking_potato_chopped.png",
})
foodspoil_register("cooking_fr:potato_chopped", fs_m)

cooking.register_craft({
	type = "cut",
	recipe = "farming:potato",
	output = {"cooking_fr:potato_chopped"}
})
minetest.register_craftitem("cooking_fr:potato_boiled_uncooked", {
	description = "Chopped Potato",
	inventory_image = "cooking_potato_chopped.png",
	param2 = 94,
	_soup_container = "cooking_fr:colander",
	_soup_item = "cooking_fr:potato_chopped",
	_cookingsimple = true
})
foodspoil_register("cooking_fr:potato_boiled_uncooked", fs_m)

minetest.register_craftitem("cooking_fr:potato_fries_uncooked", {
	description = "Uncooked Oven Fries",
	inventory_image = "cooking_potato_fries_uncooked.png",
})
foodspoil_register("cooking_fr:potato_fries_uncooked", fs_m)

minetest.register_craftitem("cooking_fr:potato_fries", {
	description = "Oven Fries",
	inventory_image = "cooking_potato_fries.png",
	on_use = minetest.item_eat(10)
})
foodspoil_register("cooking_fr:potato_fries", fs_m)

cooking.register_craft({
	type = "soup",
	param2 = 6,
	recipe = {"cooking_fr:potato_chopped", "cooking_fr:potato_chopped", "cooking_fr:potato_chopped", "cooking_fr:potato_chopped"},
	output = "cooking_fr:potato_boiled_uncooked"
})
minetest.register_craftitem("cooking_fr:potato_boiled", {
	description = "Boiled Potato",
	inventory_image = "cooking_potato_boiled.png",
	param2 = 96,
})
foodspoil_register("cooking_fr:potato_boiled", fs_m)

cooking.register_craft({
	type = "stove",
	cooktime = 10,
	recipe = "cooking_fr:potato_boiled_uncooked",
	output = "cooking_fr:potato_boiled"
})
minetest.register_craftitem("cooking_fr:potato_mashed", {
	description = "Mashed Potato",
	inventory_image = "cooking_potato_mashed.png",
	on_use = minetest.item_eat(6, "cooking:bowl")
})
foodspoil_register("cooking_fr:potato_mashed", fs_m)

cooking.register_craft({
	type = "press",
	recipe = "cooking_fr:potato_boiled",
	output = {"cooking_fr:potato_mashed"}
})
season_salt_butter_garlic("cooking_fr:potato_mashed", nil, 6, "Mashed Potato", "cooking_potato_mashed.png", "cooking:bowl", nil, fs_m)

cooking.register_craft({
	type = "mix",
	recipe = {"cooking_fr:garlic_powder", "farming:salt", "farming:peppercorn", "cooking_fr:butter", "cooking_fr:potato_chopped", "cooking_fr:potato_chopped", "cooking_fr:potato_chopped"},
	output = "cooking_fr:potato_fries_uncooked"
})
cooking.register_craft({
	type = "oven",
	cooktime = 10,
	recipe = "cooking_fr:potato_fries_uncooked",
	output = "cooking_fr:potato_fries"
})

--baked meats and sandwiches

minetest.register_craftitem("cooking_fr:fish_baked", {
	description = "Baked Fish",
	inventory_image = "fishing_fish_cooked.png",
	on_use = minetest.item_eat(4)
})
foodspoil_register("cooking_fr:fish_baked", fs_m)

minetest.register_craftitem("cooking_fr:meat_baked", {
	description = "Baked Meat",
	inventory_image = "mobs_meat.png",
	on_use = minetest.item_eat(4)
})
foodspoil_register("cooking_fr:meat_baked", fs_m)

minetest.register_craftitem("cooking_fr:chicken_baked", {
	description = "Baked Chicken",
	inventory_image = "mobs_chicken_cooked.png",
	on_use = minetest.item_eat(4)
})
foodspoil_register("cooking_fr:chicken_baked", fs_m)

cooking.register_craft({
	type = "oven",
	cooktime = 10,
	recipe = "fishing:fish_raw",
	output = "cooking_fr:fish_baked"
})
cooking.register_craft({
	type = "oven",
	cooktime = 10,
	recipe = "mobs:meat_raw",
	output = "cooking_fr:meat_baked"
})
cooking.register_craft({
	type = "oven",
	cooktime = 10,
	recipe = "mobs:chicken_raw",
	output = "cooking_fr:chicken_baked"
})

season_salt_butter_garlic("fishing:fish_raw", "cooking_fr:fish_raw", -2, "Raw Fish", "fishing_fish_raw.png", nil, nil, fs_m)
season_salt_butter_garlic("mobs:meat_raw", "cooking_fr:meat_raw", -2, "Raw Meat", "mobs_meat_raw.png", nil, nil, fs_m)
season_salt_butter_garlic("mobs:chicken_raw", "cooking_fr:chicken_raw", -2, "Raw Chicken", "mobs_chicken_raw.png", nil, nil, fs_m)

season_salt_butter_garlic("cooking_fr:fish_baked", nil, 4, "Baked Fish", "fishing_fish_cooked.png", nil, true, fs_m)
season_salt_butter_garlic("cooking_fr:meat_baked", nil, 4, "Baked Meat", "mobs_meat.png", nil, true, fs_m)
season_salt_butter_garlic("cooking_fr:chicken_baked", nil, 4, "Baked Chicken", "mobs_chicken_cooked.png", nil, true, fs_m)

season_salt_butter_garlic("cooking_fr:fish_sandwich", nil, 7, "Fish Sandwich", "cooking_fish_sandwich.png", nil, true, fs_m)
season_salt_butter_garlic("cooking_fr:meat_sandwich", nil, 7, "Meat Sandwich", "cooking_meat_sandwich.png", nil, true, fs_m)
season_salt_butter_garlic("cooking_fr:chicken_sandwich", nil, 7, "Chicken Sandwich", "cooking_chicken_sandwich.png", nil, true, fs_m)

for i, itemname in pairs({"cooking_fr:fish", "cooking_fr:meat", "cooking_fr:chicken"}) do
	for i = 1, 3 do
		cooking.register_craft({
			type = "oven",
			cooktime = 10,
			recipe = itemname.."_raw_"..i,
			output = itemname.."_baked_"..i,
		})
		cooking.register_craft({
			type = "stack",
			recipe = {"cooking:bread_sliced", itemname.."_".."baked".."_"..i, "cooking:bread_sliced"},
			output = itemname.."_sandwich_"..i
		})
	end
end

--eggs

minetest.register_craftitem("cooking_fr:egg_fried", {
	description = "Fried Egg",
	inventory_image = "mobs_chicken_egg_fried.png",
	on_use = minetest.item_eat(3)
})
foodspoil_register("cooking_fr:egg_fried", fs_f)

minetest.register_craftitem("cooking_fr:egg_fried_salted", {
	description = "Salted Fried Egg",
	inventory_image = "mobs_chicken_egg_fried.png",
	on_use = minetest.item_eat(4),
	_cookingsimple = true
})
foodspoil_register("cooking_fr:egg_fried_salted", fs_f)

minetest.register_craftitem("cooking_fr:egg_scrambled_uncooked", {
	description = "Uncooked Scrambled Egg",
	inventory_image = "cooking_egg_scrambled_uncooked.png",
	_cookingsimple = true
})
foodspoil_register("cooking_fr:egg_scrambled_uncooked", fs_f)

minetest.register_craftitem("cooking_fr:egg_scrambled", {
	description = "Scrambled Egg",
	inventory_image = "cooking_egg_scrambled.png",
	on_use = minetest.item_eat(8)
})
foodspoil_register("cooking_fr:egg_scrambled", fs_f)

minetest.register_craftitem("cooking_fr:egg_scrambled_aromatics_uncooked", {
	description = "Uncooked Scrambled Egg Aromatics",
	inventory_image = "cooking_egg_scrambled_aromatics_uncooked.png",
})
foodspoil_register("cooking_fr:egg_scrambled_aromatics_uncooked", fs_f)

minetest.register_craftitem("cooking_fr:egg_scrambled_aromatics", {
	description = "Scrambled Egg Aromatics",
	inventory_image = "cooking_egg_scrambled_aromatics.png",
})
foodspoil_register("cooking_fr:egg_scrambled_aromatics", fs_f)

minetest.register_craftitem("cooking_fr:egg_scrambled_tasty_uncooked", {
	description = "Uncooked Tasty Scrambled Egg",
	inventory_image = "cooking_egg_scrambled_tasty_uncooked.png",
})
foodspoil_register("cooking_fr:egg_scrambled_tasty_uncooked", fs_f)

minetest.register_craftitem("cooking_fr:egg_scrambled_tasty", {
	description = "Tasty Scrambled Egg",
	inventory_image = "cooking_egg_scrambled_tasty.png",
	on_use = minetest.item_eat(12)
})
foodspoil_register("cooking_fr:egg_scrambled_tasty", fs_f)

cooking.register_craft({
	type = "stove",
	cooktime = 6,
	recipe = "mobs:egg",
	output = "cooking_fr:egg_fried"
})
cooking.register_craft({
	type = "mix",
	recipe = {"mobs:egg", "mobs:egg"},
	output = "cooking_fr:egg_scrambled_uncooked"
})
cooking.register_craft({
	type = "stack",
	recipe = {"cooking_fr:egg_fried", "farming:salt"},
	output = "cooking_fr:egg_fried_salted",
})
cooking.register_craft({
	type = "stove",
	cooktime = 6,
	recipe = "cooking_fr:egg_scrambled_uncooked",
	output = "cooking_fr:egg_scrambled"
})
cooking.register_craft({
	type = "mix",
	recipe = {"cooking_fr:onion_sliced", "cooking_fr:garlic_chopped", "cooking_fr:pepper_sliced", "farming:salt", "farming:peppercorn", "cooking_fr:butter"},
	output = "cooking_fr:egg_scrambled_aromatics_uncooked"
})
cooking.register_craft({
	type = "stove",
	cooktime = 6,
	recipe = "cooking_fr:egg_scrambled_aromatics_uncooked",
	output = "cooking_fr:egg_scrambled_aromatics"
})
cooking.register_craft({
	type = "mix",
	recipe = {"mobs:egg", "mobs:egg", "cooking_fr:egg_scrambled_aromatics"},
	output = "cooking_fr:egg_scrambled_tasty_uncooked"
})
cooking.register_craft({
	type = "stove",
	cooktime = 6,
	recipe = "cooking_fr:egg_scrambled_tasty_uncooked",
	output = "cooking_fr:egg_scrambled_tasty"
})

--garlic bread

minetest.register_craftitem("cooking_fr:garlic_bread_uncooked", {
	description = "Uncooked Garlic Bread",
	inventory_image = "cooking_garlic_bread_uncooked.png",
	on_use = minetest.item_eat(4)
})
foodspoil_register("cooking_fr:garlic_bread_uncooked", fs_m)

minetest.register_craftitem("cooking_fr:garlic_bread", {
	description = "Garlic Bread",
	inventory_image = "cooking_garlic_bread.png",
	on_use = minetest.item_eat(6)
})
foodspoil_register("cooking_fr:garlic_bread", fs_m)
cooking.register_craft({
	type = "stack",
	recipe = {"cooking:bread_sliced", "cooking_fr:butter", "cooking_fr:garlic_powder"},
	output = "cooking_fr:garlic_bread_uncooked"
})
cooking.register_craft({
	type = "oven",
	cooktime = 6,
	recipe = "cooking_fr:garlic_bread_uncooked",
	output = "cooking_fr:garlic_bread"
})

--coffee:
local coffeecup = "vessels:drinking_glass"
if not minetest.get_modpath("vessels") then
	minetest.register_craftitem("cooking_fr:coffee_cup", {
		description = "Coffee Cup",
		inventory_image = "farming_coffee_cup.png",
	})
	coffeecup = "cooking_fr:coffee_cup"
end
minetest.register_craftitem("cooking_fr:coffee_ground", {
    description = "Ground Coffee Beans",
    inventory_image = "cooking_coffee_ground.png",
})
foodspoil_register("cooking_fr:coffee_ground", fs_s)

minetest.register_craftitem("cooking_fr:coffee_uncooked", {
    description = "Cup of Uncooked Coffee",
	_soup_container = coffeecup,
	_soup_item = coffeecup,
    inventory_image = "farming_coffee_cup.png",
	param2 = 212,
	_cookingsimple = true
})
foodspoil_register("cooking_fr:coffee_uncooked", fs_f)

minetest.register_craftitem("cooking_fr:coffee", {
    description = "Cup of Coffee",
	_soup_container = coffeecup,
	param2 = 211,
    inventory_image = "farming_coffee_cup.png",
	on_use = minetest.item_eat(4, coffeecup)
})
foodspoil_register("cooking_fr:coffee", fs_f)

minetest.register_craftitem("cooking_fr:coffee_filter", {
    description = "Coffee Filter",
    inventory_image = "cooking_coffee_filter.png",
})
minetest.register_craft({
	recipe = {
		{"default:paper", "", "default:paper"},
		{"", "default:paper", ""}
	},
	output = "cooking_fr:coffee_filter 12"
})
cooking.register_craft({
	type = "press",
	recipe = "farming:coffee_beans",
	output = "cooking_fr:coffee_ground"
})
cooking.register_craft({
	type = "soup",
	param2 = 6,
	recipe = {"cooking_fr:coffee_filter", "cooking_fr:coffee_ground"},
	output = "cooking_fr:coffee_uncooked"
})
cooking.register_craft({
	type = "stove",
	cooktime = 6,
	recipe = "cooking_fr:coffee_uncooked",
	output = "cooking_fr:coffee"
})

--Pies

minetest.register_craftitem("cooking_fr:rhubarb_pie_uncooked", {
    description = "Uncooked Rhubarb Pie",
    inventory_image = "farming_rhubarb_pie.png",
})
foodspoil_register("cooking_fr:rhubarb_pie_uncooked", fs_m)

minetest.register_craftitem("cooking_fr:rhubarb_pie", {
    description = "Rhubarb Pie",
    inventory_image = "farming_rhubarb_pie.png",
	on_use = minetest.item_eat(10)
})
foodspoil_register("cooking_fr:rhubarb_pie", fs_m)

minetest.register_craftitem("cooking_fr:strawberry_pie_uncooked", {
    description = "Uncooked Strawberry Pie",
    inventory_image = "cooking_strawberry_pie_uncooked.png",
})
foodspoil_register("cooking_fr:strawberry_pie_uncooked", fs_m)

minetest.register_craftitem("cooking_fr:strawberry_pie", {
    description = "Strawberry Pie",
    inventory_image = "cooking_strawberry_pie.png",
	on_use = minetest.item_eat(10)
})
foodspoil_register("cooking_fr:strawberry_pie", fs_m)

minetest.register_craftitem("cooking_fr:pumpkin_pie_uncooked", {
    description = "Uncooked Pumpkin Pie",
    inventory_image = "cooking_pumpkin_pie_uncooked.png",
})
foodspoil_register("cooking_fr:pumpkin_pie_uncooked", fs_m)

minetest.register_craftitem("cooking_fr:pumpkin_pie", {
    description = "Pumpkin Pie",
    inventory_image = "cooking_pumpkin_pie.png",
	on_use = minetest.item_eat(10)
})
foodspoil_register("cooking_fr:pumpkin_pie", fs_m)
foodspoil_register("farming:pumpkin_slice", 60)

cooking.register_craft({
	type = "cut",
	recipe = "farming:pumpkin_8",
	output = "farming:pumpkin_slice 4"
})
cooking.register_craft({
	type = "cut",
	recipe = "farming:melon_8",
	output = "farming:melon_slice 4"
})

cooking.register_craft({
	type = "stack",
	recipe = {"cooking:pie_crust", "farming:rhubarb", "farming:rhubarb", "cooking:sugar", "cooking:pie_crust"},
	output = "cooking_fr:rhubarb_pie_uncooked"
})
cooking.register_craft({
	type = "oven",
	cooktime = 30,
	recipe = "cooking_fr:rhubarb_pie_uncooked",
	output = "cooking_fr:rhubarb_pie"
})
cooking.register_craft({
	type = "stack",
	recipe = {"cooking:pie_crust", "ethereal:strawberry", "ethereal:strawberry", "cooking:sugar", "cooking:pie_crust"},
	output = "cooking_fr:strawberry_pie_uncooked"
})
cooking.register_craft({
	type = "oven",
	cooktime = 30,
	recipe = "cooking_fr:strawberry_pie_uncooked",
	output = "cooking_fr:strawberry_pie"
})
cooking.register_craft({
	type = "stack",
	recipe = {"cooking:pie_crust", "farming:pumpkin_slice", "farming:pumpkin_slice", "cooking:sugar", "cooking:pie_crust"},
	output = "cooking_fr:pumpkin_pie_uncooked"
})
cooking.register_craft({
	type = "oven",
	cooktime = 30,
	recipe = "cooking_fr:pumpkin_pie_uncooked",
	output = "cooking_fr:pumpkin_pie"
})

--Donuts

minetest.register_craftitem("cooking_fr:donut_batter", {
    description = "Donut Batter",
    inventory_image = "cooking_donut_batter.png",
})
foodspoil_register("cooking_fr:donut_batter", fs_m)

minetest.register_craftitem("cooking_fr:donut", {
    description = "Donut",
    inventory_image = "farming_donut.png",
	on_use = minetest.item_eat(4)
})
foodspoil_register("cooking_fr:donut", fs_f)

minetest.register_craftitem("cooking_fr:donut_blueberry", {
    description = "Blueberry Donut",
    inventory_image = "cooking_donut_blueberry.png",
	on_use = minetest.item_eat(6)
})
foodspoil_register("cooking_fr:donut_blueberry", fs_f)

minetest.register_craftitem("cooking_fr:chocolate", {
    description = "Chocolate",
    inventory_image = "farming_chocolate_dark.png",
	on_use = minetest.item_eat(2)
})
foodspoil_register("cooking_fr:chocolate", fs_s)

minetest.register_craftitem("cooking_fr:donut_chocolate", {
    description = "Chocolate Donut",
    inventory_image = "farming_donut_chocolate.png",
	on_use = minetest.item_eat(6)
})
foodspoil_register("cooking_fr:donut_chocolate", fs_f)

minetest.register_craftitem("cooking_fr:donut_strawberry", {
    description = "Strawberry Donut",
    inventory_image = "farming_donut_apple.png",
	on_use = minetest.item_eat(6)
})
foodspoil_register("cooking_fr:donut_strawberry", fs_f)

minetest.register_craftitem("cooking_fr:strawberry_jam", {
    description = "Strawberry Jam",
    inventory_image = "cooking_strawberry_jam.png",
})
foodspoil_register("cooking_fr:strawberry_jam", fs_s)

minetest.register_craftitem("cooking_fr:bread_strawberry_jam", {
	description = "Bread with Strawberry Jam",
	inventory_image = "cooking_bread_strawberry_jam.png",
	on_use = minetest.item_eat(5),
	_cookingsimple = true
})
foodspoil_register("cooking_fr:bread_strawberry_jam", fs_s)

minetest.register_craftitem("cooking_fr:toast_strawberry_jam", {
	description = "Toast with Strawberry Jam",
	inventory_image = "cooking_toast_strawberry_jam.png",
	on_use = minetest.item_eat(6),
	_cookingsimple = true
})
foodspoil_register("cooking_fr:toast_strawberry_jam", fs_f)

cooking.register_craft({
	type = "stack",
	recipe = {"cooking:bread_sliced", "cooking_fr:strawberry_jam"},
	output = "cooking_fr:bread_strawberry_jam"
})
cooking.register_craft({
	type = "stack",
	recipe = {"cooking:toast", "cooking_fr:strawberry_jam"},
	output = "cooking_fr:toast_strawberry_jam"
})
minetest.register_craftitem("cooking_fr:donut_sugared", {
    description = "Sugared Donut",
    inventory_image = "cooking_donut_sugared.png",
	on_use = minetest.item_eat(6)
})
foodspoil_register("cooking_fr:donut_sugared", fs_f)

cooking.register_craft({
	type = "mix",
	recipe = {"farming:flour", "cooking:sugar", "mobs:egg", "mobs:bucket_milk", "cooking_fr:butter"},
	output = {"cooking_fr:donut_batter", "bucket:bucket_empty"}
})
cooking.register_craft({
	type = "oven",
	recipe = "cooking_fr:donut_batter",
	output = "cooking_fr:donut 4"
})
cooking.register_craft({
	type = "press",
	recipe = "ethereal:strawberry",
	output = "cooking_fr:strawberry_jam 4"
})
cooking.register_craft({
	type = "mix",
	recipe = {"farming:cocoa_beans", "farming:cocoa_beans", "cooking:sugar", "mobs:bucket_milk"},
	output = {"cooking_fr:chocolate 4", "bucket:bucket_empty"}
})
cooking.register_craft({
	type = "stack",
	recipe = {"cooking_fr:donut", "cooking:blueberry_jam"},
	output = "cooking_fr:donut_blueberry",
})
cooking.register_craft({
	type = "stack",
	recipe = {"cooking_fr:donut", "cooking_fr:strawberry_jam"},
	output = "cooking_fr:donut_strawberry",
})
cooking.register_craft({
	type = "stack",
	recipe = {"cooking_fr:donut", "cooking_fr:chocolate"},
	output = "cooking_fr:donut_chocolate",
})
cooking.register_craft({
	type = "stack",
	recipe = {"cooking_fr:donut", "cooking:sugar"},
	output = "cooking_fr:donut_sugared",
})

--stir fry
minetest.register_craftitem("cooking_fr:meat_chopped_uncooked", {
    description = "Uncooked Chopped Meat",
    inventory_image = "cooking_meat_chopped_uncooked.png",
})
foodspoil_register("cooking_fr:meat_chopped_uncooked", fs_m)

minetest.register_craftitem("cooking_fr:stir_fry_uncooked", {
    description = "Uncooked Stir Fry",
    inventory_image = "cooking_stir_fry_uncooked.png",
})
foodspoil_register("cooking_fr:stir_fry_uncooked", fs_m)

minetest.register_craftitem("cooking_fr:stir_fry", {
    description = "Stir Fry",
    inventory_image = "cooking_stir_fry.png",
	on_use = minetest.item_eat(15, "cooking:bowl")
})
foodspoil_register("cooking_fr:stir_fry", fs_m)

cooking.register_craft({
	type = "mix",
	recipe = {"cooking_fr:pepper_sliced", "cooking_fr:onion_sliced", "cooking_fr:garlic_chopped", "cooking_fr:butter", "cooking:sugar", "farming:salt", "farming:beans", "cooking_fr:rice", "cooking_fr:meat_chopped_uncooked"},
	output = "cooking_fr:stir_fry_uncooked"
})
cooking.register_craft({
	type = "cut",
	recipe = "mobs:meat_raw",
	output = "cooking_fr:meat_chopped_uncooked"
})
cooking.register_craft({
	type = "stove",
	cooktime = 10,
	recipe = "cooking_fr:stir_fry_uncooked",
	output = "cooking_fr:stir_fry"
})

--pasta

minetest.register_craftitem("cooking_fr:pasta_dough", {
    description = "Pasta Dough",
    inventory_image = "cooking_pasta_dough.png",
	_cookingsimple = true
})
foodspoil_register("cooking_fr:pasta_dough", fs_s)

minetest.register_craftitem("cooking_fr:noodles_uncooked", {
    description = "Uncooked Noodles",
    inventory_image = "cooking_noodles_uncooked.png",
})
foodspoil_register("cooking_fr:noodles_uncooked", fs_s)

minetest.register_craftitem("cooking_fr:noodles_uncooked_soup", {
    description = "Uncooked Noodles",
	param2 = 200,
	_soup_container = "cooking_fr:colander",
	_soup_item = "cooking_fr:noodles_uncooked",
    inventory_image = "cooking_noodles_uncooked.png",
	_cookingsimple = true
})
foodspoil_register("cooking_fr:noodles_uncooked_soup", fs_s)

minetest.register_craftitem("cooking_fr:noodles", {
    description = "Noodles",
	param2 = 23,
	_soup_container = "cooking_fr:colander",
    inventory_image = "cooking_noodles.png",
})
foodspoil_register("cooking_fr:noodles", fs_s)

minetest.register_craftitem("cooking_fr:lasagna_noodle_uncooked", {
    description = "Uncooked Lasagna Noodle",
    inventory_image = "cooking_lasagna_noodle_uncooked.png",
})
foodspoil_register("cooking_fr:lasagna_noodle_uncooked", fs_s)

cooking.register_craft({
	type = "mix",
	recipe = {"farming:flour", "mobs:egg"},
	output = "cooking_fr:pasta_dough",
	_cookingsimple = true
})
cooking.register_craft({
	type = "roll",
	recipe = "cooking_fr:pasta_dough",
	output = "cooking_fr:lasagna_noodle_uncooked 4"
})
cooking.register_craft({
	type = "press",
	recipe = "cooking_fr:pasta_dough",
	output = "cooking_fr:noodles_uncooked 4"
})
cooking.register_craft({
	type = "soup",
	recipe = {"cooking_fr:noodles_uncooked", "cooking_fr:noodles_uncooked"},
	output = "cooking_fr:noodles_uncooked_soup"
})
cooking.register_craft({
	type = "stove",
	cooktime = 10,
	recipe = "cooking_fr:noodles_uncooked_soup",
	output = "cooking_fr:noodles"
})
minetest.register_craftitem("cooking_fr:tomato_soup_uncooked", {
    description = "Uncooked Tomato Soup",
    inventory_image = "cooking_tomato_soup_uncooked.png",
	param2 = 252,
})
foodspoil_register("cooking_fr:tomato_soup_uncooked", fs_m)

minetest.register_craftitem("cooking_fr:tomato_soup", {
    description = "Tomato Soup",
    inventory_image = "cooking_tomato_soup.png",
	param2 = 9,
	on_use = minetest.item_eat(6, "cooking:bowl")
})
foodspoil_register("cooking_fr:tomato_soup", fs_m)

minetest.register_craftitem("cooking_fr:tomato_sauce", {
    description = "Tomato Sauce",
    inventory_image = "cooking_tomato_sauce.png",
	param2 = 3,
})
foodspoil_register("cooking_fr:tomato_sauce", fs_m)

minetest.register_craftitem("cooking_fr:alfredo_sauce_uncooked", {
    description = "Uncooked Alfredo Sauce",
    inventory_image = "cooking_alfredo_sauce_uncooked.png",
	param2 = 216,
})
foodspoil_register("cooking_fr:alfredo_sauce_uncooked", fs_m)

minetest.register_craftitem("cooking_fr:alfredo_sauce", {
    description = "Alfredo Sauce",
    inventory_image = "cooking_alfredo_sauce.png",
	param2 = 215,
	on_use = minetest.item_eat(6, "cooking:bowl")
})
foodspoil_register("cooking_fr:alfredo_sauce", fs_m)

cooking.register_craft({
	type = "soup",
	recipe = {"farming:tomato", "farming:tomato", "farming:salt", "cooking_fr:garlic_powder"},
	output = "cooking_fr:tomato_soup_uncooked"
})
cooking.register_craft({
	type = "stove",
	cooktime = 10,
	recipe = "cooking_fr:tomato_soup_uncooked",
	output = "cooking_fr:tomato_soup"
})
cooking.register_craft({
	type = "stove",
	cooktime = 10,
	recipe = "cooking_fr:tomato_soup",
	output = "cooking_fr:tomato_sauce"
})
cooking.register_craft({
	type = "soup",
	recipe = {"cooking_fr:cheese", "cooking_fr:butter", "farming:salt", "mobs:bucket_milk"},
	output = {"cooking_fr:alfredo_sauce_uncooked", "bucket:bucket_empty"}--todo make milk based soups
})
cooking.register_craft({
	type = "stove",
	cooktime = 10,
	recipe = "cooking_fr:alfredo_sauce_uncooked",
	output = "cooking_fr:alfredo_sauce"
})

minetest.register_craftitem("cooking_fr:breadcrumbs", {
    description = "Breadcrumbs",
    inventory_image = "cooking_breadcrumbs.png",
})
foodspoil_register("cooking_fr:breadcrumbs", fs_m)

minetest.register_craftitem("cooking_fr:meatballs_uncooked", {
    description = "Uncooked Meatballs",
    inventory_image = "cooking_meatballs_uncooked.png",
})
foodspoil_register("cooking_fr:meatballs_uncooked", fs_m)

minetest.register_craftitem("cooking_fr:meatballs", {
    description = "Meatballs",
    inventory_image = "cooking_meatballs.png",
})
foodspoil_register("cooking_fr:meatballs", fs_m)

minetest.register_craftitem("cooking_fr:spaghetti", {
    description = "Spaghetti",
    inventory_image = "cooking_spaghetti.png",
	on_use = minetest.item_eat(15, "cooking:bowl")
})
foodspoil_register("cooking_fr:spaghetti", fs_m)

cooking.register_craft({
	type = "press",
	recipe = "farming:bread",
	output = "cooking_fr:breadcrumbs 8"
})
cooking.register_craft({
	type = "mix",
	recipe = {"cooking_fr:breadcrumbs", "cooking_fr:ground_beef_uncooked", "farming:peppercorn", "cooking_fr:onion_sliced"},
	output = "cooking_fr:meatballs_uncooked"
})
cooking.register_craft({
	type = "stove",
	cooktime = 10,
	recipe = "cooking_fr:meatballs_uncooked",
	output = "cooking_fr:meatballs"
})
cooking.register_craft({
	type = "mix",
	recipe = {"cooking_fr:meatballs", "cooking_fr:noodles", "cooking_fr:tomato_sauce"},
	output = {"cooking_fr:spaghetti", "cooking:bowl"}
})

minetest.register_craftitem("cooking_fr:lasagna_uncooked", {
    description = "Uncooked Lasagna",
    inventory_image = "cooking_lasagna_uncooked.png",
})
foodspoil_register("cooking_fr:lasagna_uncooked", fs_m)

minetest.register_craftitem("cooking_fr:lasagna", {
    description = "Lasagna",
    inventory_image = "cooking_lasagna.png",
})
foodspoil_register("cooking_fr:lasagna", fs_m)

cooking.register_craft({
	type = "stack",
	recipe = {"cooking_fr:lasagna_noodle_uncooked", "cooking_fr:tomato_sauce", "cooking_fr:ground_beef_uncooked", "cooking_fr:cheese", "cooking_fr:lasagna_noodle_uncooked", "cooking_fr:cheese"},
	output = {"cooking_fr:lasagna_uncooked", "cooking:bowl"}
})
cooking.register_craft({
	type = "oven",
	cooktime = 10,
	recipe = "cooking_fr:lasagna_uncooked",
	output = "cooking_fr:lasagna"
})

minetest.register_craftitem("cooking_fr:chicken_alfredo", {
    description = "Chicken Alfredo",
    inventory_image = "cooking_chicken_alfredo.png",
	on_use = minetest.item_eat(15, "cooking:bowl")
})
foodspoil_register("cooking_fr:chicken_alfredo", fs_m)

minetest.register_craftitem("cooking_fr:chicken_chopped_uncooked", {
    description = "Uncooked Chopped Chicken",
    inventory_image = "cooking_chicken_chopped_uncooked.png",
})
foodspoil_register("cooking_fr:chicken_chopped_uncooked", fs_s)

minetest.register_craftitem("cooking_fr:chicken_chopped", {
    description = "Chopped Chicken",
    inventory_image = "cooking_chicken_chopped.png",
})
foodspoil_register("cooking_fr:chicken_chopped", fs_m)

cooking.register_craft({
	type = "cut",
	recipe = "mobs:chicken_raw",
	output = "cooking_fr:chicken_chopped_uncooked"
})
cooking.register_craft({
	type = "stove",
	cooktime = 10,
	recipe = "cooking_fr:chicken_chopped_uncooked",
	output = "cooking_fr:chicken_chopped"
})
cooking.register_craft({
	type = "mix",
	recipe = {"cooking_fr:chicken_chopped", "cooking_fr:noodles", "cooking_fr:alfredo_sauce"},
	output = {"cooking_fr:chicken_alfredo", "cooking:bowl"}
})

--soups/stews

minetest.register_craftitem("cooking_fr:chicken_noodle_soup_uncooked", {
    description = "Uncooked Chicken Noodle Soup",
    inventory_image = "cooking_chicken_noodle_soup_uncooked.png",
	param2 = 216,
	on_use = minetest.item_eat(-2, "cooking:bowl")
})
foodspoil_register("cooking_fr:chicken_noodle_soup_uncooked", fs_m)

minetest.register_craftitem("cooking_fr:chicken_noodle_soup", {
    description = "Chicken Noodle Soup",
    inventory_image = "cooking_chicken_noodle_soup.png",
	param2 = 215,
	on_use = minetest.item_eat(12, "cooking:bowl")
})
foodspoil_register("cooking_fr:chicken_noodle_soup", fs_m)

minetest.register_craftitem("cooking_fr:carrot_chopped", {
    description = "Chopped Carrot",
    inventory_image = "cooking_carrot_chopped.png",
})
foodspoil_register("cooking_fr:carrot_chopped", fs_m)

cooking.register_craft({
	type = "cut",
	recipe = "farming:carrot",
	output = "cooking_fr:carrot_chopped"
})
cooking.register_craft({
	type = "soup",
	recipe = {"cooking_fr:chicken_chopped_uncooked", "cooking_fr:noodles_uncooked", "farming:salt", "cooking_fr:carrot_chopped", "cooking_fr:garlic_powder"},
	output = {"cooking_fr:chicken_noodle_soup_uncooked"}
})
cooking.register_craft({
	type = "stove",
	cooktime = 10,
	recipe = "cooking_fr:chicken_noodle_soup_uncooked",
	output = "cooking_fr:chicken_noodle_soup"
})
minetest.register_craftitem("cooking_fr:beef_potato_stew_uncooked", {
    description = "Uncooked Beef Potato Stew",
    inventory_image = "cooking_beef_potato_stew_uncooked.png",
	param2 = 211,
	on_use = minetest.item_eat(-2, "cooking:bowl")
})
foodspoil_register("cooking_fr:beef_potato_stew_uncooked", fs_m)

minetest.register_craftitem("cooking_fr:beef_potato_stew", {
    description = "Beef Potato Stew",
    inventory_image = "cooking_beef_potato_stew.png",
	param2 = 212,
	on_use = minetest.item_eat(12, "cooking:bowl")
})
foodspoil_register("cooking_fr:beef_potato_stew", fs_m)

cooking.register_craft({
	type = "soup",
	recipe = {"cooking_fr:meat_chopped_uncooked", "cooking_fr:potato_chopped", "farming:salt", "cooking_fr:carrot_chopped", "cooking_fr:garlic_powder", "cooking_fr:onion_sliced"},
	output = {"cooking_fr:beef_potato_stew_uncooked"}
})
cooking.register_craft({
	type = "stove",
	cooktime = 10,
	recipe = "cooking_fr:beef_potato_stew_uncooked",
	output = "cooking_fr:beef_potato_stew"
})
minetest.register_craftitem("cooking_fr:cheese_fish_soup_uncooked", {
    description = "Uncooked Cheesy Fish Soup",
    inventory_image = "cooking_cheese_fish_soup_uncooked.png",
	param2 = 224,
	on_use = minetest.item_eat(-2, "cooking:bowl")
})
foodspoil_register("cooking_fr:cheese_fish_soup_uncooked", fs_m)

minetest.register_craftitem("cooking_fr:cheese_fish_soup", {
    description = "Cheesy Fish Soup",
    inventory_image = "cooking_cheese_fish_soup.png",
	param2 = 225,
	on_use = minetest.item_eat(12, "cooking:bowl")
})
foodspoil_register("cooking_fr:cheese_fish_soup", fs_m)

cooking.register_craft({
	type = "soup",
	recipe = {"fishing:fish_raw", "cooking_fr:cheese", "farming:salt", "cooking_fr:carrot_chopped", "cooking_fr:garlic_powder", "cooking_fr:onion_sliced"},
	output = {"cooking_fr:cheese_fish_soup_uncooked"}
})
cooking.register_craft({
	type = "stove",
	cooktime = 10,
	recipe = "cooking_fr:cheese_fish_soup_uncooked",
	output = "cooking_fr:cheese_fish_soup"
})

--beef and chicken burritos
minetest.register_craftitem("cooking_fr:cheese_shredded", {
    description = "Shredded Cheese",
    inventory_image = "cooking_cheese_shredded.png",
})
foodspoil_register("cooking_fr:cheese_shredded", fs_m)

minetest.register_craftitem("cooking_fr:tortilla", {
    description = "Tortilla",
    inventory_image = "cooking_tortilla.png",
})
foodspoil_register("cooking_fr:tortilla", fs_m)

minetest.register_craftitem("cooking_fr:burrito_beef", {
    description = "Beef Burrito",
    inventory_image = "cooking_burrito_beef.png",
	on_use = minetest.item_eat(12)
})
foodspoil_register("cooking_fr:burrito_beef", fs_m)

minetest.register_craftitem("cooking_fr:burrito_chicken", {
    description = "Chicken Burrito",
    inventory_image = "cooking_burrito_chicken.png",
    on_use = minetest.item_eat(12)
})
foodspoil_register("cooking_fr:burrito_chicken", fs_m)

minetest.register_craftitem("cooking_fr:meat_chopped", {
    description = "Chopped Meat",
    inventory_image = "cooking_meat_chopped.png",
})
foodspoil_register("cooking_fr:meat_chopped", fs_m)

cooking.register_craft({
	type = "press",
	recipe = {"cooking_fr:cheese"},
	output = {"cooking_fr:cheese_shredded 8"}
})
cooking.register_craft({
	type = "stove",
	cooktime = 10,
	recipe = {"cooking_fr:meat_chopped_uncooked"},
	output = {"cooking_fr:meat_chopped"}
})
cooking.register_craft({
	type = "stove",
	cooktime = 4,
	recipe = {"cooking:pie_crust"},
	output = {"cooking_fr:tortilla"}
})
cooking.register_craft({
	type = "stack",
	recipe = {"cooking_fr:tortilla", "cooking_fr:chicken_chopped", "cooking_fr:onion_sliced", "cooking_fr:tomato_sliced", "cooking_fr:pepper_sliced", "cooking_fr:cheese_shredded"},
	output = {"cooking_fr:burrito_chicken"}
})
cooking.register_craft({
	type = "stack",
	recipe = {"cooking_fr:tortilla", "cooking_fr:meat_chopped", "cooking_fr:onion_sliced", "cooking_fr:tomato_sliced", "cooking_fr:pepper_sliced", "cooking_fr:cheese_shredded"},
	output = {"cooking_fr:burrito_beef"}
})

--Pizza
minetest.register_craftitem("cooking_fr:pepperoni", {
    description = "Pepperoni",
    inventory_image = "jelys_pizzaria_meat_pepperoni_cured_inv.png",
})
foodspoil_register("cooking_fr:pepperoni", fs_s)

minetest.register_craftitem("cooking_fr:pepperoni_sliced", {
    description = "Sliced Pepperoni",
    inventory_image = "cooking_pepperoni_sliced.png",
})
foodspoil_register("cooking_fr:pepperoni_sliced", fs_m)

cooking.register_craft({
	type = "mix",
	recipe = {"cooking_fr:ground_beef", "farming:salt", "cooking_fr:garlic_powder", "farming:peppercorn"},
	output = {"cooking_fr:pepperoni"}
})
cooking.register_craft({
	type = "cut",
	recipe = {"cooking_fr:pepperoni"},
	output = {"cooking_fr:pepperoni_sliced 4"}
})
minetest.register_craftitem("cooking_fr:mushroom_chopped", {
    description = "Chopped Mushroom",
    inventory_image = "cooking_mushroom_chopped.png",
})
cooking.register_craft({
	type = "cut",
	recipe = {"flowers:mushroom_brown"},
	output = {"cooking_fr:mushroom_chopped"}
})
for pizzaname, pizzadef in pairs({
	cheese = {name = "Cheese Pizza", recipe = {"cooking:pie_crust", "cooking_fr:tomato_sauce", "cooking_fr:cheese_shredded", "cooking_fr:cheese_shredded"}},
	hamburger = {name = "Hamburger Pizza", recipe = {"cooking:pie_crust", "cooking_fr:tomato_sauce", "cooking_fr:cheese_shredded", "cooking_fr:cheese_shredded", "cooking_fr:ground_beef_uncooked"}},
	chicken = {name = "Chicken Pizza", recipe = {"cooking:pie_crust", "cooking_fr:alfredo_sauce_uncooked", "cooking_fr:cheese_shredded", "cooking_fr:cheese_shredded", "cooking_fr:onion_sliced", "cooking_fr:pepper_sliced", "cooking_fr:chicken_chopped_uncooked"}},
	mushroom = {name = "Mushroom Pizza", recipe = {"cooking:pie_crust", "cooking_fr:alfredo_sauce_uncooked", "cooking_fr:cheese_shredded", "cooking_fr:cheese_shredded", "cooking_fr:onion_sliced", "cooking_fr:pepper_sliced", "cooking_fr:mushroom_chopped"}},
	pepperoni = {name = "Pepperoni Pizza", recipe = {"cooking:pie_crust", "cooking_fr:tomato_sauce", "cooking_fr:cheese_shredded", "cooking_fr:cheese_shredded", "cooking_fr:pepperoni_sliced"}},
	supreme = {name = "Supreme Pizza", recipe = {"cooking:pie_crust", "cooking_fr:tomato_sauce", "cooking_fr:cheese_shredded", "cooking_fr:cheese_shredded", "cooking_fr:onion_sliced", "cooking_fr:pepper_sliced", "cooking_fr:mushroom_chopped", "cooking_fr:pepperoni_sliced", "cooking_fr:ground_beef_uncooked"}},
}) do
	local tex1 = "jelys_pizzaria_pizza_dough.png"
	local tex2 = "jelys_pizzaria_cooked_dough.png"
	local hascheese = false
	local sat = 4
	for i, item in pairs(pizzadef.recipe) do
		local itemtbl = {
			["cooking_fr:tomato_sauce"] = "jelys_pizzaria_pizza_sauce.png",
			["cooking_fr:cheese_shredded"] = "jelys_pizzaria_pizza_cheese.png",
			["cooking_fr:mushroom_chopped"] = "jelys_pizzaria_topping_mushrooms.png",
			["cooking_fr:pepperoni_sliced"] = "jelys_pizzaria_topping_pepperoni.png",
			["cooking_fr:ground_beef_uncooked"] = "jelys_pizzaria_topping_sausage.png",
			["cooking_fr:chicken_chopped_uncooked"] = "jelys_pizzaria_topping_chicken.png",
			["cooking_fr:onion_sliced"] = "jelys_pizzaria_topping_onion.png",
			["cooking_fr:pepper_sliced"] = "jelys_pizzaria_topping_pepper.png",
			["cooking_fr:alfredo_sauce_uncooked"] = "jelys_pizzaria_pizza_alfredo_sauce.png",
		}
		local cooked_itemtbl = {
			["cooking_fr:tomato_sauce"] = "jelys_pizzaria_pizza_cooked_sauce.png",
			["cooking_fr:cheese_shredded"] = "jelys_pizzaria_pizza_cooked_cheese.png",
			["cooking_fr:mushroom_chopped"] = "jelys_pizzaria_topping_mushrooms_cooked.png",
			["cooking_fr:pepperoni_sliced"] = "jelys_pizzaria_topping_pepperoni_cooked.png",
			["cooking_fr:ground_beef_uncooked"] = "jelys_pizzaria_topping_sausage_cooked.png",
			["cooking_fr:chicken_chopped_uncooked"] = "jelys_pizzaria_topping_chicken_cooked.png",
			["cooking_fr:onion_sliced"] = "jelys_pizzaria_topping_onion_cooked.png",
			["cooking_fr:pepper_sliced"] = "jelys_pizzaria_topping_pepper_cooked.png",
			["cooking_fr:alfredo_sauce_uncooked"] = "jelys_pizzaria_pizza_alfredo_sauce_cooked.png",
		}
		local sattbl = {
			["cooking_fr:tomato_sauce"] = 3,
			["cooking_fr:cheese_shredded"] = 2,
			["cooking_fr:mushroom_chopped"] = 2,
			["cooking_fr:pepperoni_sliced"] = 4,
			["cooking_fr:ground_beef_uncooked"] = 4,
			["cooking_fr:chicken_chopped_uncooked"] = 4,
			["cooking_fr:onion_sliced"] = 2,
			["cooking_fr:pepper_sliced"] = 2,
			["cooking_fr:alfredo_sauce_uncooked"] = 2,
		}
		sat = sat + (sattbl[item] or 0)
		if item == "cooking_fr:cheese_shredded" then
			if not hascheese then
				hascheese = true
				tex1 = tex1.."^"..itemtbl[item]
				tex2 = tex2.."^"..cooked_itemtbl[item]
			end
		elseif itemtbl[item] then
			tex1 = tex1.."^"..itemtbl[item]
			tex2 = tex2.."^"..cooked_itemtbl[item]
		else
			minetest.log("warning", "[cooking_fr] no texture for pizza ingredient '"..item.."'")
		end
	end
	minetest.register_craftitem("cooking_fr:pizza_"..pizzaname.."_uncooked", {
		description = "Uncooked "..pizzadef.name,
		inventory_image = tex1,
	})
	foodspoil_register("cooking_fr:pizza_"..pizzaname.."_uncooked", fs_m)
	minetest.register_craftitem("cooking_fr:pizza_"..pizzaname, {
		description = pizzadef.name,
		inventory_image = tex2,
		on_use = minetest.item_eat(sat)
	})
	foodspoil_register("cooking_fr:pizza_"..pizzaname, fs_m)
	cooking.register_craft({
		type = "stack",
		recipe = pizzadef.recipe,
		output = {"cooking_fr:pizza_"..pizzaname.."_uncooked", "cooking:bowl"}
	})
	cooking.register_craft({
		type = "oven",
		cooktime = 10,
		recipe = {"cooking_fr:pizza_"..pizzaname.."_uncooked"},
		output = {"cooking_fr:pizza_"..pizzaname}
	})
end

-- Majo: 

--popcorn:
minetest.register_craftitem("cooking_fr:corn_kernels", {
    description = "Corn Kernels",
    inventory_image = "cooking_corn_kernels.png",
})
foodspoil_register("cooking_fr:corn_kernels", fs_s)

minetest.register_craftitem("cooking_fr:unflavored_popcorn", {
    description = "Unflavored Popcorn",
    inventory_image = "cooking_popcorn.png",
	on_use = minetest.item_eat(3)
})
foodspoil_register("cooking_fr:unflavored_popcorn", fs_f)

minetest.register_craftitem("cooking_fr:popcorn_salted", {
    description = "Salted Popcorn",
    inventory_image = "cooking_popcorn.png",
	on_use = minetest.item_eat(4),
	_cookingsimple = true
})
foodspoil_register("cooking_fr:popcorn_salted", fs_f)

minetest.register_craftitem("cooking_fr:popcorn_sugared", {
    description = "Sugared Popcorn",
    inventory_image = "cooking_popcorn.png",
	on_use = minetest.item_eat(4),
	_cookingsimple = true
})
foodspoil_register("cooking_fr:popcorn_sugared", fs_f)

cooking.register_craft({
    type = "cut",
    recipe = "farming:corn",
    output = {"cooking_fr:corn_kernels"}
})

cooking.register_craft({
    type = "stove",
    recipe = "cooking_fr:corn_kernels",
	cooktime = 10,
    output = {"cooking_fr:unflavored_popcorn"}
})

cooking.register_craft({
    type = "mix",
    recipe = {"cooking_fr:unflavored_popcorn", "cooking:sugar"},
    output = {"cooking_fr:popcorn_sugared"},
})

cooking.register_craft({
    type = "mix",
    recipe = {"cooking_fr:unflavored_popcorn", "farming:salt"},
    output = {"cooking_fr:popcorn_salted"},
})

if minetest.get_modpath("cake") then
	minetest.clear_craft({output = "cake:cake_uncooked"})
	--todo make cake work with cooking and foodspoil
end

dofile(minetest.get_modpath("cooking_fr").."/farming_clear_crafts.lua")
