//TODO: someone please get rid of this shit
/datum/datacore
	var/list/medical = list()
	var/medicalPrintCount = 0
	var/list/general = list()
	var/list/security = list()
	var/securityPrintCount = 0
	var/securityCrimeCounter = 0
	///This list tracks characters spawned in the world and cannot be modified in-game. Currently referenced by respawn_character().
	var/list/locked = list()

/datum/data
	var/name = "data"

/datum/data/record
	name = "record"
	var/list/fields = list()

/datum/data/record/Destroy()
	if(src in GLOB.data_core.medical)
		GLOB.data_core.medical -= src
	if(src in GLOB.data_core.security)
		GLOB.data_core.security -= src
	if(src in GLOB.data_core.general)
		GLOB.data_core.general -= src
	if(src in GLOB.data_core.locked)
		GLOB.data_core.locked -= src
	. = ..()

/datum/data/crime
	name = "crime"
	var/crimeName = ""
	var/crimeDetails = ""
	var/author = ""
	var/time = ""
	var/dataId = 0
	// BLUEMOON ADD START - авторизация ЦК и возможность пометить правонарушение как уже обработанное
	var/centcom_enforced = FALSE // Создана ли данная запись сотрудниками ЦК
	var/penalties_incurred = FALSE // Понёс ли субъект наказание за свои преступления
	// BLUEMOON ADD END

/datum/datacore/proc/createCrimeEntry(cname = "", cdetails = "", author = "", time = "", centcom_enforced = FALSE) // BLUEMOON EDIT - авторизация ЦК
	var/datum/data/crime/c = new /datum/data/crime
	c.crimeName = cname
	c.crimeDetails = cdetails
	c.author = author
	c.time = time
	c.dataId = ++securityCrimeCounter
	c.centcom_enforced = centcom_enforced // BLUEMOON EDIT - авторизация ЦК
	return c

/datum/datacore/proc/addMinorCrime(id = "", datum/data/crime/crime)
	for(var/datum/data/record/R in security)
		if(R.fields["id"] == id)
			var/list/crimes = R.fields["mi_crim"]
			crimes |= crime
			return

/datum/datacore/proc/removeMinorCrime(id, cDataId, centcom_authority = FALSE) // BLUEMOON EDIT - авторизация ЦК
	for(var/datum/data/record/R in security)
		if(R.fields["id"] == id)
			var/list/crimes = R.fields["mi_crim"]
			for(var/datum/data/crime/crime in crimes)
				if(crime.dataId == text2num(cDataId))
					if(crime.centcom_enforced && !centcom_authority) // BLUEMOON EDIT - авторизация ЦК
						return
					crimes -= crime
					return

/datum/datacore/proc/removeMajorCrime(id, cDataId, centcom_authority = FALSE) // BLUEMOON EDIT - авторизация ЦК
	for(var/datum/data/record/R in security)
		if(R.fields["id"] == id)
			var/list/crimes = R.fields["ma_crim"]
			for(var/datum/data/crime/crime in crimes)
				if(crime.dataId == text2num(cDataId))
					if(crime.centcom_enforced && !centcom_authority) // BLUEMOON EDIT - авторизация ЦК
						return
					crimes -= crime
					return

/datum/datacore/proc/addMajorCrime(id = "", datum/data/crime/crime)
	for(var/datum/data/record/R in security)
		if(R.fields["id"] == id)
			var/list/crimes = R.fields["ma_crim"]
			crimes |= crime
			return

// BLUEMOON ADD START - возможность пометить правонарушение как обработанное | Логи
/datum/datacore/proc/switch_incur(id, cDataId)
	for(var/datum/data/record/R in security)
		if(R.fields["id"] == id)
			var/list/crimes = R.fields["mi_crim"] + R.fields["ma_crim"]
			for(var/datum/data/crime/crime in crimes)
				if(crime.dataId == text2num(cDataId))
					crime.penalties_incurred = !crime.penalties_incurred
					return

/datum/datacore/proc/get_actions_logs(id)
	for(var/datum/data/record/R in security)
		if(R.fields["id"] == id)
			var/list/logs = R.fields["actions_logs"]
			return logs

/datum/datacore/proc/append_sec_logs(id, log, auth_name, auth_rank)
	for(var/datum/data/record/R in security)
		if(R.fields["id"] == id)
			var/timestamp = "\[[STATION_TIME_TIMESTAMP("hh:mm:ss", world.time)]\]"
			var/log_text = "<b>[timestamp]</b> [log]"
			log_text = replacetext(log_text, "%%RANK%%", "<u>[auth_rank]</u>")
			log_text = replacetext(log_text, "%%AUTH%%", "<u>[auth_name]</u>")
			log_text = replacetext(log_text, "%%GEN_AUTH%%", "<u>[auth_name] ([auth_rank])</u>")
			R.fields["actions_logs"] += log_text

// отдельная запись квирков когда они реально записаны
/datum/datacore/proc/notes_traits_modify(mob/living/carbon/human/H)
	var/datum/data/record/foundrecord = find_record("name", H.real_name, GLOB.data_core.medical)
	if(foundrecord)
		var/traits_dat = H.get_trait_string(TRUE)
		if(!traits_dat)
			return
		else
			foundrecord.fields["notes"] += "\n traits information as of shift start: [traits_dat]"
// BLUEMOON ADD END

/datum/datacore/proc/manifest()
	for(var/mob/dead/new_player/N in GLOB.player_list)
		if(!N?.client)
			continue
		if(N.new_character)
			log_manifest(N.ckey,N.new_character.mind,N.new_character)
		if(ishuman(N.new_character))
			manifest_inject(N.new_character, N.client, N.client.prefs)
		CHECK_TICK

/datum/datacore/proc/manifest_modify(name, assignment)
	var/datum/data/record/foundrecord = find_record("name", name, GLOB.data_core.general)
	if(foundrecord)
		foundrecord.fields["rank"] = assignment

/datum/datacore/proc/get_manifest()
	var/list/manifest_out = list()
	var/list/departments = list(
		"Command" = GLOB.command_positions,
		"Security" = GLOB.security_positions,
		"Engineering" = GLOB.engineering_positions,
		"Medical" = GLOB.medical_positions,
		"Science" = GLOB.science_positions,
		"Supply" = GLOB.supply_positions,
		"Service" = GLOB.civilian_positions,
		"Law" = GLOB.law_positions,
		"Silicon" = GLOB.nonhuman_positions
	)
	for(var/datum/data/record/t in GLOB.data_core.general)
		var/name = t.fields["name"]
		var/rank = t.fields["rank"]
		var/department_check = GetJobName(t.fields["rank"])
		var/has_department = FALSE
		for(var/department in departments)
			var/list/jobs = departments[department]
			if(department_check in jobs)
				if(!manifest_out[department])
					manifest_out[department] = list()
				// Append to beginning of list if captain or department head
				if (department_check == "Captain" || (department != "Command" && (rank in GLOB.command_positions)))
					manifest_out[department] = list(list(
						"name" = name,
						"rank" = rank,
						"department_check" = department_check
					)) + manifest_out[department]
				else
					manifest_out[department] += list(list(
						"name" = name,
						"rank" = rank,
						"department_check" = department_check
					))
				has_department = TRUE
		if(!has_department)
			if(!manifest_out["Misc"])
				manifest_out["Misc"] = list()
			manifest_out["Misc"] += list(list(
				"name" = name,
				"rank" = rank,
				"department_check" = department_check
			))
	return manifest_out

/datum/datacore/proc/get_manifest_bm(monochrome, OOC)
	var/list/heads = list()
	var/list/sec = list()
	var/list/eng = list()
	var/list/med = list()
	var/list/sci = list()
	var/list/sup = list()
	var/list/civ = list()
	var/list/law = list()
	var/list/bot = list()
	var/list/misc = list()
	var/dat = {"
	<head><style>
		.manifest {border-collapse:collapse;}
		.manifest td, th {border:1px solid [monochrome?"black":"#DEF; background-color:white; color:black"]; padding:.25em}
		.manifest th {height: 2em; [monochrome?"border-top-width: 3px":"background-color: #48C; color:white"]}
		.manifest tr.head th { [monochrome?"border-top-width: 1px":"background-color: #488;"] }
		.manifest td:first-child {text-align:right}
		.manifest tr.alt td {[monochrome?"border-top-width: 2px":"background-color: #DEF"]}
	</style></head>
	<table class="manifest" width='350px'>
	<tr class='head'><th>Name</th><th>Rank</th></tr>
	"}
	var/even = 0
	// sort mobs
	for(var/datum/data/record/t in GLOB.data_core.general)
		var/name = t.fields["name"]
		var/rank = t.fields["rank"]
		var/department_check = GetJobName(t.fields["rank"])
		var/department = 0
		if(department_check in GLOB.command_positions)
			heads[name] = rank
			department = 1
		if(department_check in GLOB.security_positions)
			sec[name] = rank
			department = 1
		if(department_check in GLOB.engineering_positions)
			eng[name] = rank
			department = 1
		if(department_check in GLOB.medical_positions)
			med[name] = rank
			department = 1
		if(department_check in GLOB.science_positions)
			sci[name] = rank
			department = 1
		if(department_check in GLOB.supply_positions)
			sup[name] = rank
			department = 1
		if(department_check in GLOB.civilian_positions)
			civ[name] = rank
			department = 1
		if(department_check in GLOB.law_positions)
			law[name] = rank
			department = 1
		if(department_check in GLOB.nonhuman_positions)
			bot[name] = rank
			department = 1
		if(!department && !(name in heads))
			misc[name] = rank
	if(heads.len > 0)
		dat += "<tr><th colspan=3>Heads</th></tr>"
		for(var/name in heads)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[heads[name]]</td></tr>"
			even = !even
	if(sec.len > 0)
		dat += "<tr><th colspan=3>Security</th></tr>"
		for(var/name in sec)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[sec[name]]</td></tr>"
			even = !even
	if(eng.len > 0)
		dat += "<tr><th colspan=3>Engineering</th></tr>"
		for(var/name in eng)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[eng[name]]</td></tr>"
			even = !even
	if(med.len > 0)
		dat += "<tr><th colspan=3>Medical</th></tr>"
		for(var/name in med)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[med[name]]</td></tr>"
			even = !even
	if(sci.len > 0)
		dat += "<tr><th colspan=3>Science</th></tr>"
		for(var/name in sci)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[sci[name]]</td></tr>"
			even = !even
	if(sup.len > 0)
		dat += "<tr><th colspan=3>Supply</th></tr>"
		for(var/name in sup)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[sup[name]]</td></tr>"
			even = !even
	if(law.len > 0)
		dat += "<tr><th colspan=3>Law</th></tr>"
		for(var/name in law)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[law[name]]</td></tr>"
			even = !even
	if(civ.len > 0)
		dat += "<tr><th colspan=3>Civilian</th></tr>"
		for(var/name in civ)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[civ[name]]</td></tr>"
			even = !even
	// in case somebody is insane and added them to the manifest, why not
	if(bot.len > 0)
		dat += "<tr><th colspan=3>Silicon</th></tr>"
		for(var/name in bot)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[bot[name]]</td></tr>"
			even = !even
	// misc guys
	if(misc.len > 0)
		dat += "<tr><th colspan=3>Miscellaneous</th></tr>"
		for(var/name in misc)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[misc[name]]</td></tr>"
			even = !even

	dat += "</table>"
	dat = replacetext(dat, "\n", "")
	dat = replacetext(dat, "\t", "")
	return dat

/datum/datacore/proc/manifest_inject(mob/living/carbon/human/H, client/C, datum/preferences/prefs)
	set waitfor = FALSE
	var/static/list/show_directions = list(SOUTH, WEST)
	if(H.mind && (H.mind.assigned_role != H.mind.special_role)  && (H.mind.assigned_role != "Stowaway"))
		var/assignment
		if(H.mind.assigned_role)
			assignment = H.mind.assigned_role
		else if(H.job)
			assignment = H.job
		else
			assignment = "Unassigned"
		if(C && C.prefs && C.prefs.alt_titles_preferences[assignment])
			assignment = C.prefs.alt_titles_preferences[assignment]

		var/static/record_id_num = 1001
		var/id = num2hex(record_id_num++,6)
		if(!C)
			C = H.client
		var/image = get_id_photo(H, C, show_directions)
		var/datum/picture/pf = new
		var/datum/picture/ps = new
		pf.picture_name = "[H]"
		ps.picture_name = "[H]"
		pf.picture_desc = "This is [H]."
		ps.picture_desc = "This is [H]."
		pf.picture_image = icon(image, dir = SOUTH)
		ps.picture_image = icon(image, dir = WEST)
		var/obj/item/photo/photo_front = new(null, pf)
		var/obj/item/photo/photo_side = new(null, ps)

		//These records should ~really~ be merged or something
		//General Record
		var/datum/data/record/G = new()
		G.fields["id"]			= id
		G.fields["name"]		= H.real_name
		G.fields["rank"]		= assignment
		G.fields["real_rank"]	= GetJobName(assignment)
		G.fields["age"]			= H.age
		G.fields["species"]		= H.dna.species.name
		G.fields["fingerprint"]	= md5(H.dna.uni_identity)
		G.fields["p_stat"]		= "Active"
		G.fields["m_stat"]		= "Stable"
		if(H.gender == MALE)
			G.fields["gender"]  = "Male"
		else if(H.gender == FEMALE)
			G.fields["gender"]  = "Female"
		else
			G.fields["gender"]  = "Other"
		G.fields["photo_front"]	= photo_front
		G.fields["photo_side"]	= photo_side
		general += G

		//Medical Record
		var/datum/data/record/M = new()
		M.fields["id"]			= id
		M.fields["name"]		= H.real_name
		M.fields["blood_type"]	= H.dna.blood_type
		M.fields["b_dna"]		= H.dna.unique_enzymes
		M.fields["mi_dis"]		= "None"
		M.fields["mi_dis_d"]	= "No minor disabilities have been declared."
		M.fields["ma_dis"]		= "None"
		M.fields["ma_dis_d"]	= "No major disabilities have been diagnosed."
		M.fields["alg"]			= "None"
		M.fields["alg_d"]		= "No allergies have been detected in this patient."
		M.fields["cdi"]			= "None"
		M.fields["cdi_d"]		= "No diseases have been diagnosed at the moment."
		M.fields["notes"]		= "[prefs.medical_records]"
		medical += M

		//Security Record
		var/datum/data/record/S = new()
		S.fields["id"]			= id
		S.fields["name"]		= H.real_name
		S.fields["criminal"]	= SEC_RECORD_STATUS_NONE
		S.fields["mi_crim"]		= list()
		S.fields["mi_crim_d"]	= list()
		S.fields["ma_crim"]		= list()
		S.fields["ma_crim_d"]	= "No major crime convictions."
		S.fields["notes"]		= prefs.security_records || "No notes."
		// BLUEMOON ADD START - логи
		S.fields["actions_logs"] = list(
			"<u>[GLOB.current_date_string] | [STATION_TIME_TIMESTAMP("hh:mm:ss", world.time)] ЗАПИСЬ НАЧАТА. СУБЪЕКТ - [H.real_name] | [assignment] | [id];</u><br>"
			)
		// BLUEMOON ADD END
		LAZYINITLIST(S.fields["comments"])
		security += S

		//Locked Record
		var/datum/data/record/L = new()
		L.fields["id"]			= md5("[H.real_name][H.mind.assigned_role]")	//surely this should just be id, like the others?
		L.fields["name"]		= H.real_name
		L.fields["rank"] 		= assignment
		L.fields["real_rank"]	= GetJobName(assignment)
		L.fields["age"]			= H.age
		if(H.gender == MALE)
			G.fields["gender"]  = "Male"
		else if(H.gender == FEMALE)
			G.fields["gender"]  = "Female"
		else
			G.fields["gender"]  = "Other"
		L.fields["blood_type"]	= H.dna.blood_type
		L.fields["b_dna"]		= H.dna.unique_enzymes
		L.fields["identity"]	= H.dna.uni_identity
		L.fields["species"]		= H.dna.species.type
		L.fields["features"]	= H.dna.features
		L.fields["image"]		= image
		L.fields["mindref"]		= H.mind
		locked += L
	return

/datum/datacore/proc/get_id_photo(mob/living/carbon/human/H, client/C, show_directions = list(SOUTH))
	var/datum/job/J = SSjob.GetJob(H.mind.assigned_role)
	var/datum/preferences/P
	if(!C)
		C = H.client
	if(C)
		P = C.prefs
	return get_flat_human_icon(null, J, P, DUMMY_HUMAN_SLOT_MANIFEST, show_directions)
