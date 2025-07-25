/datum/job/chaplain
	title = "Chaplain"
	flag = CHAPLAIN
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"

	outfit = /datum/outfit/job/chaplain
	plasma_outfit = /datum/outfit/plasmaman/chaplain

	access = list(ACCESS_MORGUE, ACCESS_CHAPEL_OFFICE, ACCESS_CREMATORIUM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_MORGUE, ACCESS_CHAPEL_OFFICE, ACCESS_CREMATORIUM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_CIV

	display_order = JOB_DISPLAY_ORDER_CHAPLAIN
	departments = DEPARTMENT_BITFLAG_SERVICE
	threat = 0.5

	family_heirlooms = list(
		/obj/item/toy/windupToolbox,
		/obj/item/reagent_containers/food/drinks/bottle/holywater
	)

	mail_goodies = list(
		/obj/item/reagent_containers/food/drinks/bottle/holywater = 30,
		/obj/item/toy/plush/awakenedplushie = 10,
		/obj/item/grenade/chem_grenade/holy = 5,
		/obj/item/toy/plush/narplush = 2,
//		/obj/item/toy/plush/ratplush = 1
	)

/datum/job/chaplain/after_spawn(mob/living/H, client/C)
	. = ..()
	if(H.mind)
		H.mind.isholy = TRUE
		ADD_TRAIT(H.mind, TRAIT_ANTIMAGIC_NO_SELFBLOCK, JOB_TRAIT) // BLUEMOON ADD trait system

	var/obj/item/storage/book/bible/booze/B = new

	if(GLOB.religion)
		/*
		/*
		B.deity_name = GLOB.deity
		B.name = GLOB.bible_name
		B.icon_state = GLOB.bible_icon_state
		B.item_state = GLOB.bible_item_state
		to_chat(H, "There is already an established religion onboard the station. You are an acolyte of [GLOB.deity]. Defer to the Chaplain.")
		*/
		H.equip_to_slot_or_del(/obj/item/storage/book/bible/booze, ITEM_SLOT_BACKPACK) // бибиля + нуллрод вторым и далее священикам
		H.equip_to_slot_or_del(/obj/item/nullrod, ITEM_SLOT_BACKPACK)
		*/
		H.equip_to_slot_or_del(/obj/item/storage/book/bible/booze, ITEM_SLOT_BACKPACK) // бибиля + нуллрод вторым и далее священикам
		H.equip_to_slot_or_del(/obj/item/nullrod, ITEM_SLOT_BACKPACK)
		return

	var/new_religion = DEFAULT_RELIGION
	if(C && C.prefs.custom_names["religion"])
		new_religion = C.prefs.custom_names["religion"]

	var/new_deity = DEFAULT_DEITY
	if(C && C.prefs.custom_names["deity"])
		new_deity = C.prefs.custom_names["deity"]

	B.deity_name = new_deity


	switch(lowertext(new_religion))
		if("christianity") // DEFAULT_RELIGION
			B.name = pick("The Holy Bible","The Dead Sea Scrolls")
		if("buddhism")
			B.name = "The Sutras"
		if("clownism","honkmother","honk","honkism","comedy")
			B.name = pick("The Holy Joke Book", "Just a Prank", "Hymns to the Honkmother")
		if("chaos")
			B.name = "The Book of Lorgar"
		if("cthulhu")
			B.name = "The Necronomicon"
		if("hinduism")
			B.name = "The Vedas"
		if("homosexuality")
			B.name = pick("Guys Gone Wild","Coming Out of The Closet")
		if("imperium")
			B.name = "Uplifting Primer"
		if("islam")
			B.name = "Quran"
		if("judaism")
			B.name = "The Torah"
		if("lampism")
			B.name = "Fluorescent Incandescence"
		if("lol", "wtf", "gay", "penis", "ass", "poo", "badmin", "shitmin", "deadmin", "cock", "cocks", "meme", "memes")
			B.name = pick("Woodys Got Wood: The Aftermath", "War of the Cocks", "Sweet Bro and Hella Jef: Expanded Edition","F.A.T.A.L. Rulebook")
			H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 100) // starts off dumb as fuck
		if("monkeyism","apism","gorillism","primatism")
			B.name = pick("Going Bananas", "Bananas Out For Harambe")
		if("mormonism")
			B.name = "The Book of Mormon"
		if("pastafarianism")
			B.name = "The Gospel of the Flying Spaghetti Monster"
		if("rastafarianism","rasta")
			B.name = "The Holy Piby"
		if("satanism")
			B.name = "The Unholy Bible"
		if("science")
			B.name = pick("Principle of Relativity", "Quantum Enigma: Physics Encounters Consciousness", "Programming the Universe", "Quantum Physics and Theology", "String Theory for Dummies", "How To: Build Your Own Warp Drive", "The Mysteries of Bluespace", "Playing God: Collector's Edition")
		if("scientology")
			B.name = pick("The Biography of L. Ron Hubbard","Dianetics")
		if("servicianism", "partying")
			B.name = "The Tenets of Servicia"
			B.deity_name = pick("Servicia", "Space Bacchus", "Space Dionysus")
			B.desc = "Happy, Full, Clean. Live it and give it."
		if("subgenius")
			B.name = "Book of the SubGenius"
		if("toolboxia","greytide")
			B.name = pick("Toolbox Manifesto","iGlove Assistants")
		if("weeaboo","kawaii")
			B.name = pick("Fanfiction Compendium","Japanese for Dummies","The Manganomicon","Establishing Your O.T.P")
		else
			B.name = "[new_religion]"

	GLOB.religion = new_religion
	GLOB.bible_name = B.name
	GLOB.deity = B.deity_name

	H.equip_to_slot_or_del(B, ITEM_SLOT_BACKPACK)

	SSblackbox.record_feedback("text", "religion_name", 1, "[new_religion]", 1)
	SSblackbox.record_feedback("text", "religion_deity", 1, "[new_deity]", 1)

/datum/outfit/job/chaplain
	name = "Chaplain"
	jobtype = /datum/job/chaplain

	belt = /obj/item/pda/chaplain
	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/civilian/chaplain
	backpack_contents = list(/obj/item/storage/briefcase/crafted/chap_stuff = 1,
							/obj/item/stamp/chap = 1,
							)
	backpack = /obj/item/storage/backpack/cultpack
	accessory = /obj/item/clothing/accessory/permit/special/chaplain
	satchel = /obj/item/storage/backpack/cultpack

/datum/outfit/job/chaplain/syndicate
	name = "Syndicate Chaplain"
	jobtype = /datum/job/chaplain

	//belt = /obj/item/pda/syndicate/no_deto

	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/civilian/util
	shoes = /obj/item/clothing/shoes/jackboots/tall_default

	backpack = /obj/item/storage/backpack/duffelbag/syndie
	satchel = /obj/item/storage/backpack/duffelbag/syndie
	duffelbag = /obj/item/storage/backpack/duffelbag/syndie
	box = /obj/item/storage/box/survival/syndie
	pda_slot = ITEM_SLOT_BELT
	accessory = /obj/item/clothing/accessory/permit/special/chaplain
	backpack_contents = list(/obj/item/storage/briefcase/crafted/chap_stuff = 1,
							/obj/item/stamp/chap = 1,
							/obj/item/syndicate_uplink=1,
							)
/obj/item/storage/briefcase/crafted/chap_stuff
	name = "\improper Chaplain Case"
	desc = "A storage case full of holy stuff."
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/briefcase/crafted/chap_stuff/PopulateContents()
	new /obj/item/camera/spooky(src)
	new /obj/item/choice_beacon/holy(src)
	new /obj/item/reagent_containers/censer(src)
	new /obj/item/choice_beacon/box/fetish(src)
