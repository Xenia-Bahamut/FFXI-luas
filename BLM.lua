-- Original: Motenten / Modified: Arislan
-- Modified by Xenia of Bahamut

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ CTRL+F11 ]        Cycle Casting Modes
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ ALT+` ]           Toggle Magic Burst Mode
--              [ WIN+O ]           Cycle VR Ring Mode
--              [ WIN+D ]           Toggle Death Casting Mode Toggle
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Spells:     [ CTRL+` ]          Stun
--              [ ALT+P ]           Shock Spikes
--
--  Weapons:    [ CTRL+W ]          Toggles Weapon Lock
--
--  WS:         [ CTRL+Numpad0 ]    Myrkr
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()

    -- state.CP = M(false, "Capacity Points Mode")

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}

    degrade_array = {
        ['Aspirs'] = {'Aspir','Aspir II','Aspir III'}
        }

    lockstyleset = 88

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.CastingMode:options('Normal', 'Resistant', 'Spaekona', 'OccultAcumen')
    state.IdleMode:options('Normal', 'DT')

    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    state.DeathMode = M(false, 'Death Mode')
    state.VRRing = M(false, 'VRRing')
    state.CP = M(false, "Capacity Points Mode")

    state.BarElement = M{['description']='BarElement', 'Barfire', 'Barblizzard', 'Baraero', 'Barstone', 'Barthunder', 'Barwater'}
    state.BarStatus = M{['description']='BarStatus', 'Baramnesia', 'Barvirus', 'Barparalyze', 'Barsilence', 'Barpetrify', 'Barpoison', 'Barblind', 'Barsleep'}

    lowTierNukes = S{'Stone', 'Water', 'Aero', 'Fire', 'Blizzard', 'Thunder'}

    -- Additional local binds
    --include('Global-Binds.lua') -- OK to remove this line
    --include('Global-GEO-Binds.lua') -- OK to remove this line

    --loads Partybuffs lua for seeing party buffs
    send_command('lua l partybuffs')

    send_command('bind ^` input /ma Stun <t>')
    send_command('bind !` gs c toggle MagicBurst')
    send_command('bind !w input /ma "Aspir III" <t>')
    send_command('bind !p input /ma "Shock Spikes" <me>')
    send_command('bind @d gs c toggle DeathMode')
    -- send_command('bind @c gs c toggle CP')
    send_command('bind @w gs c toggle WeaponLock')
    send_command('bind @o gs c toggle VRRing')
    send_command('bind ^numpad0 input /Myrkr')

    select_default_macro_book()
    set_lockstyle()

    state.Auto_Kite = M(false, 'Auto_Kite')
    moving = false
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind !w')
    send_command('unbind !p')
    send_command('unbind ^,')
    send_command('unbind !.')
    send_command('unbind @d')
    -- send_command('unbind @c')
    send_command('unbind @w')
    send_command('unbind ^numpad0')

    send_command('unbind #`')
    send_command('unbind #1')
    send_command('unbind #2')
    send_command('unbind #3')
    send_command('unbind #4')
    send_command('unbind #5')
    send_command('unbind #6')
    send_command('unbind #7')
    send_command('unbind #8')
    send_command('unbind #9')
    send_command('unbind #0')

    send_command('lua u partybuffs')
    send_command('lua u dparty')

end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    ---- Precast Sets ----

    -- Precast sets to enhance JAs
    sets.precast.JA['Mana Wall'] = {
        feet="Wicce Sabots +3",
        back="Taranus's Cape",
        }

    sets.precast.JA.Manafont = {body="Archmage's Coat"}

    -- Fast cast sets for spells
    sets.precast.FC = {
        --cap of 80. 70 + 15 if /RDM
        --Total: 96 FC
        --main  *** Fast cast weapon. Add to total
        ammo="Sapience Orb", --2
        head={ name="Merlinic Hood", augments={'"Fast Cast"+6','"Mag.Atk.Bns."+12',}}, --14
        body="Zendik Robe", --13
        hands="Agwu's Gages", --6
        --legs="Volte Brais", --8
        legs="Psycloth Lappas", --7
        feet="Amalric Nails +1", --6
        neck="Orunmila's Torque", --5
        ear1="Malignance Earring", --4
        ear2="Loquacious Earring", --2
        ring1="Lebeche Ring", --QM2
        ring2="Kishar Ring", --4
        back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},
        waist="Embla Sash", --5
        }

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
        waist="Siegel Sash", --10
        back="Perimede Cape",
        })

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {})

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
        hands="Vanya Cuffs", --7
        ear1="Mendicant's Earring", --5
        ring1="Lebeche Ring", --QM+2
        })

    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Twilight Cloak", waist="Shinjutsu-no-Obi +1"})
    sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield", waist="Shinjutsu-no-Obi +1"})
    sets.precast.Storm = set_combine(sets.precast.FC, {ring2={name="Stikini Ring +1", bag="wardrobe5"},})

    sets.precast.FC.DeathMode = {
        ammo="Sapience Orb",
        head="Amalric Coif +1", --11
        body="Rosette Jaseran +1",
        hands="Agwu's Gages",
        legs="Psycloth Lappas", --7
        --feet="Amalric Nails +1", --Path A or B
        feet="Agwu's Pigaches",
        neck="Orunmila's Torque", --5
        ear1="Etiolation Earring", --1
        ear2="Loquacious Earring", --2
        ring1="Mephitas's Ring +1",
        --ring2="Mephitas's Ring",
        ring2="Lebeche Ring",
        back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},
        --waist="Shinjutsu-no-Obi +1",
        waist="Embla Sash",
        }

    sets.precast.FC.Impact.DeathMode = set_combine(sets.precast.FC.DeathMode, {head=empty, body="Twilight Cloak", waist="Shinjutsu-no-Obi +1"})

    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        ear1="Moonshade Earring",
        ear2="Telos Earring",
        ring1="Epaminondas's Ring",
        ring2="Karieyh Ring +1",
        waist="Fotia Belt",
        }

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.

    sets.precast.WS['Vidohunir'] = {
        ammo="Ghastly Tathlum +1",
        head="Pixie Hairpin +1",
        --body="Amalric Doublet +1",
        hands="Amalric Gages +1",
        --legs="Merlinic Shalwar",
        feet="Archmage's Sabots +3", --***Update later
        neck="Baetyl Pendant",
        ear1="Malignance Earring",
        ear2="Moonshade Earring",
        ring1="Epaminondas's Ring",
        ring2="Archon Ring",
        back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
        waist="Acuity Belt +1",
        } -- INT

    sets.precast.WS['Myrkr'] = {
        --Removes 3 debuffs and restores MP: 1000 TP=20%, 2000 TP=40%, 3000 TP=60%
        --Aim for max MP
        ammo="Psilomene",
        head="Pixie Hairpin +1",
        --body="Amalric Doublet +1",
        body="Rosette Jaseran +1",
        hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
        legs="Amalric Slops +1",
        feet="Medium's Sabots",
        neck="Orunmila's Torque",
        ear1="Etiolation Earring",
        ear2="Loquacious Earring",
        ring1="Mephitas's Ring +1",
        --ring2="Mephitas's Ring",
        ring2="Lebeche Ring",
        back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},
        waist="Shinjutsu-no-Obi +1",
        } -- Max MP

    sets.precast.WS['Earth Crusher'] = {
        --AoE earth damage.
        --Modifiers: 40% STR, 40% INT
        ammo="Ghastly Tathlum +1",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Agwu's Gages",
        legs="Nyame Flanchard",
        feet="Agwu's Pigaches",
        --neck="Quanpur Necklace",
        neck="Saevus Pendant +1",
        ear1="Malignance Earring",
        ear2="Moonshade Earring",
        ring1="Epaminondas's Ring",
        ring2="Metamorph Ring +1",
        --back="Oretania's Cape +1",
        back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},
        --waist="Orpheus's Sash",
        waist="Acuity Belt +1",
        }


    ---- Midcast Sets ----

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.Cure = {
        main="Daybreak", --30
        sub="Sors Shield", --3/(-5)
        ammo="Esper Stone +1", --0/(-5)
        head={ name="Vanya Hood", augments={'MND+10','Spell interruption rate down +15%','"Conserve MP"+6',}}, --Cure Pot +10
        --body="Vanya Robe", 
        body="Vrikodara Jupon", --+13
        hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
        legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        feet="Vanya Clogs", --5  Path B 
        neck="Nodens Gorget", --5
        ear1="Mendicant's Earring", --5
        --ear2="Roundel Earring", --5
        ear2="Meili Earring",
        ring1="Lebeche Ring", --3/(-5)
        --ring2="Haoma's Ring",
        ring2="Menelaus's Ring",
        --back="Oretania's Cape +1", --6
        --back=AMBU CAPE ***
        back="Tempered Cape +1",
        waist="Bishop's Sash",
        }

    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
        neck="Nuna Gorget +1",
        ring1={name="Stikini Ring +1", bag="wardrobe2"},
        ring2="Metamorph Ring +1",
        waist="Luminary Sash",
        })

    sets.midcast.Cursna = set_combine(sets.midcast.Cure, {
        main="Gada",
        sub="Genmei Shield",
        head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        body="Vanya Robe",
        hands="Hieros Mittens",
        feet="Vanya Clogs",
        neck="Debilis Medallion",
        ear1="Beatific Earring",
        ear2="Meili Earring",
        ring1="Menelaus's Ring",
        ring2="Haoma's Ring",
        })

    sets.midcast.Raise = sets.midcast.FastRecast
    sets.midcast.Erase = sets.midcast.FastRecast

    sets.midcast['Enhancing Magic'] = {
        --Want as much as you can get. Aim for 500 skill
        main="Gada",
        sub="Ammurapi Shield",
        head={ name="Telchine Cap", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        body={ name="Telchine Chas.", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
        legs={ name="Telchine Braconi", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        feet={ name="Telchine Pigaches", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        neck="Incanter's Torque",
        ear1="Mimir Earring",
        ear2="Andoaa Earring",
        ring1 = {name="Stikini Ring +1", bag="wardrobe2"}, --8
        ring2 = {name="Stikini Ring +1", bag="wardrobe5"}, --8
        back="Fi Follet Cape +1",
        waist="Olympus Sash",
        }

    sets.midcast.EnhancingDuration = set_combine(sets.midcast['Enhancing Magic'], {
        main="Gada",
        sub="Ammurapi Shield",
        waist="Embla Sash",
        })

    sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {
        main="Bolelabunga",
        sub="Ammurapi Shield",
        })

    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
        head="Amalric Coif +1",
        waist="Gishdubar Sash",
        back="Grapevine Cape",
        })

    sets.RefreshReceived= {
        feet="Inspirited Boots",
        waist="Gishdubar Sash",
        back="Grapevine Cape",
        }

    sets.midcast.Stoneskin = set_combine(sets.midcast.EnhancingDuration, {
        legs="Shedir Seraweels",
        neck="Nodens Gorget",
        waist="Siegel Sash",
        })

    sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {
        main="Vadose Rod",
        sub="Ammurapi Shield",
        ammo="Staunch Tathlum +1",
        head="Amalric Coif +1",
        hands="Regal Cuffs",
        legs="Shedir Seraweels",
        ear1="Halasz Earring",
        ring1="Freke Ring",
        ring2="Evanescence Ring",
        waist="Emphatikos Rope",
        })

    sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'], {
        head="Befouled Crown",
        legs="Shedir Seraweels",
        })

    sets.midcast['Phalanx'] = set_combine(sets.midcast.EnhancingDuration, {
        feet={ name="Chironic Slippers", augments={'Pet: AGI+3','Pet: Mag. Acc.+15','Phalanx +4','Accuracy+20 Attack+20',}},
        })

    sets.phalanx = sets.midcast['Phalanx']
    sets.Phalanx = sets.midcast['Phalanx']

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {ring1="Sheltered Ring"})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Protect

    sets.ProtectShellReceived = {
        ring1="Sheltered Ring",
        }

    sets.midcast.MndEnfeebles = {
        main="Contemplator +1",
        sub="Khonsu",
        ammo="Pemphredo Tathlum",
        head=empty,
        body="Cohort Cloak +1",
        hands="Regal Cuffs",
        --legs="Ea Slops +1",
        --legs="Spaekona's Tonban +3",
        legs="Psycloth Lappas",
        --feet="Spaekona's Sabots +3",
        feet="Skaoi Boots",
        neck="Sorcerer's Stole +1",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1 = {name="Stikini Ring +1", bag="wardrobe2"},
        ring2 = {name="Stikini Ring +1", bag="wardrobe5"},
        back="Aurist's Cape +1",
        waist="Luminary Sash",
        } -- MND/Magic accuracy

    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
        main="Maxentius",
        sub="Ammurapi Shield",
        ring1="Kishar Ring",
        ring2="Metamorph Ring +1",
        waist="Acuity Belt +1",
        }) -- INT/Magic accuracy

    sets.midcast.EleDebuff = set_combine(sets.midcast.IntEnfeebles, {
        -- INT/Magic accuracy
        main="Contemplator +1",
        sub="Khonsu",
        sub="Enki Strap",
        --hands="Spaekona's Gloves +3",
        legs="Archmage's Tonban +3",
        feet="Archmage's Sabots +3",
        ring1 = {name="Stikini Ring +1", bag="wardrobe2"},
        }) 

    sets.midcast.ElementalEnfeeble = sets.midcast.IntEnfeebles
    sets.midcast.Dispelga = set_combine(sets.midcast.IntEnfeebles, {main="Daybreak", sub="Ammurapi Shield", waist="Shinjutsu-no-Obi +1"})

    sets.midcast['Dark Magic'] = {
        main="Rubicundity",
        sub="Ammurapi Shield",
        ammo="Pemphredo Tathlum",
        --head="Ea Hat +1",
        head="Merlinic Hood",
        --body="Ea Houppe +1",
        --hands="Raetic Bangles +1",
        --hands="Archmage's Gloves +3",
        hands={ name="Merlinic Dastanas", augments={'"Drain" and "Aspir" potency +11','MND+1',}},
        --legs="Ea Slops +1",
        --legs="Spaekona's Tonban +3",
        legs="Agwu's Slops",
        feet="Agwu's Pigaches",
        neck="Erra Pendant",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1 = {name="Stikini Ring +1", bag="wardrobe2"},
        ring2 = {name="Stikini Ring +1", bag="wardrobe5"},
        back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
        waist="Acuity Belt +1",
        }

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        head="Pixie Hairpin +1",
        ear1="Hirudinea Earring",
        ring1="Evanescence Ring",
        ring2="Archon Ring",
        waist="Fucho-no-obi",
        })

    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {
        --feet="Volte Gaiters",
        })

    sets.midcast.Death = {
        main="Bunzi's Rod",
        sub="Culminus",
        ammo="Ghastly Tathlum +1",
        head="Pixie Hairpin +1",
        --body="Amalric Doublet +1", --Path A or B
        body="Wicce Coat +3",
        --hands="Amalric Gages +1", --Path A or B
        hands="Agwu's Gages",
        --legs="Amalric Slops +1", --Path A or B
        legs="Agwu's Slops",
        --feet="Amalric Nails +1", --Path A or B
        feet="Amalric Nails +1",
        neck="Sanctity Necklace",
        ear1="Barkarole Earring",
        ear2="Etiolation Earring",
        ring1="Mephitas's Ring +1",
        ring2="Archon Ring",
        back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},
        --waist="Shinjutsu-no-Obi +1",
        waist="Acuity Belt +1",
        }

    sets.midcast.Death.Resistant = set_combine(sets.midcast.Death, {
        head="Amalric Coif +1",
        body="Wicce Coat +3",
        --hands="Spaekona's Gloves +3",
        --legs="Spaekona's Tonban +3",
        feet="Wicce Sabots +3",
        ear2="Regal Earring",
        waist="Acuity Belt +1",
        })

    --sets.midcast.Death.Burst = set_combine(sets.midcast.Death, {
        --***Needs input and coding below
        --})

    --sets.midcast.Death.Burst.Resistant = set_combine(sets.midcast.Death, {
        --***Needs input and coding below
        --})


    -- Elemental Magic sets

    sets.midcast['Elemental Magic'] = {
        main="Bunzi's Rod",
        sub="Ammurapi Shield",
        ammo="Ghastly Tathlum +1",
        head="Wicce Petasos +3",
        body="Wicce Coat +3",
        hands="Wicce Gloves +3",
        legs="Wicce Chausses +3",
        feet="Wicce Sabots +3",
        neck="Sorcerer's Stole +1",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1="Freke Ring",
        ring2="Metamorph Ring +1",
        back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
        waist="Acuity Belt +1",
        }

    sets.midcast['Elemental Magic'].DeathMode = set_combine(sets.midcast['Elemental Magic'], {
        sub="Enki Strap",
        ammo="Ghastly Tathlum +1",
        legs="Amalric Slops +1",
        feet="Amalric Nails +1",
        back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},
        })

    sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
        sub="Khonsu",
        ammo="Pemphredo Tathlum",
        neck="Sanctity Necklace",
        waist="Sacro Cord",
        })

    sets.midcast['Elemental Magic'].Spaekona = set_combine(sets.midcast['Elemental Magic'], {
        body="Spaekona's Coat +3",
        --legs="Merlinic Shalwar",
        })

    sets.midcast['Elemental Magic'].OccultAcumen = set_combine(sets.midcast['Elemental Magic'], {
        main="Khatvanga",
        sub="Bloodrain Strap",
        ammo="Seraphic Ampulla",
        --head="Mallquis Chapeau +2",
        head="Merlinic Hood", --***Need occult acumen augs
        body="Spaekona's Coat +3",
        hands={ name="Merlinic Dastanas", augments={'"Mag.Atk.Bns."+15','"Occult Acumen"+11','Mag. Acc.+12',}},
        legs="Perdition Slops",
        feet={ name="Merlinic Crackows", augments={'Mag. Acc.+7','"Occult Acumen"+10','VIT+5',}},
        neck="Combatant's Torque",
        ear1="Crepuscular Earring",
        ear2="Dedition Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe1"},
        ring2={name="Chirich Ring +1", bag="wardrobe3"},
        waist="Oneiros Rope",
        --back=    ***Need Ambu stp cape
        })


    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
        head=empty,
        body="Twilight Cloak",
        ring2="Archon Ring",
        })

    sets.midcast.Impact.Resistant = set_combine(sets.midcast['Elemental Magic'].Resistant, {
        sub="Khonsu",
        head=empty,
        body="Twilight Cloak",
        })

    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC

    sets.resting = set_combine(sets.idle, {
        main="Contemplator +1",
        waist="Shinjutsu-no-Obi +1",
        })

    -- Idle sets

    sets.idle = {
        main="Bolelabunga",
        sub="Genmei Shield",
        ammo="Ghastly Tathlum +1",
        head="Nyame Helm",
        body="Shamash Robe",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Herald's Gaiters",
        neck="Bathy Choker +1",
        ear1="Etiolation Earring",
        ear2="Infused Earring",
        ring1 = {name="Stikini Ring +1", bag="wardrobe2"},
        ring2 = {name="Stikini Ring +1", bag="wardrobe5"},
        --back="Moonlight Cape",
        back="Mecisto. Mantle",
        waist="Carrier's Sash",
        }

    sets.idle.DT = set_combine(sets.idle, {
        main="Daybreak",
        sub="Genmei Shield", --10/0
        ammo="Staunch Tathlum +1", --3/3
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Loricate Torque +1", --6/6
        ear1="Sanare Earring",
        ear2="Lugalbanda Earring",
        ring1="Gelatinous Ring +1", --7/(-1)
        ring2="Defending Ring", --10/10
        back="Moonlight Cape", --6/6
        waist="Carrier's Sash",
        })

    sets.idle.ManaWall = {
        feet="Wicce Sabots +3",
        back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},
        }

    sets.idle.DeathMode = {
        main="Bunzi's Rod",
        sub="Ammurapi Shield",
        ammo="Ghastly Tathlum +1",
        head="Wicce Petasos +3",
        body="Rosette Jaseran +1",
        hands="Agwu's Gages",
        --legs="Amalric Slops +1", --Path A or B
        legs="Nyame Flanchard",
        feet="Wicce Sabots +3",
        neck="Sanctity Necklace",
        --ear1="Nehalennia Earring",
        ear1="Halasz Earring",
        ear2="Loquacious Earring", --2
        ring1="Mephitas's Ring +1",
        --ring2="Mephitas's Ring",
        ring2="Lebeche Ring",
        back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},
        --waist="Shinjutsu-no-Obi +1",
        waist="Embla Sash",
        }

    sets.idle.Town = set_combine(sets.idle, {
        main="Bolelabunga",
        sub="Ammurapi Shield",
        head="Ea Hat +1",
        body="Ea Houppelande +1",
        legs="Ea Slops +1",
        feet="Herald's Gaiters",
        neck="Incanter's Torque",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1="Freke Ring",
        ring2="Metamorph Ring +1",
        back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
        waist="Acuity Belt +1",
        })

    -- Defense sets

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {feet="Herald's Gaiters"}
    sets.latent_refresh = {waist="Fucho-no-obi"}
    sets.latent_refresh85 = {
        head={ name="Merlinic Hood", augments={'DEX+7','Pet: "Store TP"+3','"Refresh"+2','Mag. Acc.+16 "Mag.Atk.Bns."+16',}},
        legs={ name="Merlinic Shalwar", augments={'Attack+24','"Cure" potency +1%','"Refresh"+2','Accuracy+13 Attack+13','Mag. Acc.+16 "Mag.Atk.Bns."+16',}},
        }
    sets.latent_dt = {ear2="Sorcerer's Earring"}

    sets.magic_burst = set_combine(sets.midcast['Elemental Magic'], {
        --Job Traits gives +13. JPs gives +5/6/7=13
        --Currently: MB 59, MBII 22
        main="Bunzi's Rod", --10/(0)
        sub="Ammurapi Shield",
        head="Ea Hat +1", --7/(7)
        body="Wicce Coat +3", --0/(5)
        hands="Agwu's Gages", --@r25: 8/(5) @R30: 8/(6)
        legs="Wicce Chausses +3", --15/(0)
        feet="Agwu's Pigaches", --6/(0)
        neck="Sorcerer's Stole +1",
        ring2="Mujin Band", --(5)
        back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
        })

    sets.magic_burst.Resistant = set_combine(sets. magic_burst, {
        --Stack MAcc and MB
        ammo="Pemphredo Tathlum",
        head="Wicce Petasos +3",
        hands="Wicce Gloves +3",
        ring1={name="Stikini Ring +1", bag="wardrobe2"},
        ring2="Metamorph Ring +1",
        })

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group

    sets.engaged = {
        main="Maxentius",
        sub="Ammurapi Shield",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Lissome Necklace",
        ear1="Telos Earring",
        ear2="Crepuscular Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe1"},
        ring2={name="Chirich Ring +1", bag="wardrobe3"},
        back="Aurist's Cape +1", --***needs better
        --waist="Olseni Belt",
        waist="Grunfeld Rope",
        }

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1={name="Eshmun's Ring", bag="wardrobe3"}, --20
        ring2={name="Eshmun's Ring", bag="wardrobe4"}, --20
        waist="Gishdubar Sash", --10
        }

    sets.DarkAffinity = {
        head="Pixie Hairpin +1",
        ring2="Archon Ring"
        }

    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.VRRing = {ring1="Medada's Ring"}
    -- sets.CP = {back="Mecistopins Mantle"}

    sets.TreasureHunter = {
        head="Volte Cap",
        legs="Volte Hose",
        feet="Volte Boots",
        waist="Chaac Belt",
        }

    sets.TH = sets.TreasureHunter
    sets.th = sets.TreasureHunter

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' and state.DeathMode.value then
        eventArgs.handled = true
        equip(sets.precast.FC.DeathMode)
        if spell.english == "Impact" then
            equip(sets.precast.FC.Impact.DeathMode)
        end
    end
    if spell.name:startswith('Aspir') then
        refine_various_spells(spell, action, spellMap, eventArgs)
    end
    if buffactive['Mana Wall'] then
        equip(sets.precast.JA['Mana Wall'])
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' and state.DeathMode.value then
        eventArgs.handled = true
        if spell.skill == 'Elemental Magic' then
            equip(sets.midcast['Elemental Magic'].DeathMode)
        else
            if state.CastingMode.value == "Resistant" then
                equip(sets.midcast.Death.Resistant)
            else
                equip(sets.midcast.Death)
            end
        end
    end
end

    if buffactive['Mana Wall'] then
        equip(sets.precast.JA['Mana Wall'])
    end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) and not state.DeathMode.value then
        equip(sets.midcast.EnhancingDuration)
        if spellMap == 'Refresh' then
            equip(sets.midcast.Refresh)
        end
    end
    if spell.skill == 'Elemental Magic' and spell.english == "Comet" then
        equip(sets.DarkAffinity)
    end
    if spell.skill == 'Elemental Magic' then
        if state.MagicBurst.value and spell.english ~= 'Death' then
            --if state.CastingMode.value == "Resistant" then
                --equip(sets.magic_burst.Resistant)
            --else
                equip(sets.magic_burst)
            --end
            if spell.english == "Impact" then
                equip(sets.midcast.Impact)
            end
        end
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
    end
    if spell.name == 'Drown' or spell.name == 'Shock' or spell.name == 'Rasp' or spell.name == 'Choke' or spell.name == 'Frost' or spell.name == 'Burn' then
        equip(sets.midcast.EleDebuff)
    end
    if buffactive['Mana Wall'] then
        equip(sets.precast.JA['Mana Wall'])
    end
    if spell.skill == 'Elemental Magic' and state.VRRing.value == true then
        equip(sets.VRRing)
        end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Sleep II" or spell.english == "Sleepga II" then
            send_command('@timers c "Sleep II ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
            send_command('@timers c "Sleep ['..spell.target.name..']" 60 down spells/00253.png')
        elseif spell.english == "Break" or spell.english == "Breakga" then
            send_command('@timers c "Break ['..spell.target.name..']" 30 down spells/00255.png')
        end
    end
end




-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- Unlock armor when Mana Wall buff is lost.
    if buff== "Mana Wall" then
        if gain then
            --send_command('gs enable all')
            equip(sets.precast.JA['Mana Wall'])
            --send_command('gs disable all')
        else
            --send_command('gs enable all')
            handle_equipping_gear(player.status)
        end
    end

    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
            disable('ring1','ring2','waist')
        else
            enable('ring1','ring2','waist')
            handle_equipping_gear(player.status)
        end
    end

end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
end

-- latent DT set auto equip on HP% change
    windower.register_event('hpp change', function(new, old)
        if new<=25 then
            equip(sets.latent_dt)
        end
    end)


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    check_moving()
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if spell.skill == "Enfeebling Magic" then
            if spell.type == "WhiteMagic" then
                return "MndEnfeebles"
            else
                return "IntEnfeebles"
            end
        end
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.DeathMode.value then
        idleSet = sets.idle.DeathMode
    end
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if player.mpp < 86 then
        idleSet = set_combine(idleSet, sets.latent_refresh85)
    end
    if player.hpp <= 25 then
        idleSet = set_combine(idleSet, sets.latent_dt)
    end
    -- if state.CP.current == 'on' then
    --     equip(sets.CP)
    --     disable('back')
    -- else
    --     enable('back')
    -- end
    if buffactive['Mana Wall'] then
        idleSet = set_combine(idleSet, sets.precast.JA['Mana Wall'])
    end
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end

    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if buffactive['Mana Wall'] then
        meleeSet = set_combine(meleeSet, sets.precast.JA['Mana Wall'])
    end

    return meleeSet
end

function customize_defense_set(defenseSet)
    if buffactive['Mana Wall'] then
        defenseSet = set_combine(defenseSet, sets.precast.JA['Mana Wall'])
    end

    return defenseSet
end


-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)

    local c_msg = state.CastingMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local o_msg = state.VRRingMode.value

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.MagicBurst.value then
        msg = ' Burst: On |'
    end
    if state.DeathMode.value then
        msg = msg .. ' Death: On |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(060, '| Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

function refine_various_spells(spell, action, spellMap, eventArgs)
    local aspirs = S{'Aspir','Aspir II','Aspir III'}

    local newSpell = spell.english
    local spell_recasts = windower.ffxi.get_spell_recasts()
    local cancelling = 'All '..spell.english..' are on cooldown. Cancelling.'

    local spell_index

    if spell_recasts[spell.recast_id] > 0 then
        if aspirs:contains(spell.name) then
            spell_index = table.find(degrade_array['Aspirs'],spell.name)
            if spell_index > 1 then
                newSpell = degrade_array['Aspirs'][spell_index - 1]
                send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
                eventArgs.cancel = true
            end
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
end

function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
        if type(cmdParams[4]) == 'string' then
            if cmdParams[4] == 'true' then
                moving = true
            elseif cmdParams[4] == 'false' then
                moving = false
            end
        end
        if not midaction() then
            job_update()
        end
    end
end

function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
        end
    end
end

function check_gear()
    if no_swap_gear:contains(player.equipment.left_ring) then
        disable("ring1")
    else
        enable("ring1")
    end
    if no_swap_gear:contains(player.equipment.right_ring) then
        disable("ring2")
    else
        enable("ring2")
    end
end

windower.register_event('zone change',
    function()
        if no_swap_gear:contains(player.equipment.left_ring) then
            enable("ring1")
            equip(sets.idle)
        end
        if no_swap_gear:contains(player.equipment.right_ring) then
            enable("ring2")
            equip(sets.idle)
        end
    end
)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 2)
end

function set_lockstyle()
    send_command('wait 5; input /lockstyleset ' .. lockstyleset)
end
