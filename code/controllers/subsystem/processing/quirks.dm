//Used to process and handle roundstart quirks
// - Quirk strings are used for faster checking in code
// - Quirk datums are stored and hold different effects, as well as being a vector for applying trait string
PROCESSING_SUBSYSTEM_DEF(quirks)
	name = "Quirks"
	init_order = INIT_ORDER_QUIRKS
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME
	wait = 1 SECONDS

	var/list/quirks = list()		//Assoc. list of all roundstart quirk datum types; "name" = /path/
	var/list/quirk_names_by_path = list()
	var/list/quirk_points = list()	//Assoc. list of quirk names and their "point cost"; positive numbers are good traits, and negative ones are bad
	var/list/quirk_objects = list()	//A list of all quirk objects in the game, since some may process
	var/list/quirk_blacklist = list() //A list a list of quirks that can not be used with each other. Format: list(quirk1,quirk2),list(quirk3,quirk4)

/datum/controller/subsystem/processing/quirks/Initialize(timeofday)
	if(!quirks.len)
		SetupQuirks()
		//BLUEMOON ADD чиним под русский текст и добавляем всё в одном листе
		quirk_blacklist = list(
						  list("Слепота","Близорукость"),
						  list("Жизнерадостный","Депрессия","Равнодушный"),
						  list("Агевзия","Извращенные Вкусы"),
						  list("Пристрастие к Ананасам","Неприязнь к Ананасам"),
						  list("Устойчивость к Алкоголю","Непереносимость Алкоголя"),
						  list("Непереносимость Алкоголя","Пьяный Угар"),
						  list("Сверхтяжёлый", "Тяжёлый", "Лёгкий"),
						  list("Азиат", "Украиновый"),
						  list("Толстые пальцы","Ужасный стрелок"),
						  list("Отпрыск Ночного Кошмара", "Светочувствительность"),
						  list("Святой Дух","Проклятая Кровь"),
						  list("Святой Дух","Отпрыск Кровопийцы"),
						  list("Жаждущий","Отпрыск Кровопийцы"),
						  list("Жаждущий","Инкуб"),
						  list("Жаждущий","Суккуб"),
						  list("Булки Грома","Стальные Булки"),
						  list("Сверхтяжёлый","Пожиратель", "Лёгкий"),
						  list("Звериный Дух", "Дуллахан"),
						  list("Хорошо слышимый", "Немота"),
						  list(BLUEMOON_TRAIT_NAME_SHRIEK, "Немота"),
						  list("Сотрудник НаноТрейзен", "Сотрудник Синдиката")
						  )
		//BLUEMOON ADD END
	return ..()

/datum/controller/subsystem/processing/quirks/proc/SetupQuirks()
// Sort by Positive, Negative, Neutral; and then by name
	var/list/quirk_list = sort_list(subtypesof(/datum/quirk), GLOBAL_PROC_REF(cmp_quirk_asc))

	for(var/V in quirk_list)
		var/datum/quirk/T = V
		quirks[initial(T.name)] = T
		quirk_points[initial(T.name)] = initial(T.value)
		quirk_names_by_path[T] = initial(T.name)

/datum/controller/subsystem/processing/quirks/proc/AssignQuirks(mob/living/user, client/cli, spawn_effects, roundstart = FALSE, datum/job/job, silent = FALSE, mob/to_chat_target)
	var/badquirk = FALSE
	var/list/my_quirks = cli.prefs.all_quirks.Copy()
	var/list/cut
	if(job?.blacklisted_quirks)
		cut = filter_quirks(my_quirks, job.blacklisted_quirks)
		if(LAZYLEN(cut))
			log_admin("Quirks cut from [key_name(user)] due to job blacklist: [english_list(cut)]")
	for(var/V in my_quirks)
		if(V in quirks)
			var/datum/quirk/Q = quirks[V]
			user.add_quirk(Q, spawn_effects)
		else
			log_admin("Invalid quirk \"[V]\" in client [cli.ckey] preferences")
			cli.prefs.all_quirks -= V
			badquirk = TRUE
	if(badquirk)
		cli.prefs.save_character()
	if (!silent && LAZYLEN(cut))
		to_chat(to_chat_target || user, "<span class='boldwarning'>Some quirks have been cut from your character because of these quirks conflicting with your job assignment: [english_list(cut)].</span>")

	var/mob/living/carbon/human/H = user
	if(istype(H) && H.dna?.species)
		var/datum/species/S = H.dna.species
		if(S.remove_blacklisted_quirks(H))
			to_chat(to_chat_target || user, "<span class='boldwarning'>Some quirks have been cut from your character due to them conflicting with your species: [english_list(S.removed_quirks)]</span>")
			if(LAZYLEN(S.removed_quirks))
				log_admin("Quirks cut from [key_name(user)] due to species blacklist: [english_list(S.removed_quirks)]")

/datum/controller/subsystem/processing/quirks/proc/quirk_path_by_name(name)
	return quirks[name]

/datum/controller/subsystem/processing/quirks/proc/quirk_points_by_name(name)
	return quirk_points[name]

/datum/controller/subsystem/processing/quirks/proc/quirk_name_by_path(path)
	return quirk_names_by_path[path]

/datum/controller/subsystem/processing/quirks/proc/total_points(list/quirk_names)
	. = 0
	for(var/i in quirk_names)
		. += quirk_points_by_name(i)

/datum/controller/subsystem/processing/quirks/proc/filter_quirks(list/our_quirks, list/blacklisted_quirks)
	var/list/cut = list()
	var/list/banned_names = list()
	var/pointscut = 0
	for(var/i in blacklisted_quirks)
		var/name = quirk_name_by_path(i)
		if(name)
			banned_names += name
	var/list/blacklisted = our_quirks & banned_names
	if(length(blacklisted))
		for(var/i in blacklisted)
			our_quirks -= i
			cut += i
			pointscut += quirk_points_by_name(i)
	if (pointscut != 0)
		for (var/i in shuffle(our_quirks))
			if (quirk_points_by_name(i) < pointscut || (pointscut < 0) ? quirk_points_by_name(i) <= 0 : quirk_points_by_name(i) >= 0)
				continue
			else
				our_quirks -= i
				cut += i
				pointscut += quirk_points_by_name(i)
			if (pointscut >= 0)
				break
	/*	//Code to automatically reduce positive quirks until balance is even.
	var/points_used = total_points(our_quirks)
	if(points_used > 0)
		//they owe us points, let's collect.
		for(var/i in our_quirks)
			var/points = quirk_points_by_name(i)
			if(points > 0)
				cut += i
				our_quirks -= i
				points_used -= points
			if(points_used <= 0)
				break

	 //Nah, let's null all non-neutrals out.
	if (pointscut < 0)// only if the pointscutting didn't work.
		if(cut.len)
			for(var/i in our_quirks)
				if(quirk_points_by_name(i) != 0)
					//cut += i		-- Commented out: Only show the ones that triggered the quirk purge.
					our_quirks -= i
	*/

	return cut
