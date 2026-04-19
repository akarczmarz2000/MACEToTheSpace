/obj/machinery/cryopod/simple
    name = "cryogenic storage pod"
    desc = "A pod for long-term crew storage."
    icon = 'icons/obj/machines/cryogenic2.dmi'
    icon_state = "cryopod"
    density = TRUE
    anchored = TRUE

/obj/machinery/cryopod/simple/attack_hand(mob/living/user)
    . = ..()

    if(!isliving(user))
        return

    if(user.incapacitated())
        return

    if(!Adjacent(user))
        return

    if(alert(user, "Enter cryogenic storage? Your body will be removed from the round.", "Cryopod", "Yes", "No") != "Yes")
        return

    begin_cryo(user)

/obj/machinery/cryopod/simple/proc/begin_cryo(mob/living/target)
    if(!target || QDELETED(target))
        return

    icon_state = "cryopod-open"

    target.visible_message(
        span_notice("[target] climbs into [src]."),
        span_notice("You enter [src] and are placed into storage.")
    )

    if(target.buckled)
        target.buckled.unbuckle_mob(target)

    // Drop held items so cryo does not delete gear in hands
    for(var/obj/item/I in target.held_items)
        if(I)
            target.dropItemToGround(I)

    log_game("[key_name(target)] entered cryogenic storage at [loc_name(get_turf(src))].")

    if(target.client)
        target.ghostize(FALSE)

    qdel(target)

    icon_state = "cryopod"