#define CONFUSION_STACK_MAX_MULTIPLIER 2
/obj/item/assembly/flash
	name = "flash"
	desc = "A powerful and versatile flashbulb device, with applications ranging from disorienting attackers to acting as visual receptors in robot production."
	icon_state = "flashtool"
	item_state = "flashtool"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/iron = 300, /datum/material/glass = 300)
	crit_fail = FALSE     //Is the flash burnt out?
	light_color = LIGHT_COLOR_WHITE
	light_power = FLASH_LIGHT_POWER
	var/flashing_overlay = "flash-f"
	var/times_used = 0 //Number of times it's been used.
	var/burnout_resistance = 0
	var/last_used = 0 //last world.time it was used.
	var/cooldown = 0
	var/last_trigger = 0 //Last time it was successfully triggered.

/obj/item/assembly/flash/suicide_act(mob/living/user)
	if (crit_fail)
		user.visible_message("<span class='suicide'>[user] raises \the [src] up to [user.ru_ego()] eyes and activates it ... but its burnt out!</span>")
		return SHAME
	else if (user.eye_blind)
		user.visible_message("<span class='suicide'>[user] raises \the [src] up to [user.ru_ego()] eyes and activates it ... but [user.ru_who()] blind!</span>")
		return SHAME
	user.visible_message("<span class='suicide'>[user] raises \the [src] up to [user.ru_ego()] eyes and activates it! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	attack(user,user)
	return FIRELOSS

/obj/item/assembly/flash/DoRevenantThrowEffects(atom/target)
	AOE_flash()

/obj/item/assembly/flash/update_icon(flash = FALSE)
	cut_overlays()
	attached_overlays = list()
	if(crit_fail)
		add_overlay("flashtool_flashburnt")
		attached_overlays += "flashtool_flashburnt"
	if(flash)
		add_overlay(flashing_overlay)
		attached_overlays += flashing_overlay
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_icon)), 5)
	if(holder)
		holder.update_icon()

/obj/item/assembly/flash/proc/clown_check(mob/living/carbon/human/user)
	if(HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50))
		flash_carbon(user, user, 15, 0)
		return FALSE
	return TRUE

/obj/item/assembly/flash/proc/burn_out() //Made so you can override it if you want to have an invincible flash from R&D or something.
	if(!crit_fail)
		crit_fail = TRUE
		update_icon()
	if(ismob(loc))
		var/mob/M = loc
		M.visible_message("<span class='danger'>[src] burns out!</span>","<span class='userdanger'>[src] burns out!</span>")
	else
		var/turf/T = get_turf(src)
		T.visible_message("<span class='danger'>[src] burns out!</span>")

/obj/item/assembly/flash/proc/flash_recharge(interval = 10)
	var/deciseconds_passed = world.time - last_used
	for(var/seconds = deciseconds_passed / 10, seconds >= interval, seconds -= interval) //get 1 charge every interval
		times_used--
	last_used = world.time
	times_used = max(0, times_used) //sanity
	if(max(0, prob(times_used * 3) - burnout_resistance)) //The more often it's used in a short span of time the more likely it will burn out
		burn_out()
		return FALSE
	return TRUE

//BYPASS CHECKS ALSO PREVENTS BURNOUT!
/obj/item/assembly/flash/proc/AOE_flash(bypass_checks = FALSE, range = 3, power = 5, targeted = FALSE, mob/user)
	if(!bypass_checks && !try_use_flash())
		return FALSE
	var/list/mob/targets = get_flash_targets(get_turf(src), range, FALSE)
	if(user)
		targets -= user
	for(var/mob/living/carbon/C in targets)
		flash_carbon(C, user, power, targeted, TRUE)
	return TRUE

/obj/item/assembly/flash/proc/get_flash_targets(atom/target_loc, range = 3, override_vision_checks = FALSE)
	if(!target_loc)
		target_loc = loc
	if(override_vision_checks)
		return get_hearers_in_view(range, get_turf(target_loc))
	if(isturf(target_loc) || (ismob(target_loc) && isturf(target_loc.loc)))
		return viewers(range, get_turf(target_loc))
	else
		return typecache_filter_list(target_loc.GetAllContents(), GLOB.typecache_living)

/obj/item/assembly/flash/proc/try_use_flash(mob/user = null)
	if(crit_fail || (world.time < last_trigger + cooldown))
		return FALSE
	last_trigger = world.time
	playsound(src, 'sound/weapons/flash.ogg', 100, TRUE)
	flash_lighting_fx(FLASH_LIGHT_RANGE, light_power, light_color)
	times_used++
	flash_recharge()
	update_icon()
	if(user && !clown_check(user))
		return FALSE
	return TRUE

/obj/item/assembly/flash/proc/flash_carbon(mob/living/carbon/M, mob/user, power = 15, targeted = TRUE, generic_message = FALSE)
	if(!istype(M))
		return
	if(user)
		log_combat(user, M, "[targeted? "flashed(targeted)" : "flashed(AOE)"]", src)
	else //caused by emp/remote signal
		M.log_message("was [targeted? "flashed(targeted)" : "flashed(AOE)"]",LOG_ATTACK)
	if(generic_message && M != user)
		to_chat(M, "<span class='disarm'>[src] производит резкую вспышку неприятного свечения!</span>")
	if(targeted)
		if(M.flash_act(1, 1))
			if(M.confused < power)
				var/diff = power * CONFUSION_STACK_MAX_MULTIPLIER - M.confused
				M.confused += min(power, diff)
			if(user)
				terrible_conversion_proc(M, user)
				visible_message("<span class='disarm'>[user] ошеломляет [M] флешером!</span>")
				to_chat(user, "<span class='danger'>Ты ошеломил [M] флешером!</span>")
				to_chat(M, "<span class='userdanger'>[user] ошеломляет тебя флешером!</span>")
			else
				to_chat(M, "<span class='userdanger'>Bы были ошеломлены [src]!</span>")
			var/toblur = 20 - M.eye_blurry
			if(toblur > 0)
				M.blur_eyes(toblur)
		else if(user)
			visible_message("<span class='disarm'>[user] не удалось ошеломить [M] флешером!</span>")
			to_chat(user, "<span class='warning'>Тебе не удалось ошеломить [M] флешером!</span>")
			to_chat(M, "<span class='danger'>[user] не удалось ошеломить тебя!</span>")
		else
			to_chat(M, "<span class='danger'>[src] не удалось ошеломить тебя!</span>")
	else
		if(M.flash_act())
			var/diff = power * CONFUSION_STACK_MAX_MULTIPLIER - M.confused
			M.confused += min(power, diff)

/obj/item/assembly/flash/attack(mob/living/M, mob/user)
	if(!try_use_flash(user))
		return FALSE
	if(iscarbon(M))
		flash_carbon(M, user, 20, 1)
		return TRUE
	else if(issilicon(M))
		var/mob/living/silicon/robot/R = M
		if(!R.flash_protect)
			log_combat(user, R, "flashed", src)
			update_icon(1)
			R.DefaultCombatKnockdown(rand(80,120))
			var/diff = 5 * CONFUSION_STACK_MAX_MULTIPLIER - M.confused
			R.confused += min(5, diff)
			R.flash_act(affect_silicon = 1)
			user.visible_message("<span class='disarm'>[user] перегружает сенсоры [R] флешером!</span>", "<span class='danger'>Ты перегружаешь сенсоры [R] флешером!</span>")
			return TRUE

	user.visible_message("<span class='disarm'>[user] неудачно ошеломляет [M] флешером!</span>", "<span class='warning'>Тебе не удалось ошеломить [M] флешером!</span>")

/obj/item/assembly/flash/attack_self(mob/living/carbon/user, flag = 0, emp = 0)
	if(holder)
		return FALSE
	if(!AOE_flash(FALSE, 3, 5, FALSE, user))
		return FALSE
	to_chat(user, "<span class='danger'>[src] производит резкую вспышку неприятного свечения!</span>")

/obj/item/assembly/flash/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(!try_use_flash())
		return
	AOE_flash()
	burn_out()

/obj/item/assembly/flash/activate()//AOE flash on signal received
	if(!..())
		return
	AOE_flash()

/obj/item/assembly/flash/proc/terrible_conversion_proc(mob/living/carbon/human/H, mob/user)
	if(istype(H) && ishuman(user) && H.stat != DEAD)
		if(user.mind)
			var/datum/antagonist/rev/head/converter = user.mind.has_antag_datum(/datum/antagonist/rev/head)
			if(!converter)
				return
			if(!H.client)
				to_chat(user, "<span class='warning'>This mind is so vacant that it is not susceptible to influence!</span>")
				return
			if(H.stat != CONSCIOUS)
				to_chat(user, "<span class='warning'>They must be conscious before you can convert [H.ru_na()]!</span>")
				return
			if(converter.add_revolutionary(H.mind))
				times_used -- //Flashes less likely to burn out for headrevs when used for conversion
			else
				to_chat(user, "<span class='warning'>This mind seems resistant to the flash!</span>")

/obj/item/assembly/flash/cyborg

/obj/item/assembly/flash/cyborg/attack(mob/living/M, mob/user)
	. = ..()
	new /obj/effect/temp_visual/borgflash(get_turf(src))
	if(. && !CONFIG_GET(flag/disable_borg_flash_knockdown) && iscarbon(M) && CHECK_MOBILITY(M, MOBILITY_STAND) && !M.get_eye_protection())
		M.DefaultCombatKnockdown(80)

/obj/item/assembly/flash/cyborg/attack_self(mob/user)
	..()
	new /obj/effect/temp_visual/borgflash(get_turf(src))

/obj/item/assembly/flash/cyborg/attackby(obj/item/W, mob/user, params)
	return
/obj/item/assembly/flash/cyborg/screwdriver_act(mob/living/user, obj/item/I)
	return

/obj/item/assembly/flash/handheld //this is now the regular pocket flashes

/obj/item/assembly/flash/armimplant
	name = "photon projector"
	desc = "A high-powered photon projector implant normally used for lighting purposes, but also doubles as a flashbulb weapon. Self-repair protocols fix the flashbulb if it ever burns out."
	var/flashcd = 20
	var/overheat = 0
	var/obj/item/organ/cyberimp/arm/flash/I = null
	var/active_light_strength = 7

/obj/item/assembly/flash/armimplant/Destroy()
	I = null
	return ..()

/obj/item/assembly/flash/armimplant/burn_out()
	if(I && I.owner)
		to_chat(I.owner, "<span class='warning'>Your photon projector implant overheats and deactivates!</span>")
		I.Retract()
	overheat = TRUE
	addtimer(CALLBACK(src, PROC_REF(cooldown)), flashcd * 2)

/obj/item/assembly/flash/armimplant/try_use_flash(mob/user = null)
	if(overheat)
		if(I && I.owner)
			to_chat(I.owner, "<span class='warning'>Your photon projector is running too hot to be used again so quickly!</span>")
		return FALSE
	overheat = TRUE
	addtimer(CALLBACK(src, PROC_REF(cooldown)), flashcd)
	playsound(src, 'sound/weapons/flash.ogg', 100, TRUE)
	update_icon(1)
	return TRUE

/obj/item/assembly/flash/armimplant/Moved(oldLoc, dir)
	. = ..()
	if(!ismob(loc))
		set_light(0)
	else
		set_light(7)

/obj/item/assembly/flash/armimplant/proc/cooldown()
	overheat = FALSE

//ported from tg - check to make sure it can't appear where it's not supposed to.
/obj/item/assembly/flash/hypnotic
	desc = "A modified flash device, programmed to emit a sequence of subliminal flashes that can send a vulnerable target into a hypnotic trance."
	flashing_overlay = "flash-hypno" //I cannot find this icon no matter how hard I look in tg, so I might just make my own.
	light_color = LIGHT_COLOR_PINK
	cooldown = 20

/obj/item/assembly/flash/hypnotic/burn_out()
	return

/obj/item/assembly/flash/hypnotic/flash_carbon(mob/living/carbon/M, mob/user, power = 15, targeted = TRUE, generic_message = FALSE)
	if(!istype(M))
		return
	if(user)
		log_combat(user, M, "[targeted? "hypno-flashed(targeted)" : "hypno-flashed(AOE)"]", src)
	else //caused by emp/remote signal
		M.log_message("was [targeted? "hypno-flashed(targeted)" : "hypno-flashed(AOE)"]",LOG_ATTACK)
	if(generic_message && M != user)
		to_chat(M, "<span class='disarm'>[src] emits a soothing light...</span>")
	if(targeted)
		if(M.flash_act(1, 1))
			var/hypnosis = FALSE
			if(M.hypnosis_vulnerable())
				hypnosis = TRUE
			if(user)
				user.visible_message("<span class='disarm'>[user] blinds [M] флешером!</span>", "<span class='danger'>You hypno-flash [M]!</span>")

			if(!hypnosis)
				to_chat(M, "<span class='notice'>The light makes you feel oddly relaxed...</span>")
				M.confused += min(M.confused + 10, 20)
				M.dizziness += min(M.dizziness + 10, 20)
				M.drowsyness += min(M.drowsyness + 10, 20)
				M.apply_status_effect(STATUS_EFFECT_PACIFY, 100)
			else
				M.apply_status_effect(/datum/status_effect/trance, 200, TRUE)

		else if(user)
			user.visible_message("<span class='disarm'>[user] fails to blind [M] флешером!</span>", "<span class='warning'>You fail to hypno-flash [M]!</span>")
		else
			to_chat(M, "<span class='danger'>[src] fails to blind you!</span>")

	else if(M.flash_act())
		to_chat(M, "<span class='notice'>Such a pretty light...</span>")
		M.confused += min(M.confused + 4, 20)
		M.dizziness += min(M.dizziness + 4, 20)
		M.drowsyness += min(M.drowsyness + 4, 20)
