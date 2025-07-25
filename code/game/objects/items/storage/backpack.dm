/* Backpacks
 * Contains:
 *		Backpack
 *		Backpack Types
 *		Satchel Types
 */

/*
 * Backpack
 */

/obj/item/storage/backpack
	name = "backpack"
	desc = "You wear this on your back and put items into it."
	icon_state = "backpack"
	item_state = "backpack"
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK	//ERROOOOO
	resistance_flags = NONE
	max_integrity = 300

/obj/item/storage/backpack/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.storage_flags = STORAGE_FLAGS_VOLUME_DEFAULT
	STR.max_volume = STORAGE_VOLUME_BACKPACK
	STR.max_w_class = MAX_WEIGHT_CLASS_BACKPACK

/*
 * Backpack Types
 */

/obj/item/storage/backpack/old/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 12

/obj/item/storage/backpack/holding
	name = "bag of holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	icon_state = "holdingpack"
	item_state = "holdingpack"
	resistance_flags = FIRE_PROOF
	item_flags = NO_MAT_REDEMPTION
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 60, ACID = 50)
	component_type = /datum/component/storage/concrete/bluespace/bag_of_holding
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE

/obj/item/storage/backpack/holding/satchel
	name = "satchel of holding"
	desc = "A satchel that opens into a localized pocket of Blue Space."
	icon_state = "holdingsat"
	item_state = "holdingsat"

/obj/item/storage/backpack/holding/duffel
	name = "duffel bag of holding"
	desc = "A duffel bag that opens into a localized pocket of Blue Space."
	icon_state = "holdingduffel"
	item_state = "holdingduffel"

/obj/item/storage/backpack/holding/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = MAX_WEIGHT_CLASS_BAG_OF_HOLDING
	STR.storage_flags = STORAGE_FLAGS_VOLUME_DEFAULT
	STR.max_volume = STORAGE_VOLUME_BAG_OF_HOLDING

/obj/item/storage/backpack/holding/suicide_act(mob/living/user)
	user.visible_message("<span class='suicide'>[user] is jumping into [src]! It looks like [user.p_theyre()] trying to commit suicide.</span>")
	user.dropItemToGround(src, TRUE)
	user.Stun(100, ignore_canstun = TRUE)
	sleep(20)
	playsound(src, "rustle", 50, 1, -5)
	qdel(user)
	return

/obj/item/storage/backpack/holding/singularity_act(current_size)
	var/dist = max((current_size - 2),1)
	explosion(src.loc,(dist),(dist*2),(dist*4))
	return

/obj/item/storage/backpack/santabag
	name = "Santa's Gift Bag"
	desc = "Space Santa uses this to deliver toys to all the nice children in space in Christmas! Wow, it's pretty big!"
	icon_state = "giftbag0"
	item_state = "giftbag"
	w_class = WEIGHT_CLASS_BULKY
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE

/obj/item/storage/backpack/santabag/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 60

/obj/item/storage/backpack/santabag/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] places [src] over [user.ru_ego()] head and pulls it tight! It looks like [user.ru_who()] [user.p_are()]n't in the Christmas spirit...</span>")
	return (OXYLOSS)

/obj/item/storage/backpack/cultpack
	name = "trophy rack"
	desc = "It's useful for both carrying extra gear and proudly declaring your insanity."
	icon_state = "cultpack"
	item_state = "backpack"

/obj/item/storage/backpack/clown
	name = "Giggles von Honkerton"
	desc = "It's a backpack made by Honk! Co."
	icon_state = "clownpack"
	item_state = "clownpack"

/obj/item/storage/backpack/explorer
	name = "explorer bag"
	desc = "A robust backpack for stashing your loot."
	icon_state = "explorerpack"
	item_state = "explorerpack"

/obj/item/storage/backpack/mime
	name = "Parcel Parceaux"
	desc = "A silent backpack made for those silent workers. Silence Co."
	icon_state = "mimepack"
	item_state = "mimepack"

/obj/item/storage/backpack/medic
	name = "medical backpack"
	desc = "It's a backpack especially designed for use in a sterile environment."
	icon_state = "medicalpack"
	item_state = "medicalpack"

/obj/item/storage/backpack/security
	name = "security backpack"
	desc = "It's a very robust backpack."
	icon_state = "securitypack"
	item_state = "securitypack"

/obj/item/storage/backpack/captain
	name = "captain's backpack"
	desc = "It's a special backpack made exclusively for Nanotrasen officers."
	icon_state = "captainpack"
	item_state = "captainpack"
	resistance_flags = FIRE_PROOF
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE

/obj/item/storage/backpack/industrial
	name = "industrial backpack"
	desc = "It's a tough backpack for the daily grind of station life."
	icon_state = "engiepack"
	item_state = "engiepack"
	resistance_flags = FIRE_PROOF
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE

/obj/item/storage/backpack/atmospheric
	name = "atmospheric backpack"
	desc = "It's a backpack made of fire resistant fibers. Smells like plasma."
	icon_state = "atmospack"
	item_state = "atmospack"
	resistance_flags = FIRE_PROOF
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE

/obj/item/storage/backpack/botany
	name = "botany backpack"
	desc = "It's a backpack made of all-natural fibers."
	icon_state = "botpack"
	item_state = "botpack"

/obj/item/storage/backpack/chemistry
	name = "chemistry backpack"
	desc = "A backpack specially designed to repel stains and hazardous liquids."
	icon_state = "chempack"
	item_state = "chempack"

/obj/item/storage/backpack/genetics
	name = "genetics backpack"
	desc = "A bag designed to be super tough, just in case someone hulks out on you."
	icon_state = "genepack"
	item_state = "genepack"

/obj/item/storage/backpack/science
	name = "science backpack"
	desc = "A specially designed backpack. It's fire resistant and smells vaguely of plasma."
	icon_state = "toxpack"
	item_state = "toxpack"

/obj/item/storage/backpack/virology
	name = "virology backpack"
	desc = "A backpack made of hypo-allergenic fibers. It's designed to help prevent the spread of disease. Smells like monkey."
	icon_state = "viropack"
	item_state = "viropack"

/*
 * Satchel Types
 */

/obj/item/storage/backpack/satchel
	name = "satchel"
	desc = "A trendy looking satchel."
	icon_state = "satchel-norm"

/obj/item/storage/backpack/satchel/leather
	name = "leather satchel"
	desc = "It's a very fancy satchel made with fine leather."
	icon_state = "satchel"

/obj/item/storage/backpack/satchel/leather/withwallet/PopulateContents()
	new /obj/item/storage/wallet/random(src)

/obj/item/storage/backpack/satchel/eng
	name = "industrial satchel"
	desc = "A tough satchel with extra pockets."
	icon_state = "satchel-eng"
	item_state = "engiepack"
	resistance_flags = FIRE_PROOF
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE

/obj/item/storage/backpack/satchel/atmospheric
	name = "atmospheric satchel"
	desc = "A tough satchel made of fire resistant fibers. Smells like plasma."
	icon_state = "satchel-atmos"
	item_state = "satchel-atmos"
	resistance_flags = FIRE_PROOF
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE

/obj/item/storage/backpack/satchel/med
	name = "medical satchel"
	desc = "A sterile satchel used in medical departments."
	icon_state = "satchel-med"
	item_state = "medicalpack"

/obj/item/storage/backpack/satchel/vir
	name = "virologist satchel"
	desc = "A sterile satchel with virologist colours."
	icon_state = "satchel-vir"
	item_state = "satchel-vir"

/obj/item/storage/backpack/satchel/chem
	name = "chemist satchel"
	desc = "A sterile satchel with chemist colours."
	icon_state = "satchel-chem"
	item_state = "satchel-chem"

/obj/item/storage/backpack/satchel/gen
	name = "geneticist satchel"
	desc = "A sterile satchel with geneticist colours."
	icon_state = "satchel-gen"
	item_state = "satchel-gen"

/obj/item/storage/backpack/satchel/tox
	name = "scientist satchel"
	desc = "Useful for holding research materials."
	icon_state = "satchel-tox"
	item_state = "satchel-tox"

/obj/item/storage/backpack/satchel/hyd
	name = "botanist satchel"
	desc = "A satchel made of all natural fibers."
	icon_state = "satchel-hyd"
	item_state = "satchel-hyd"

/obj/item/storage/backpack/satchel/sec
	name = "security satchel"
	desc = "A robust satchel for security related needs."
	icon_state = "satchel-sec"
	item_state = "securitypack"

/obj/item/storage/backpack/satchel/explorer
	name = "explorer satchel"
	desc = "A robust satchel for stashing your loot."
	icon_state = "satchel-explorer"
	item_state = "securitypack"

/obj/item/storage/backpack/satchel/bone
	name = "bone satchel"
	desc = "A grotesque satchel made of sinews and bones."
	icon_state = "satchel-bone"
	item_state = "satchel-bone"
	slot_flags = ITEM_SLOT_BACK

/obj/item/storage/backpack/satchel/bone/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 20
	STR.max_items = 15

/obj/item/storage/backpack/satchel/cap
	name = "captain's satchel"
	desc = "An exclusive satchel for Nanotrasen officers."
	icon_state = "satchel-cap"
	item_state = "captainpack"
	resistance_flags = FIRE_PROOF
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE

/obj/item/storage/backpack/satchel/flat
	name = "smuggler's satchel"
	desc = "A very slim satchel that can easily fit into tight spaces."
	icon_state = "satchel-flat"
	w_class = WEIGHT_CLASS_NORMAL //Can fit in backpacks itself.
	level = 1
	component_type = /datum/component/storage/concrete/secret_satchel

/obj/item/storage/backpack/satchel/flat/Initialize(mapload)
	. = ..()
	SSpersistence.new_secret_satchels += src

/obj/item/storage/backpack/satchel/flat/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 6
	STR.cant_hold = typecacheof(list(/obj/item/storage/backpack/satchel/flat)) //muh recursive backpacks

/obj/item/storage/backpack/satchel/flat/hide(intact)
	if(intact)
		invisibility = INVISIBILITY_MAXIMUM
		anchored = TRUE //otherwise you can start pulling, cover it, and drag around an invisible backpack.
		icon_state = "[initial(icon_state)]2"
	else
		invisibility = initial(invisibility)
		anchored = FALSE
		icon_state = initial(icon_state)

/obj/item/storage/backpack/satchel/flat/PopulateContents()
	var/contraband_list = list(
		/obj/item/storage/belt/utility/syndicate = 1,
		/obj/item/storage/toolbox/syndicate = 7,
		/obj/item/storage/toolbox/inteq = 7,
		/obj/item/card/id/syndicate = 6,
		/obj/item/stack/spacecash/c1000 = 3,
		/obj/item/stack/telecrystal = 2,
		/obj/item/storage/belt/military = 12,
		/obj/item/storage/fancy/cigarettes/cigpack_syndicate = 8,
		/obj/item/storage/box/fireworks/dangerous = 11,
		/obj/item/clothing/mask/gas/syndicate = 10,
		/obj/item/vending_refill/donksoft = 13,
		/obj/item/ammo_box/foambox/riot = 11,
		/obj/item/soap/syndie = 7,
		/obj/item/soap/inteq = 8,
		/obj/item/storage/pill_bottle/stimulant = 9, //ephedrine and coffee. Can actually change whether someone gets out of a runaway situation
		/obj/item/toy/cards/deck/syndicate = 10, //1tc, not balance breaking, small but premium commodity
		/obj/item/reagent_containers/glass/bottle/morphine = 8,
		/obj/item/reagent_containers/syringe/contraband/methamphetamine = 12,
		/obj/item/reagent_containers/syringe/contraband/bath_salts = 12,
		/obj/item/clothing/glasses/sunglasses = 5, //can already be achieved in an arguably better form with just some hacking
		/obj/item/storage/box/syndie_kit/space = 5,
		/obj/item/storage/box/syndie_kit/space/inteq = 5,
		/obj/item/reagent_containers/pill/labebium = 12,
		/obj/item/gun/ballistic/automatic/pistol = 2,
		/obj/item/ammo_box/magazine/m10mm = 8,
	)

	for(var/i in 1 to 3)
		var/contraband_type = pickweight(contraband_list)
		contraband_list -= contraband_type
		new contraband_type(src)

/obj/item/storage/backpack/satchel/flat/with_tools/PopulateContents()
	new /obj/item/stack/tile/plasteel(src)
	new /obj/item/crowbar(src)

/obj/item/storage/backpack/satchel/flat/Destroy()
	SSpersistence.new_secret_satchels -= src
	return ..()

/obj/item/storage/backpack/satchel/flat/secret
	var/list/reward_one_of_these = list() //Intended for map editing
	var/list/reward_all_of_these = list() //use paths!
	var/revealed = FALSE

/obj/item/storage/backpack/satchel/flat/secret/Initialize(mapload)
	. = ..()

	if(isfloorturf(loc) && !isplatingturf(loc))
		hide(1)

/obj/item/storage/backpack/satchel/flat/secret/hide(intact)
	..()
	if(!intact && !revealed)
		if(reward_one_of_these.len > 0)
			var/reward = pick(reward_one_of_these)
			new reward(src)
		for(var/R in reward_all_of_these)
			new R(src)
		revealed = TRUE

/obj/item/storage/backpack/duffelbag
	name = "duffel bag"
	desc = "A large duffel bag for holding extra things."
	icon_state = "duffel"
	item_state = "duffel"
	slowdown = 0.5

/obj/item/storage/backpack/duffelbag/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_volume = STORAGE_VOLUME_DUFFLEBAG

/obj/item/storage/backpack/duffelbag/captain
	name = "captain's duffel bag"
	desc = "A large duffel bag for holding extra captainly goods."
	icon_state = "duffel-captain"
	item_state = "duffel-captain"

/obj/item/storage/backpack/duffelbag/med
	name = "medical duffel bag"
	desc = "A large duffel bag for holding extra medical supplies."
	icon_state = "duffel-med"
	item_state = "duffel-med"

/obj/item/storage/backpack/duffelbag/med/surgery
	name = "surgical tools case"
	desc = "A large plastic case for holding surgical tools or most other medical supplies you could imagine."
	icon_state = "firstaid-surgery"
	item_state = "firstaid"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	slot_flags = NONE

/obj/item/storage/backpack/duffelbag/med/surgery/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/static/list/can_hold = typecacheof(list(
		/obj/item/healthanalyzer,
		/obj/item/dnainjector,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/medspray,
		/obj/item/lighter,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/flashlight/pen,
		/obj/item/extinguisher/mini,
		/obj/item/reagent_containers/hypospray,
		/obj/item/hypospray/mkii,
		/obj/item/sensor_device,
		/obj/item/radio,
		/obj/item/clothing/gloves,
		/obj/item/lazarus_injector,
		/obj/item/bikehorn/rubberducky,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/mask/breath,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/surgical_drapes,
		/obj/item/scalpel,
		/obj/item/circular_saw,
		/obj/item/bonesetter,
		/obj/item/surgicaldrill,
		/obj/item/retractor,
		/obj/item/cautery,
		/obj/item/hemostat,
		/obj/item/geiger_counter,
		/obj/item/clothing/neck/stethoscope,
		/obj/item/stamp,
		/obj/item/clothing/glasses,
		/obj/item/wrench/medical,
		/obj/item/clothing/mask/muzzle,
		/obj/item/storage/bag/chemistry,
		/obj/item/storage/bag/bio,
		/obj/item/reagent_containers/blood,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/gun/syringe/syndicate,
		/obj/item/implantcase,
		/obj/item/implant,
		/obj/item/implanter,
		/obj/item/pinpointer/crew,
		/obj/item/reagent_containers/chem_pack,
		/obj/item/razor,
		/obj/item/stack/sticky_tape
		))
	STR.can_hold = can_hold

/obj/item/storage/backpack/duffelbag/med/surgery/PopulateContents()
	new /obj/item/scalpel(src)
	new /obj/item/hemostat(src)
	new /obj/item/retractor(src)
	new /obj/item/circular_saw(src)
	new /obj/item/surgicaldrill(src)
	new /obj/item/cautery(src)
	new /obj/item/bonesetter(src)
	new /obj/item/stack/medical/bone_gel(src)
	new /obj/item/surgical_drapes(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/reagent_containers/medspray/sterilizine(src)
	new /obj/item/razor(src)

/obj/item/storage/backpack/duffelbag/sec
	name = "security duffel bag"
	desc = "A large duffel bag for holding extra security supplies and ammunition."
	icon_state = "duffel-sec"
	item_state = "duffel-sec"

/obj/item/storage/backpack/duffelbag/sec/surgery
	name = "surgical duffel bag"
	desc = "A large duffel bag for holding extra supplies - this one has a material inlay with space for various sharp-looking tools."

/obj/item/storage/backpack/duffelbag/sec/surgery/PopulateContents()
	new /obj/item/scalpel(src)
	new /obj/item/hemostat(src)
	new /obj/item/retractor(src)
	new /obj/item/circular_saw(src)
	new /obj/item/surgicaldrill(src)
	new /obj/item/cautery(src)
	new /obj/item/bonesetter(src)
	new /obj/item/surgical_drapes(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/reagent_containers/medspray/sterilizine(src)

/obj/item/storage/backpack/duffelbag/engineering
	name = "industrial duffel bag"
	desc = "A large duffel bag for holding extra tools and supplies."
	icon_state = "duffel-eng"
	item_state = "duffel-eng"
	resistance_flags = FIRE_PROOF
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE

/obj/item/storage/backpack/duffelbag/atmospheric
	name = "atmospheric duffel bag"
	desc = "A large duffel bag made of fire resistant fibers. Smells like plasma."
	icon_state = "duffel-atmos"
	item_state = "duffel-atmos"
	resistance_flags = FIRE_PROOF
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE

/obj/item/storage/backpack/duffelbag/durathread
	name = "durathread duffel bag"
	desc = "A lightweight duffel bag made out of durathread."
	icon_state = "duffel-durathread"
	item_state = "duffel-durathread"
	resistance_flags = FIRE_PROOF
	slowdown = 0

/obj/item/storage/backpack/duffelbag/drone
	name = "drone duffel bag"
	desc = "A large duffel bag for holding tools and hats."
	icon_state = "duffel-drone"
	item_state = "duffel-drone"
	resistance_flags = FIRE_PROOF
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE

/obj/item/storage/backpack/duffelbag/drone/PopulateContents()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/stack/cable_coil/random(src)
	new /obj/item/wirecutters(src)
	new /obj/item/multitool(src)
	new /obj/item/pipe_dispenser(src)

/obj/item/storage/backpack/duffelbag/clown
	name = "clown's duffel bag"
	desc = "A large duffel bag for holding lots of funny gags!"
	icon_state = "duffel-clown"
	item_state = "duffel-clown"

/obj/item/storage/backpack/duffelbag/clown/cream_pie/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/reagent_containers/food/snacks/pie/cream(src)

/obj/item/storage/backpack/duffelbag/syndie
	name = "Suspicious Looking Duffel Bag"
	desc = "A large duffel bag for holding extra tactical supplies."
	icon_state = "duffel-syndie"
	item_state = "duffel-syndieammo"
	slowdown = 0
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE

/obj/item/storage/backpack/duffelbag/syndie/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.silent = TRUE

/obj/item/storage/backpack/duffelbag/syndie/hitman
	desc = "A large duffel bag for holding extra things. There is a Nanotrasen logo on the back."
	icon_state = "duffel-syndieammo"
	item_state = "duffel-syndieammo"

/obj/item/storage/backpack/duffelbag/syndie/hitman/PopulateContents()
	new /obj/item/clothing/under/suit/black(src)
	new /obj/item/clothing/accessory/waistcoat(src)
	new /obj/item/clothing/suit/toggle/lawyer/black(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/head/fedora(src)

/obj/item/storage/backpack/duffelbag/syndie/med
	name = "medical duffel bag"
	desc = "A large duffel bag for holding extra tactical medical supplies."
	icon_state = "duffel-syndiemed"
	item_state = "duffel-syndiemed"

/obj/item/storage/backpack/duffelbag/syndie/surgery
	name = "surgery duffel bag"
	desc = "A suspicious looking duffel bag for holding surgery tools."
	icon_state = "duffel-syndiemed"
	item_state = "duffel-syndiemed"

/obj/item/storage/backpack/duffelbag/syndie/surgery/PopulateContents()
	new /obj/item/scalpel(src)
	new /obj/item/hemostat(src)
	new /obj/item/retractor(src)
	new /obj/item/circular_saw(src)
	new /obj/item/surgicaldrill(src)
	new /obj/item/cautery(src)
	new /obj/item/bonesetter(src)
	new /obj/item/surgical_drapes(src)
	new /obj/item/clothing/suit/straight_jacket(src)
	new /obj/item/clothing/mask/muzzle(src)
	new /obj/item/mmi/syndie(src)
	new /obj/item/implantcase(src)
	new /obj/item/implanter(src)
	new /obj/item/reagent_containers/medspray/sterilizine(src)

/obj/item/storage/backpack/duffelbag/syndie/surgery_adv
	name = "advanced surgery duffel bag"
	desc = "A large duffel bag for holding surgical tools. Bears the logo of an advanced med-tech firm."

/obj/item/storage/backpack/duffelbag/syndie/surgery_adv/PopulateContents()
	new /obj/item/scalpel/advanced(src)
	new /obj/item/retractor/advanced(src)
	new /obj/item/surgicaldrill/advanced(src)
	new /obj/item/bonesetter(src)
	new /obj/item/surgical_drapes(src)
	new /obj/item/clothing/suit/straight_jacket(src)
	new /obj/item/clothing/mask/muzzle(src)
	new /obj/item/mmi/syndie(src)
	new /obj/item/implantcase(src)
	new /obj/item/implanter(src)
	new /obj/item/reagent_containers/medspray/sterilizine(src)

/obj/item/storage/backpack/duffelbag/syndie/ammo
	name = "ammunition duffel bag"
	desc = "A large duffel bag for holding extra weapons ammunition and supplies."
	icon_state = "duffel-syndieammo"
	item_state = "duffel-syndieammo"

/obj/item/storage/backpack/duffelbag/syndie/ammo/shotgun
	desc = "A large duffel bag, packed to the brim with Bulldog shotgun drum magazines."

/obj/item/storage/backpack/duffelbag/syndie/ammo/shotgun/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/ammo_box/magazine/m12g(src)
	new /obj/item/ammo_box/magazine/m12g/stun(src)
	new /obj/item/ammo_box/magazine/m12g/slug(src)
	new /obj/item/ammo_box/magazine/m12g/dragon(src)

/obj/item/storage/backpack/duffelbag/syndie/ammo/smg
	desc = "A large duffel bag, packed to the brim with C-20r magazines."

/obj/item/storage/backpack/duffelbag/syndie/ammo/smg/PopulateContents()
	for(var/i in 1 to 9)
		new /obj/item/ammo_box/magazine/smgm45(src)

/obj/item/storage/backpack/duffelbag/syndie/ammo/dark_gygax
	desc = "A large duffel bag, packed to the brim with various exosuit ammo."

/obj/item/storage/backpack/duffelbag/syndie/ammo/dark_gygax/PopulateContents()
	new /obj/item/mecha_ammo/incendiary(src)
	new /obj/item/mecha_ammo/incendiary(src)
	new /obj/item/mecha_ammo/incendiary(src)
	new /obj/item/mecha_ammo/flashbang(src)
	new /obj/item/mecha_ammo/flashbang(src)
	new /obj/item/mecha_ammo/flashbang(src)

/obj/item/storage/backpack/duffelbag/syndie/ammo/mauler
	desc = "A large duffel bag, packed to the brim with various exosuit ammo."

/obj/item/storage/backpack/duffelbag/syndie/ammo/mauler/PopulateContents()
	new /obj/item/mecha_ammo/lmg(src)
	new /obj/item/mecha_ammo/lmg(src)
	new /obj/item/mecha_ammo/lmg(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/missiles_he(src)
	new /obj/item/mecha_ammo/missiles_he(src)
	new /obj/item/mecha_ammo/missiles_he(src)

/obj/item/storage/backpack/duffelbag/syndie/c20rbundle
	desc = "A large duffel bag containing a C-20r, some magazines, and a cheap looking suppressor."

/obj/item/storage/backpack/duffelbag/syndie/c20rbundle/PopulateContents()
	new /obj/item/ammo_box/magazine/smgm45(src)
	new /obj/item/ammo_box/magazine/smgm45(src)
	new /obj/item/gun/ballistic/automatic/c20r(src)
	new /obj/item/suppressor/specialoffer(src)

/obj/item/storage/backpack/duffelbag/syndie/bulldogbundle
	desc = "A large duffel bag containing a Bulldog, some drums, and a pair of thermal imaging glasses."

/obj/item/storage/backpack/duffelbag/syndie/bulldogbundle/PopulateContents()
	new /obj/item/ammo_box/magazine/m12g(src)
	new /obj/item/gun/ballistic/automatic/shotgun/bulldog(src)
	new /obj/item/ammo_box/magazine/m12g/stun(src)
	new /obj/item/clothing/glasses/thermal/syndi(src)

/obj/item/storage/backpack/duffelbag/syndie/med/medicalbundle
	desc = "A large duffel bag containing a tactical medkit, a Donksoft machine gun, a big jumbo box of riot darts, and a knock-off pair of magboots."

/obj/item/storage/backpack/duffelbag/syndie/med/medicalbundle/PopulateContents()
	new /obj/item/clothing/shoes/magboots/syndie(src)
	new /obj/item/storage/firstaid/tactical/nukeop(src)
	new /obj/item/gun/ballistic/automatic/l6_saw/toy(src)
	new /obj/item/ammo_box/foambox/riot(src)

/obj/item/storage/backpack/duffelbag/syndie/med/bioterrorbundle
	desc = "A large duffel bag containing deadly chemicals, a handheld chem sprayer, Bioterror foam grenade, a Donksoft assault rifle, box of riot grade darts, a dart pistol, and a box of syringes."

/obj/item/storage/backpack/duffelbag/syndie/med/bioterrorbundle/PopulateContents()
	new /obj/item/reagent_containers/spray/chemsprayer/bioterror(src)
	new /obj/item/storage/box/syndie_kit/chemical(src)
	new /obj/item/gun/syringe/syndicate(src)
	new /obj/item/gun/ballistic/automatic/c20r/toy(src)
	new /obj/item/storage/box/syringes(src)
	new /obj/item/ammo_box/foambox/riot(src)
	new /obj/item/grenade/chem_grenade/bioterrorfoam(src)
	if(prob(5))
		new /obj/item/reagent_containers/food/snacks/pizza/pineapple(src)

/obj/item/storage/backpack/duffelbag/syndie/c4/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/grenade/plastic/c4(src)

/obj/item/storage/backpack/duffelbag/syndie/x4/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/grenade/plastic/x4(src)

/obj/item/storage/backpack/duffelbag/syndie/firestarter
	desc = "A large duffel bag containing a New Russian pyro backpack sprayer, Elite hardsuit, a Stechkin APS pistol, minibomb, ammo, and other equipment."

/obj/item/storage/backpack/duffelbag/syndie/firestarter/PopulateContents()
	new /obj/item/clothing/under/syndicate/soviet(src)
	new /obj/item/watertank/op(src)
	new /obj/item/clothing/suit/space/hardsuit/syndi/elite(src)
	new /obj/item/gun/ballistic/automatic/pistol/APS(src)
	new /obj/item/ammo_box/magazine/pistolm9mm(src)
	new /obj/item/ammo_box/magazine/pistolm9mm(src)
	new /obj/item/reagent_containers/food/drinks/bottle/vodka/badminka(src)
	new /obj/item/reagent_containers/syringe/stimulants(src)
	new /obj/item/grenade/syndieminibomb(src)

// For ClownOps.
/obj/item/storage/backpack/duffelbag/clown/syndie/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	slowdown = 0
	STR.silent = TRUE

/obj/item/storage/backpack/duffelbag/clown/syndie/PopulateContents()
	new /obj/item/pda/clown(src)
	new /obj/item/clothing/under/rank/civilian/clown(src)
	new /obj/item/clothing/shoes/clown_shoes(src)
	new /obj/item/clothing/mask/gas/clown_hat(src)
	new /obj/item/bikehorn(src)
	new /obj/item/implanter/sad_trombone(src)

/obj/item/storage/backpack/duffelbag/syndie/shredderbundle
	desc = "A large duffel bag containing two CX Shredders, some magazines, an elite hardsuit, and a chest rig."

/obj/item/storage/backpack/duffelbag/syndie/shredderbundle/PopulateContents()
	new /obj/item/ammo_box/magazine/flechette/shredder(src)
	new /obj/item/ammo_box/magazine/flechette/shredder(src)
	new /obj/item/ammo_box/magazine/flechette/shredder(src)
	new /obj/item/ammo_box/magazine/flechette/shredder(src)
	new /obj/item/gun/ballistic/automatic/flechette/shredder(src)
	new /obj/item/gun/ballistic/automatic/flechette/shredder(src)
	new /obj/item/storage/belt/military(src)
	new /obj/item/clothing/suit/space/hardsuit/syndi/elite(src)

/obj/item/storage/backpack/snail
	name = "snail shell"
	desc = "Worn by snails as armor and storage compartment."
	icon_state = "snailshell"
	item_state = "snailshell"

/obj/item/storage/backpack/henchmen
	name = "wings"
	desc = "Granted to the henchmen who deserve it. This probably doesn't include you."
	icon_state = "henchmen"
	item_state = "henchmen"

/obj/item/storage/backpack/duffelbag/cursed
	name = "Cursed Dufflebag"
	icon_state = "duffel-curse"
	item_state = "duffel"
	desc = "A duffelbag painted black with a red stripe. It looks more heavier than normal bags."
	force = 24
	throwforce = 38

/obj/item/storage/backpack/duffelbag/cursed/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.silent = TRUE

/obj/item/storage/backpack/duffelbag/cursed/PopulateContents()
	new /obj/item/screwdriver/ashwalker(src)
	new /obj/item/wrench/ashwalker(src)
	new /obj/item/weldingtool/experimental/ashwalker(src)
	new /obj/item/crowbar/ashwalker(src)
	new /obj/item/wirecutters/ashwalker(src, "red")
  // /obj/item/clothing/gloves/tackler/combat/insulated/infiltrator bluemoon removal
