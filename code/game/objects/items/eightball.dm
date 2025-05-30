/obj/item/toy/eightball
	name = "magic eightball"
	desc = "A black ball with a stenciled number eight in white on the side. It seems full of dark liquid.\nThe instructions state that you should ask your question aloud, and then shake."

	icon = 'icons/obj/toys/toy.dmi'
	icon_state = "eightball"
	w_class = WEIGHT_CLASS_TINY

	verb_say = "rattles"

	var/shaking = FALSE
	var/on_cooldown = FALSE

	var/shake_time = 50
	var/cooldown_time = 100

	var/static/list/possible_answers = list(
		"Бесспорно",
		"Предрешено",
		"Без сомнений",
		"Определённо да",
		"Можешь быть уверен в этом",
		"Мне кажется — да",
		"Вероятнее всего",
		"Хорошие перспективы",
		"Возможно",
		"Похоже, что да",
		"Пока не ясно",
		"Спроси позже",
		"Лучше не рассказывать",
		"Сейчас нельзя",
		"Повтори опять",
		"Даже не думай",
		"Не рассчитывай на это",
		"Лучше даже не пробовать",
		"Перспективы не очень хорошие",
		"Весьма сомнительно")

/obj/item/toy/eightball/Initialize(mapload)
	. = ..()
	if(MakeHaunted())
		return INITIALIZE_HINT_QDEL

/obj/item/toy/eightball/proc/MakeHaunted()
	. = prob(1)
	if(.)
		new /obj/item/toy/eightball/haunted(loc)

/obj/item/toy/eightball/DoRevenantThrowEffects(atom/target)
	MakeHaunted()

/obj/item/toy/eightball/attack_self(mob/user)
	if(shaking)
		return

	if(on_cooldown)
		to_chat(user, "<span class='warning'>[src] was shaken recently, it needs time to settle.</span>")
		return

	user.visible_message("<span class='notice'>[user] starts shaking [src].</span>", "<span class='notice'>You start shaking [src].</span>", "<span class='hear'>You hear shaking and sloshing.</span>")

	shaking = TRUE

	start_shaking(user)
	if(do_after(user, shake_time))
		var/answer = get_answer()
		say(answer)

		on_cooldown = TRUE
		addtimer(CALLBACK(src, PROC_REF(clear_cooldown)), cooldown_time)

	shaking = FALSE

/obj/item/toy/eightball/proc/start_shaking(user)
	return

/obj/item/toy/eightball/proc/get_answer()
	return pick(possible_answers)

/obj/item/toy/eightball/proc/clear_cooldown()
	on_cooldown = FALSE

// bluemoon tooyy!!

/obj/item/toy/eightball/science
	name = "reality sensor"
	desc = "A high-tech device designed to monitor and analyze the parameters of the surrounding space for its compliance with the expected physical and metaphysical laws. It is used in scientific experiments, converting data into voice reports after activation by physical impact (shaking), which provides intuitive interaction without interfaces."

	icon = 'icons/obj/toys/toy.dmi'
	icon_state = "science_toy"

// A broken magic eightball, it only says "YOU SUCK" over and over again.

/obj/item/toy/eightball/broken
	name = "broken magic eightball"
	desc = "A black ball with a stenciled number eight in white on the side. It is cracked and seems empty."
	var/fixed_answer

/obj/item/toy/eightball/broken/Initialize(mapload)
	. = ..()
	fixed_answer = pick(possible_answers)

/obj/item/toy/eightball/broken/get_answer()
	return fixed_answer

// Haunted eightball is identical in description and function to toy,
// except it actually ASKS THE DEAD (wooooo)

/obj/item/toy/eightball/haunted
	shake_time = 30 SECONDS
	cooldown_time = 3 MINUTES
	flags_1 = HEAR_1
	var/last_message
	var/selected_message
	//these kind of store the same thing but one is easier to work with.
	var/list/votes = list()
	var/list/voted = list()
	var/static/list/haunted_answers = list(
		"yes" = list(
			"Бесспорно",
			"Предрешено",
			"Без сомнений",
			"Определённо да",
			"Можешь быть уверен в этом",
			"Мне кажется — да",
			"Вероятнее всего",
			"Хорошие перспективы",
			"Возможно",
			"Похоже, что да",
		),
		"maybe" = list(
			"Пока не ясно",
			"Спроси позже",
			"Лучше не рассказывать",
			"Сейчас нельзя",
			"Повтори опять",
		),
		"no" = list(
			"Даже не думай",
			"Не рассчитывай на это",
			"Лучше даже не пробовать",
			"Перспективы не очень хорошие",
			"Весьма сомнительно"
		)
	)

/obj/item/toy/eightball/haunted/Initialize(mapload)
	. = ..()
	for (var/answer in haunted_answers)
		votes[answer] = 0
	GLOB.poi_list |= src

/obj/item/toy/eightball/haunted/Destroy()
	GLOB.poi_list -= src
	. = ..()

/obj/item/toy/eightball/haunted/MakeHaunted()
	return FALSE

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/item/toy/eightball/haunted/attack_ghost(mob/user)
	if(!shaking)
		to_chat(user, "<span class='warning'>[src] is not currently being shaken.</span>")
		return
	interact(user)
	return ..()

/obj/item/toy/eightball/haunted/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, spans, message_mode)
	. = ..()
	last_message = raw_message

/obj/item/toy/eightball/haunted/start_shaking(mob/user)
	// notify ghosts that someone's shaking a haunted eightball
	// and inform them of the message, (hopefully a yes/no question)
	selected_message = last_message
	notify_ghosts("[user] is shaking [src], hoping to get an answer to \"[selected_message]\"", source=src, enter_link="<a href=?src=[REF(src)];interact=1>(Click to help)</a>", action=NOTIFY_ATTACK)

/obj/item/toy/eightball/haunted/Topic(href, href_list)
	if(href_list["interact"])
		if(isobserver(usr))
			interact(usr)

/obj/item/toy/eightball/haunted/get_answer()
	var/top_amount = 0
	var/top_vote

	for(var/vote in votes)
		var/amount_of_votes = length(votes[vote])
		if(amount_of_votes > top_amount)
			top_vote = vote
			top_amount = amount_of_votes
		//If one option actually has votes and there's a tie, pick between them 50/50
		else if(top_amount && amount_of_votes == top_amount && prob(50))
			top_vote = vote
			top_amount = amount_of_votes

	if(isnull(top_vote))
		top_vote = pick(votes)

	for(var/vote in votes)
		votes[vote] = 0

	voted.Cut()

	return top_vote

/obj/item/toy/eightball/haunted/ui_state(mob/user)
	return GLOB.observer_state

/obj/item/toy/eightball/haunted/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EightBallVote", name)
		ui.open()

/obj/item/toy/eightball/haunted/ui_data(mob/user)
	var/list/data = list()
	data["shaking"] = shaking
	data["question"] = selected_message

	data["answers"] = list()
	for(var/pa in haunted_answers)
		var/list/L = list()
		L["answer"] = pa
		L["amount"] = votes[pa]
		L["selected"] = voted[user.ckey]

		data["answers"] += list(L)
	return data

/obj/item/toy/eightball/haunted/ui_act(action, params)
	if(..())
		return
	var/mob/user = usr

	switch(action)
		if("vote")
			var/selected_answer = params["answer"]
			if(!(selected_answer in haunted_answers))
				return
			if(user.ckey in voted)
				return
			else
				votes[selected_answer] += 1
				voted[user.ckey] = selected_answer
				. = TRUE
