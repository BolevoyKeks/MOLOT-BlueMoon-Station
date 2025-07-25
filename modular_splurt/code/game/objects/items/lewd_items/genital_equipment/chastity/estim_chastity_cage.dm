/obj/item/key/chastity_key/estim
	name = "\improper E-Stim cage controller"
	icon = 'modular_splurt/icons/obj/lewd_items/lewd_items.dmi'
	lefthand_file = 'modular_splurt/icons/mob/inhands/lewd_items/lewd_inhand_left.dmi'
	righthand_file = 'modular_splurt/icons/mob/inhands/lewd_items/lewd_inhand_right.dmi'
	icon_state = "mindcontroller"
	item_state = "mindcontroller"

	var/min_power = 1
	var/power = 1
	var/max_power = 6

	var/obj/item/genital_equipment/chastity_cage/estim/estim_cage
	COOLDOWN_DECLARE(last_activation)

/obj/item/key/chastity_key/estim/attack_self(mob/user)
	. = ..()
	if(!estim_cage)
		return

	ui_interact(user)

/obj/item/key/chastity_key/estim/proc/activate(mob/user)
	if(!estim_cage.equipment.holder_genital)
		return
	if(!COOLDOWN_FINISHED(src, last_activation))
		return
	var/mob/living/carbon/human/H = estim_cage.equipment.holder_genital.owner
	var/genits = null // BLUEMOON ADD
	switch(estim_cage.mode)
		if("shock")
			playsound(H, get_sfx("sparks"), 20*power)

			if(power >= max_power)
				if(H.client?.prefs.cit_toggles & SEX_JITTER)
					H.do_jitter_animation()
				H.Stun(3 SECONDS)

			if(HAS_TRAIT(H, TRAIT_MASO))
				//BLUEMOON EDIT START
				genits = H.adjust_arousal(20*power, "masochism", maso = TRUE)
				H.handle_post_sex(NORMAL_LUST*power, null, null, H.getorganslot(CUM_TARGET_PENIS))

				if(prob(30))
					H.emote(pick("moan", "shiver", "blush"))
			else
				if(prob(30))
					if(power > 4)
						H.emote(pick("scream", "pain", "twitch"))
					else
						H.emote(pick("groan", "shiver", "twitch_s"))
				H.add_lust(-1*NORMAL_LUST*power)
		if("stimulation")
			playsound(H, 'modular_splurt/sound/lewd/vibrate.ogg', 20*power)
			if(prob(30))
				H.emote(pick("moan", "shiver", "blush"))

			genits = H.adjust_arousal(20*power, "e-stimcage")
			H.handle_post_sex(LOW_LUST*power, null, null, H.getorganslot(CUM_TARGET_PENIS))
	if(genits)
		for(var/g in genits)
			var/obj/item/organ/genital/G = g
			to_chat(H, span_userlove("[G.arousal_verb]!"))
		//BLUEMOON EDIT END

	COOLDOWN_START(src, last_activation, 1 SECONDS)

/obj/item/key/chastity_key/estim/ui_status(mob/user)
	if(can_interact(user) && estim_cage)
		return ..()
	return UI_CLOSE

/obj/item/key/chastity_key/estim/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChastityRemote", name)
		ui.open()

/obj/item/key/chastity_key/estim/ui_data(mob/user)
	var/list/data = list()

	data["power"] = power
	data["mode"] = estim_cage.mode
	data["maxPower"] = max_power
	data["minPower"] = min_power

	return data

/obj/item/key/chastity_key/estim/ui_act(action, list/params)
	. = ..()
	if(!ishuman(usr))
		return

	switch(action)
		if("change_power")
			power = params["power"]
			. = TRUE
		if("change_mode")
			estim_cage.mode = params["mode"]
			. = TRUE
		if("activate")
			activate(usr)
			. = TRUE

/obj/item/genital_equipment/chastity_cage/estim
	name = "\improper E-Stim chastity cage"
	icon_state = "estim_cage"
	worn_icon_state = "standard_cage"
	break_require = TOOL_MULTITOOL
	break_time = 15 SECONDS

	var/mode = "shock"

/obj/item/genital_equipment/chastity_cage/estim/Initialize(mapload, obj/item/key/chastity_key/estim/newkey = null)
	. = ..()
	var/obj/item/key/chastity_key/estim/estim_key = key
	if(estim_key)
		if(!estim_key.estim_cage)
			estim_key.estim_cage = src
		if(!estim_key && newkey)
			estim_key = newkey
		if(estim_key)
			if(!estim_key.estim_cage)
				estim_key.estim_cage = src
