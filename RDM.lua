-- Original: Motenten / Modified: Arislan
-- Modified by Xenia of Bahamut
-- Haste/DW Detection Requires Gearinfo Addon

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Mode
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ WIN+E ]           Cycle Enspell TP Mode
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ CTRL+F11 ]        Cycle Casting Modes
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ ALT+` ]           Toggle Magic Burst Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+` ]          Composure
--              [ CTRL+- ]          Light Arts/Addendum: White
--              [ CTRL+= ]          Dark Arts/Addendum: Black
--              [ CTRL+; ]          Celerity/Alacrity
--              [ ALT+[ ]           Accesion/Manifestation
--              [ ALT+; ]           Penury/Parsimony
--
--  Spells:     [ CTRL+` ]          Stun
--              [ ALT+Q ]           Temper
--              [ ALT+W ]           Flurry II
--              [ ALT+E ]           Haste II
--              [ ALT+R ]           Refresh II
--              [ ALT+Y ]           Phalanx
--              [ ALT+O ]           Regen II
--              [ ALT+P ]           Shock Spikes
--              [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--              [ ALT+R ]           Cycle Regen Mode
--              [ WIN+O ]           Cycle VR Ring Mode
--              [ WIN+P ]           Cycle Phalanx Mode

--
--  Weapons:    [ CTRL+W ]          Toggles Weapon Lock
--
--  WS:         [ CTRL+Numpad9 ]    Chant Du Cygne
--              [ CTRL+Numpad7 ]    Requiescat
--              [ CTRL+Numpad4 ]    Savage Blade
--              [ CTRL+Numpad2 ]    Seraph Blade
--              [ CTRL+Numpad1 ]    Sanguine Blade
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--              Addendum Commands:
--              Shorthand versions for each strategem type that uses the version appropriate for
--              the current Arts.
--                                          Light Arts                  Dark Arts
--                                          ----------                  ---------
--              gs c scholar light          Light Arts/Addendum
--              gs c scholar dark                                       Dark Arts/Addendum
--              gs c scholar cost           Penury                      Parsimony
--              gs c scholar speed          Celerity                    Alacrity
--              gs c scholar aoe            Accession                   Manifestation
--              gs c scholar addendum       Addendum: White             Addendum: Black


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
    state.Buff.Composure = buffactive.Composure or false
    state.Buff.Saboteur = buffactive.Saboteur or false
    state.Buff.Stymie = buffactive.Stymie or false
    state.Buff.Accession = buffactive.Accession or false

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}

    enfeebling_magic_acc = S{'Bind', 'Break', 'Dispel', 'Distract', 'Distract II', 'Frazzle',
        'Frazzle II', 'Gravity', 'Gravity II', 'Silence'}
    enfeebling_magic_skill = S{'Distract III', 'Frazzle III', 'Poison II'}
    enfeebling_magic_effect = S{'Dia', 'Dia II', 'Dia III', 'Diaga', 'Blind', 'Blind II'}
    enfeebling_magic_sleep = S{'Sleep', 'Sleep II', 'Sleepga'}

    skill_spells = S{
        'Temper', 'Temper II', 'Enfire', 'Enfire II', 'Enblizzard', 'Enblizzard II', 'Enaero', 'Enaero II',
        'Enstone', 'Enstone II', 'Enthunder', 'Enthunder II', 'Enwater', 'Enwater II'}
    duration_spells = S{
        'Haste', 'Haste II', 'Flurry', 'Flurry II',}

    --include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    lockstyleset = 97
end


-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'MidAcc', 'HighAcc')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Seidr', 'Resistant')
    state.IdleMode:options('Normal', 'DT')

    state.EnSpell = M{['description']='EnSpell', 'Enfire', 'Enblizzard', 'Enaero', 'Enstone', 'Enthunder', 'Enwater'}
    state.BarElement = M{['description']='BarElement', 'Barfire', 'Barblizzard', 'Baraero', 'Barstone', 'Barthunder', 'Barwater'}
    state.BarStatus = M{['description']='BarStatus', 'Baramnesia', 'Barvirus', 'Barparalyze', 'Barsilence', 'Barpetrify', 'Barpoison', 'Barblind', 'Barsleep'}
    state.GainSpell = M{['description']='GainSpell', 'Gain-STR', 'Gain-INT', 'Gain-AGI', 'Gain-VIT', 'Gain-DEX', 'Gain-MND', 'Gain-CHR'}

    --state.Weapons:options('None', 'Naegling', 'Daybreak', 'Crocea', 'Maxentius', 'Tauret', 'NaeglingDW', 'CroceaClubDW', 'MaxentiusDW', 'AeolianDW', 'EvisDW', 'EnspellOnly')


    --state.WeaponSet = M{['description']='Weapon Set', 'CroceaDark', 'CroceaLight', 'Almace', 'Naegling', 'Maxentius', 'Idle'}

    state.WeaponSet = M{['description']='Weapon Set', 'None', 'Naegling', 'Daybreak', 'Crocea', 'Maxentius', 'Tauret', 'NaeglingDW', 'CroceaClubDW', 'MaxentiusDW', 'AeolianDW', 'EvisDW', 'EnspellOnly'}
    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    state.SleepMode = M{['description']='Sleep Mode', 'Normal', 'MaxDuration'}
    state.EnspellMode = M(false, 'Enspell Melee Mode')
    state.PhalanxMode = M{['description']='Phalanx Mode', 'Duration', 'Potency'}
    state.RegenMode = M{['description']='Regen Mode', 'Duration', 'Potency'}
    state.NM = M(false, 'NM?')
    -- state.CP = M(false, "Capacity Points Mode")

    -- Additional local binds
    --include('Global-Binds.lua') -- OK to remove this line
    --include('Global-GEO-Binds.lua') -- OK to remove this line

    --loads Partybuffs lua for seeing party buffs
    send_command('lua l partybuffs')
    send_command('lua l dparty')

    send_command('bind ^` input /ja "Composure" <me>')
    send_command('bind @t gs c cycle treasuremode')
    send_command('bind !` gs c toggle MagicBurst')

    if player.sub_job == 'SCH' then
        send_command('bind ^- gs c scholar light')
        send_command('bind ^= gs c scholar dark')
        send_command('bind !- gs c scholar addendum')
        send_command('bind != gs c scholar addendum')
        send_command('bind ^; gs c scholar speed')
        send_command('bind ![ gs c scholar aoe')
        send_command('bind !; gs c scholar cost')
    end

    send_command('bind !q input /ma "Temper II" <me>')
    send_command('bind !w input /ma "Flurry II" <stpc>')
    send_command('bind !e input /ma "Haste II" <stpc>')
    send_command('bind !r input /ma "Refresh III" <stpc>')
    send_command('bind !y input /ma "Phalanx II" <stpc>')
    send_command('bind !o input /ma "Regen II" <stpc>')
    send_command('bind !p input /ma "Shock Spikes" <me>')

    send_command('bind ~numpad7 input /ma "Paralyze II" <t>')
    send_command('bind ~numpad8 input /ma "Silence" <t>')
    send_command('bind ~numpad9 input /ma "Blind II" <t>')
    send_command('bind ~numpad4 input /ma "Poison II" <t>')
    send_command('bind ~numpad5 input /ma "Slow II" <t>')
    send_command('bind ~numpad6 input /ma "Addle II" <t>')
    send_command('bind ~numpad1 input /ma "Distract III" <t>')
    send_command('bind ~numpad2 input /ma "Frazzle III" <t>')
    send_command('bind ~numpad3 input /ma "Inundation" <t>')
    send_command('bind ~numpad0 input /ma "Dia III" <t>')

	send_command('bind !o gi ugs false; input /equip ring2 "Warp Ring"; input /echo Warping; wait 10; input /item "Warp Ring" <me>;')
	send_command('bind !p gi ugs false; input /equip ring2 "Dim. Ring (Holla)"; input /echo Warping Reisj; wait 10; input /item "Dim. Ring (Holla)" <me>;')

    send_command('bind !insert gs c cycleback EnSpell')
    send_command('bind !delete gs c cycle EnSpell')
    send_command('bind ^insert gs c cycleback GainSpell')
    send_command('bind ^delete gs c cycle GainSpell')
    send_command('bind ^home gs c cycleback BarElement')
    send_command('bind ^end gs c cycle BarElement')
    send_command('bind ^pageup gs c cycleback BarStatus')
    send_command('bind ^pagedown gs c cycle BarStatus')

    send_command('bind @s gs c cycle SleepMode')
    send_command('bind @e gs c cycle EnspellMode')
    send_command('bind @d gs c toggle NM')
    send_command('bind @w gs c toggle WeaponLock')
    -- send_command('bind @c gs c toggle CP')
    send_command('bind @r gs c cycle WeaponSet')
    send_command('bind !r gs c cycle RegenMode')
    send_command('bind @p gs c cycle PhalanxMode')

    send_command('bind ^numpad4 input /ws "Savage Blade" <t>')
    send_command('bind ^numpad6 input /ws "Chant du Cygne" <t>')
    send_command('bind ^numpad7 input /ws "Requiescat" <t>')
    send_command('bind ^numpad1 input /ws "Sanguine Blade" <t>')
    send_command('bind ^numpad2 input /ws "Seraph Blade" <t>')

    select_default_macro_book()
    set_lockstyle()

    state.Auto_Kite = M(false, 'Auto_Kite')
    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^-')
    send_command('unbind ^=')
    send_command('unbind !-')
    send_command('unbind !=')
    send_command('unbind ^;')
    send_command('unbind ![')
    send_command('unbind !;')
    send_command('unbind !q')
    send_command('unbind !w')
--    send_command('bind !e input /ma "Haste" <stpc>')
--    send_command('bind !r input /ma "Refresh" <stpc>')
--    send_command('bind !y input /ma "Phalanx" <me>')
    send_command('unbind !o')
    send_command('unbind !p')
    send_command('unbind @s')
    send_command('unbind @d')
    send_command('unbind @t')

    send_command('unbind ~numpad7')
    send_command('unbind ~numpad8')
    send_command('unbind ~numpad9')
    send_command('unbind ~numpad4')
    send_command('unbind ~numpad5')
    send_command('unbind ~numpad6')
    send_command('unbind ~numpad1')
    send_command('unbind ~numpad2')
    send_command('unbind ~numpad3')
    send_command('unbind ~numpad0')

    send_command('unbind @w')
    -- send_command('unbind @c')
    send_command('unbind @e')
    send_command('unbind @r')
    send_command('unbind !insert')
    send_command('unbind !delete')
    send_command('unbind ^insert')
    send_command('unbind ^delete')
    send_command('unbind ^home')
    send_command('unbind ^end')
    send_command('unbind ^pageup')
    send_command('unbind ^pagedown')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad9')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')

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
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Chainspell'] = {body="Viti. Tabard +3"}
    sets.precast.JA['Convert'] = {main="Murgleis"}

    sets.Enmity = {
    --Used for RDM tanking. Use for Flash
        --main="Mafic Cudgel", --6
        --sub="Evalach +1", --6
        ammo="Sapience Orb", --2
        head="Halitus Helm", --8
        body="Emet Harness +1", --10
        hands="Dux Finger Gauntlets +1", --5
        hands={ name="Merlinic Dastanas", augments={'Attack+5','Enmity+5','Phalanx +5','Accuracy+4 Attack+4','Mag. Acc.+9 "Mag.Atk.Bns."+9',}},
        legs="Zoar Subligar +1", --6
        feet="Rager Ledelsens +1", --7
        neck="Unmoving Collar +1", --10
        ear1="Cryptic Earring", --4
        ear2="Trux Earring", --5
        --ring1="Pernicious Ring", --5
        ring1="Supershear Ring", --5
        ring2="Eihwaz Ring", --5
        waist="Trance Belt", --4
        --back="Sucellos's Cape", --Need ambu enmity augs
        }

    -- Fast cast sets for spells
    sets.precast.FC = {
        --Max 80%
        --30 from Job Traits, +2 per Job Points gift @150, 500, 1125, 2000. Currently 8/8
        --Need 32 FC
        ammo="Impatiens", --QM+2
        head="Atrophy Chapeau +3", --16
        body="Viti. Tabard +3", --15
        hands="Leyline Gloves",
        neck="Orunmila's Torque",
        waist="Witful Belt", --+3, QM+3
        back="Perimede Cape", --QM+4
        }

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
        ammo="Impatiens", --(2)
        ring1="Lebeche Ring", --(2)
        ring2="Weather. Ring +1", --5/(4)
        back="Perimede Cape", --(4)
        waist="Embla Sash",
        })

    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC['Healing Magic'] = sets.precast.FC.Cure
    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {})

    sets.precast.FC.Impact = set_combine(sets.precast.FC, {
        ammo="Sapience Orb", --2
        head=empty,
        body="Twilight Cloak",
        hands="Leyline Gloves", --8
        neck="Orunmila's Torque", --5
        ear1="Malignance Earring", --4
        ear2="Enchntr. Earring +1", --2
        ring1="Kishar Ring", --4
        back="Aurist's Cape +1",
        --waist="Shinjutsu-no-Obi +1",
        })

    sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {
        main="Daybreak",
        sub="Ammurapi Shield",
        --waist="Shinjutsu-no-Obi +1",
        })

    sets.precast.Storm = set_combine(sets.precast.FC, {name="Stikini Ring +1", bag="wardrobe5"})
    sets.precast.FC.Utsusemi = sets.precast.FC.Cure


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
        ammo="Aurgelmir Orb",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Leth. Houseaux +3",
        neck="Fotia Gorget",
        ear1="Ishvara Earring",
        ear2="Moonshade Earring",
        ring1="Ilabrat Ring",
        ring2="Epaminondas's Ring",
        back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
        waist="Fotia Belt",
        }

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        ammo="Voluspa Tathlum",
        body="Lethargy Sayon +3",
        neck="Combatant's Torque",
        ear2="Mache Earring +1",
        waist="Grunfeld Rope",
        })

    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
        --Stat Modified: 80% DEX 
        ammo="Yetshila +1",
        head="Blistering Sallet +1",
        body="Viti. Tabard +3",
        hands="Malignance Gloves",
        legs="Zoar Subligar +1",
        feet="Thereoid Greaves",
        ear1="Sherida Earring",
        ear2="Mache Earring +1",
        ring1="Begrudging Ring",
        ring2="Ilabrat Ring",
        back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},
        })

    sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS['Chant du Cygne'], {
        ammo="Voluspa Tathlum",
        ear2="Mache Earring +1",
        })

    sets.precast.WS['Vorpal Blade'] = sets.precast.WS['Chant du Cygne']
    sets.precast.WS['Vorpal Blade'].Acc = sets.precast.WS['Chant du Cygne'].Acc

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        --Stat Modifiers: STR 50%, MND 50%
        ammo="Coiste Bodhar",
        ear1="Regal Earring",
        ring1="Sroda Ring",
        waist="Sailfi Belt +1",
        })

    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {
        ammo="Voluspa Tathlum",
        neck="Combatant's Torque",
        })

    sets.precast.WS['Death Blossom'] = sets.precast.WS['Savage Blade']
    sets.precast.WS['Death Blossom'].Acc = sets.precast.WS['Savage Blade'].Acc

    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {
        --modifiers: 73-82% MND
        ammo="Regal Gem",
        ear2="Sherida Earring",
        ring2="Shukuyu Ring",
        })

    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS['Requiescat'], {
        ammo="Voluspa Tathlum",
        neck="Combatant's Torque",
        ear1="Mache Earring +1",
        })

    sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS, {
        --Stat Modifier: MND 50%, STR 30% and MAB
        ammo="Pemphredo Tathlum",
        head="Pixie Hairpin +1",
        body="Nyame Mail",
        hands="Jhakri Cuffs +2",
        legs="Leth. Fuseau +3",
        neck="Sibyl Scarf",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1="Archon Ring",
        ring2="Metamorph Ring +1",
        back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},
        --waist="Orpheus's Sash",
        waist="Sacro Cord",
        })

    sets.precast.WS['Seraph Blade'] = set_combine(sets.precast.WS['Sanguine Blade'], {
        ammo="Regal Gem",
        head="Leth. Chappel +3",
        neck="Fotia Gorget",
        ear2="Moonshade Earring",
        --ring1="Weather. Ring +1",
        ring1="Freke Ring",
        })

    sets.precast.WS['Red Lotus Blade'] = set_combine(sets.precast.WS['Sanguine Blade'], {
        --Stat Modifier: STR 40%, INT 40% and MAB
        head="Leth. Chappel +3",
        hands="Jhakri Cuffs +2",
        neck="Sibyl Scarf",
        ear2="Moonshade Earring",
        ring1="Freke Ring",
        ring2="Epaminondas's Ring",
        back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
        --waist="Orpheus's Sash",
        waist="Sacro Cord",
        })

    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS['Seraph Blade'], {
        --ammo="Sroda Tathlum",
        ammo="Ghastly Tathlum +1",
        head="Leth. Chappel +3",
        legs="Leth. Fuseau +3",
        ear2="Moonshade Earring",
        ring1="Freke Ring",
        ring2="Epaminondas's Ring",
        back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
        --waist="Orpheus's Sash",
        waist="Acuity Belt +1",
        })

    sets.precast.WS['Evisceration'] = sets.precast.WS['Chant du Cygne']
    sets.precast.WS['Evisceration'].Acc = sets.precast.WS['Chant du Cygne'].Acc

    sets.precast.WS['Black Halo'] = set_combine(sets.precast.WS['Savage Blade'], {
        --ammo="Crepescular Pebble", --For high buffs
        ring1="Metamorph Ring +1",
        --neck="Duelist's Torque +2", --For high buffs
        --ring1="Sroda Ring", --For high buffs
        })

    sets.precast.WS['Black Halo'].Acc = set_combine(sets.precast.WS['Black Halo'], {
        ammo="Voluspa Tathlum",
        neck="Combatant's Torque",
        ear2="Telos Earring",
        waist="Grunfeld Rope",
        })


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        --Cap of 50%???
        ammo="Staunch Tathlum +1", --11
        body="Ros. Jaseran +1", --25
        legs="Carmine Cuisses +1", --20
        neck="Loricate Torque +1", --5
        ear1="Halasz Earring", --5
        --ear2="Magnetic Earring", --8
        ring2="Evanescence Ring", --5
        waist="Rumination Sash", --10
        }

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    sets.midcast.Cure = {
        --Aim for Cure Potency, Healing Skill, MND
        --1 Healing Skill = 2 MND = 4 VIT
        --Cap for Cure Potency I from equipment = 50
        main="Daybreak", --30
        sub="Sors Shield", --3/(-5)
        ammo="Esper Stone +1", --0/(-5)
        --head="Kaykaus Mitra +1", --11(+2)/(-6)
        head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}}, --10
        body="Kaykaus Bliaut +1", --(+4)/(-6)
        hands="Kaykaus Cuffs +1", --11(+2)/(-6)
        --legs="Kaykaus Tights +1", --11(+2)/(-6)
        legs="Atrophy Tights +3", --12
        feet="Kaykaus Boots +1", --11(+2)/(-12)
        neck="Incanter's Torque",
        ear1="Mendicant's Earring",
        ear2="Calamitous Earring",
        --ring1="Haoma's Ring",
        ring1 = {name="Stikini Ring +1", bag="wardrobe2"},
        ring2="Menelaus's Ring",
        back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Cure" potency +10%',}}, --(-10)
        waist="Luminary Sash",
        }

    sets.midcast.CureWeather = set_combine(sets.midcast.Cure, {
        main="Chatoyant Staff",
        sub="Enki Strap",
        back="Twilight Cape",
        waist="Hachirin-no-Obi",
        })

    sets.midcast.CureSelf = set_combine(sets.midcast.Cure, {
        neck="Phalaina Locket", -- 4(4)
        ring2="Kunaji Ring", -- (5)
        waist="Gishdubar Sash", -- (10)
        })

    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
        ammo="Regal Gem",
        ring1={name="Stikini Ring +1", bag="wardrobe2"},
        ring2={name="Stikini Ring +1", bag="wardrobe5"},
        waist="Luminary Sash",
        })

    sets.midcast.StatusRemoval = {
        head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        body="Vanya Robe",
        legs="Atrophy Tights +3",
        feet="Vanya Clogs",
        neck="Incanter's Torque",
        --ear1="Beatific Earring",
        ear2="Meili Earring",
        ring1="Haoma's Ring",
        ring2="Menelaus's Ring",
        back="Perimede Cape",
        waist="Bishop's Sash",
        }

    sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {
        hands="Hieros Mittens",
        body="Viti. Tabard +3",
        neck="Debilis Medallion",
        --back="Oretan. Cape +1",
        back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Cure" potency +10%',}},
        })

    sets.midcast.Raise = sets.midcast.FastRecast
    sets.midcast.Erase = sets.midcast.FastRecast

    sets.midcast['Enhancing Magic'] = {
        main="Pukulatmuj +1",
        sub="Forfend +1",
        ammo="Staunch Tathlum +1",
        head="Befouled Crown",
        body="Viti. Tabard +3",
        hands="Viti. Gloves +3",
        legs="Atrophy Tights +3",
        feet="Leth. Houseaux +3",
        neck="Incanter's Torque",
        ear1="Mimir Earring",
        ear2="Andoaa Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe2"},
        ring2={name="Stikini Ring +1", bag="wardrobe5"},
        back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +5','Enha.mag. skill +10','Mag. Acc.+10',}},
        waist="Olympus Sash",
        }

    sets.midcast.EnhancingDuration = {
        --Haste, Flurry, Regen, Refresh
        main="Colada",
        sub="Ammurapi Shield",
        ammo="Staunch Tathlum +1",
        head={ name="Telchine Cap", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        body="Viti. Tabard +3",
        hands="Atrophy Gloves +3",
        legs={ name="Telchine Braconi", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        feet="Leth. Houseaux +3",
        neck="Dls. Torque +2",
        ear1="Malignance Earring",
        ear2="Lethargy Earring +1", --***Hope for +2
        back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +10','Enha.mag. skill +6','Enh. Mag. eff. dur. +20',}},
        waist="Embla Sash",
        }

    sets.midcast.EnhancingSkill = {
        --For Temper, Phalanx, Bar Spells, Gain spells, enspells
        main="Pukulatmuj +1",
        sub="Forfend +1",
        hands="Viti. Gloves +3",
        feet="Leth. Houseaux +3",
        }

    sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {
        main="Bolelabunga",
        sub="Ammurapi Shield",
        head={ name="Telchine Cap", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        legs={ name="Telchine Braconi", augments={'Mag. Evasion+25','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        feet="Bunzi's Sabots", --R20: regen+7 R25: regen+9 R30: regen+10
        })

    sets.midcast.RegenPotency = set_combine(sets.midcast.Regen, {
        --head={ name="Telchine Cap", augments={'"Conserve MP"+5','"Regen" potency+3',}},
        body={ name="Telchine Chas.", augments={'"Conserve MP"+5','"Regen" potency+3',}},
        hands={ name="Telchine Gloves", augments={'"Conserve MP"+5','"Regen" potency+3',}},
        legs={ name="Telchine Braconi", augments={'"Conserve MP"+5','"Regen" potency+3',}},
        feet="Bunzi's Sabots", --R20: regen+7 R25: regen+9 R30: regen+10
        })


    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
        head="Amalric Coif +1", -- +1
        body="Atrophy Tabard +3", -- +3
        legs="Leth. Fuseau +3", -- +4
        })

    sets.midcast.RefreshSelf = set_combine(sets.midcast.EnhancingDuration, {
        head="Amalric Coif +1", -- +1
        body="Atrophy Tabard +3", -- +3
        legs="Leth. Fuseau +3", -- +4
        waist="Gishdubar Sash",
        back="Grapevine Cape"
        })

    sets.midcast.Stoneskin = set_combine(sets.midcast.EnhancingDuration, {
        neck="Nodens Gorget",
        ear2="Earthcry earring",
        hands="Stone Mufflers",
        waist="Siegel Sash",
        legs="Shedir Seraweels",
        })

    sets.midcast['Phalanx'] = set_combine(sets.midcast.EnhancingDuration, {
        body="Taeon Tabard", --3(10)
        hands="Taeon Gloves", --3(10)
        legs="Taeon Tights", --3(10)
        feet={ name="Chironic Slippers", augments={'Pet: AGI+3','Pet: Mag. Acc.+15','Phalanx +4','Accuracy+20 Attack+20',}}, --3(10)
        })

    sets.midcast.PhalanxPotency = set_combine(sets.midcast.EnhancingDuration, {
        ammo="Pemphredo Tathlum", --***To test for swaps 
        main="Sakpata's Sword", --5
        sub="Ammurapi Shield",
        head={ name="Taeon Chapeau", augments={'Phalanx +3',}}, --3
        body={ name="Taeon Tabard", augments={'Potency of "Cure" effect received+7%','Phalanx +3',}}, --3
        hands={ name="Taeon Gloves", augments={'Potency of "Cure" effect received+7%','Phalanx +3',}}, --3
        legs={ name="Merlinic Shalwar", augments={'"Mag.Atk.Bns."+2','Pet: INT+8','Phalanx +4','Accuracy+19 Attack+19','Mag. Acc.+8 "Mag.Atk.Bns."+8',}}, --4
        feet={ name="Chironic Slippers", augments={'Pet: AGI+3','Pet: Mag. Acc.+15','Phalanx +4','Accuracy+20 Attack+20',}}, --4
        })

    sets.phalanx = sets.PhalanxPotency
    sets.Phalanx = sets.PhalanxPotency

    sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {
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

    sets.midcast.Storm = sets.midcast.EnhancingDuration
    sets.midcast.GainSpell = {hands="Viti. Gloves +3"}
    sets.midcast.SpikesSpell = {legs="Viti. Tights +2"}

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {ring2="Sheltered Ring"})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Shell

    sets.ProtectShellReceived = {
        ring1="Sheltered Ring",
        }

     -- Custom spell classes

    sets.midcast.MndEnfeebles = {
        main="Daybreak",
        sub="Ammurapi Shield",
        ammo="Regal Gem",
        head="Viti. Chapeau +3",
        body="Lethargy Sayon +3",
        hands="Lethargy Gantherots +3",
        legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','"Conserve MP"+3','MND+3','Mag. Acc.+14',}},
        feet="Vitiation Boots +3",
        neck="Dls. Torque +2",
        ear1="Regal Earring",
        ear2="Snotra Earring",
        ring1="Stikini Ring +1",
        ring2="Stikini Ring +1",
        back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Cure" potency +10%',}},
        waist="Luminary Sash",
        }

    sets.midcast.MndEnfeeblesAcc = set_combine(sets.midcast.MndEnfeebles, {
        main="Crocea Mors",
        sub="Ammurapi Shield",
        range="Ullr",
        ammo=empty,
        head="Atrophy Chapeau +3",
        body="Atrophy Tabard +3",
        legs="Leth. Fuseau +3",
        waist="Acuity Belt +1",
        back="Aurist's Cape +1",
        })

    sets.midcast.MndEnfeeblesEffect = set_combine(sets.midcast.MndEnfeebles, {
        ammo="Regal Gem",
        body="Lethargy Sayon +3",

        legs="Leth. Fuseau +3",
        feet="Vitiation Boots +3",
        neck="Dls. Torque +2",
        waist="Obstinate Sash",
        })

    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
        main="Maxentius",
        sub="Ammurapi Shield",
        ring2="Metamorph Ring +1",
        waist="Acuity Belt +1",
        })

    sets.midcast.IntEnfeeblesAcc = set_combine(sets.midcast.IntEnfeebles, {
        main="Crocea Mors",
        sub="Ammurapi Shield",
        range="Ullr",
        ammo=empty,
        body="Atrophy Tabard +3",
        ring1={name="Stikini Ring +1", bag="wardrobe2"},
        back="Aurist's Cape +1",
        waist="Obstinate Sash",
        })

    sets.midcast.IntEnfeeblesEffect = set_combine(sets.midcast.IntEnfeebles, {
        ammo="Regal Gem",
        body="Lethargy Sayon +3",
        feet="Vitiation Boots +3",
        neck="Dls. Torque +2",
        })

    sets.midcast.SkillEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
        main="Contemplator +1",
        sub="Enki Strap",
        head="Viti. Chapeau +3",
        body="Atrophy Tabard +3",
        hands="Lethargy Gantherots +3",
        feet="Vitiation Boots +3",
        neck="Incanter's Torque",
        ring1={name="Stikini Ring +1", bag="wardrobe2"},
        ring2={name="Stikini Ring +1", bag="wardrobe5"},
        ear1="Vor Earring",
        ear2="Snotra Earring",
        waist="Obstinate Sash",
        })

    sets.midcast.Sleep = set_combine(sets.midcast.IntEnfeeblesAcc, {
        head="Viti. Chapeau +3",
        neck="Dls. Torque +2",
        ear2="Snotra Earring",
        ring1="Kishar Ring",
        })

    sets.midcast.SleepMaxDuration = set_combine(sets.midcast.Sleep, {
        head="Leth. Chappel +3",
        body="Lethargy Sayon +3",
        hands="Regal Cuffs",
        legs="Leth. Fuseau +3",
        feet="Leth. Houseaux +3",
        })

    sets.midcast.ElementalEnfeeble = sets.midcast.IntEnfeebles
    sets.midcast.Dispelga = set_combine(sets.midcast.IntEnfeeblesAcc, {
        main="Daybreak",
        sub="Ammurapi Shield",
        --waist="Shinjutsu-no-Obi +1",
        })

    sets.midcast['Dark Magic'] = {
        --main="Rubicundity",
        main="Bunzi's Rod",
        sub="Ammurapi Shield",
        ammo="Pemphredo Tathlum",
        --head="Bunzi's Hat",
        head="Atrophy Chapeau +3",
        --body="Carm. Sc. Mail +1",
        body="Lethargy Sayon +3",
        hands="Lethargy Gantherots +3",
        --legs="Bunzi's Pants",
        legs="Lethargy Fuseau +3",
        feet="Lethargy Houseaux +3",
        neck="Duelist's Torque +2",
        ear1="Malignance Earring",
        --ear2="Mani Earring",
        ear2="Lethargy Earring +1",
        --ring1 = {name="Stikini Ring +1", bag="wardrobe2"},
        --ring2 = {name="Stikini Ring +1", bag="wardrobe5"},
        ring1="Kishar Ring",
        ring2="Metamorph Ring +1",
        --back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
        back="Perimede Cape",
        waist="Acuity Belt +1",
        }

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        ammo="Staunch Tathlum +1",
        head="Pixie Hairpin +1",
        hands={ name="Merlinic Dastanas", augments={'"Drain" and "Aspir" potency +11','MND+1',}},
        feet={ name="Merlinic Crackows", augments={'Mag. Acc.+7','"Occult Acumen"+10','VIT+5',}},
        --ear1="Hirudinea Earring",
        --ear2="Mani Earring",
        ring1="Archon Ring",
        ring2="Evanescence Ring",
        back="Perimede Cape",
        waist="Fucho-no-obi",
        })

    sets.midcast.Aspir = sets.midcast.Drain
    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {waist="Luminary Sash"})
    sets.midcast['Bio III'] = set_combine(sets.midcast['Dark Magic'], {legs="Viti. Tights +2"})

    sets.midcast['Elemental Magic'] = {
        --main="Marin Staff +1",
        --sub="Enki Strap",
        main="Bunzi's Rod",
        sub="Ammurapi Shield",
        ammo="Ghastly Tathlum +1",
        --head="C. Palug Crown",
        head="Leth. Chappel +3",
        --body="Amalric Doublet +1",
        body="Lethargy Sayon +3",
        hands="Amalric Gages +1",
        legs="Amalric Slops +1",
        feet="Amalric Nails +1",
        neck="Baetyl Pendant",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1="Freke Ring",
        ring2="Metamorph Ring +1",
        back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
        waist="Sacro Cord",
        }

    sets.midcast['Elemental Magic'].Seidr = set_combine(sets.midcast['Elemental Magic'], {
        ammo="Pemphredo Tathlum",
        body="Seidr Cotehardie",
        feet="Merlinic Crackows",
        neck="Erra Pendant",
        waist="Acuity Belt +1",
        })

    sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
        range="Ullr",
        ammo=empty,
        legs="Merlinic Shalwar",
        neck="Erra Pendant",
        waist="Sacro Cord",
        })

    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
        head=empty,
        body="Twilight Cloak",
        legs="Leth. Fuseau +3",
        feet="Leth. Houseaux +3",
        ring1="Archon Ring",
        back="Aurist's Cape +1",
        --waist="Shinjutsu-no-Obi +1",
        })

    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC

    -- Job-specific buff sets
    sets.buff.ComposureOther = {
        head="Leth. Chappel +3",
        body="Lethargy Sayon +3",
        legs="Leth. Fuseau +3",
        feet="Leth. Houseaux +3",
        ear1="Malignance Earring",
        ear2="Lethargy Earring +1", --***Hope for +2
        }

    sets.buff.Saboteur = {hands="Lethargy Gantherots +3",}


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
        main="Bolelabunga",
        --main="Maxentius", --for aminon
        sub="Sacro Bulwark",
        ammo="Homiliary",
        head="Viti. Chapeau +3",
        body="Lethargy Sayon +3",
        --hands="Raetic Bangles +1",
        hands="Nyame Gauntlets",
        --legs="Lengo Pants",
        legs="Carmine Cuisses +1",
        feet="Nyame Sollerets",
        --neck="Bathy Choker +1",
        neck="Loricate Torque +1",
        ear1="Eabani Earring",
        --ear2="Sanare Earring",
        ear2="Infused Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe2"},
        ring2={name="Stikini Ring +1", bag="wardrobe5"},
        back="Moonlight Cape",
        waist="Flume Belt +1",
        }

    sets.idle.DT = set_combine(sets.idle, {
        head="Malignance Chapeau", --6/6
        body="Malignance Tabard", --9/9
        --hands="Malignance Gloves", --5/5
        hands="Nyame Gauntlets", --7/7
        --legs="Malignance Tights", --7/7
        legs="Nyame Flanchard", --8/8
        --feet="Malignance Boots", --4/4
        feet="Nyame Sollerets", --7/7
        neck="Warder's Charm +1",
        ear1="Eabani Earring",
        --ear2="Sanare Earring",
        ear2="Infused Earring",
        ring2="Defending Ring", --10/10
        back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
        waist="Carrier's Sash",
        })

    sets.idle.Town = set_combine(sets.idle, {
        ammo="Regal Gem",
        head="Viti. Chapeau +3",
        body="Viti. Tabard +3",
        hands="Regal Cuffs",
        legs="Carmine Cuisses +1",
        feet="Vitiation Boots +3",
        neck="Dls. Torque +2",
        ear1="Malignance Earring",
        ear2="Snotra Earring",
        back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
        waist="Acuity Belt +1",
        })

    sets.resting = set_combine(sets.idle, {
        main="Contemplator +1", --hmp +16
        waist="Shinjutsu-no-Obi +1",
        })

    sets.tanking = set_combine(sets.engaged, {
        main="Mafic Cudgel", --Sword option?
        sub="Sacro Bulwark",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        --feet="Atrophy Boots +3", --For shield skill
        feet="Malignance boots",
        neck="Unmoving Collar +1", --When R15’d
        --ear1="Tuisto Earring", --VIT+10, convert 150 MP to HP
        --ear1="Foresti Earring", --shield skill +10 
        ear2="Odnowa Earring +1",
        ring1="Defending Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        --back="Sucellos's Cape", --Need ambu enmity augs
        back="Moonlight Cape",
        waist="Carrier's Sash",
        })


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.magic_burst = {
        --MB DMG cap for equipment = 40
        --(MB DMG/MG DMG II)
        --Total: 36/11
        main="Bunzi's Rod", --10/0
        sub="Ammurapi Shield",
        ammo="Ghastly Tathlum +1",
        head="Ea Hat +1", --7/(7)
        body="Ea Houppelande +1", --9/(9)
        hands="Amalric Gages +1", --0/6
        --legs="Ea Slops +1", --8/(8)
        legs="Amalric Slops +1",
        --feet="Ea Pigaches +1", --5/5
        --feet="Amalric Nails +1",
        feet="Bunzi's Sabots", --6/0
        --neck="Sibyl Scarf",
        neck="Mizu. Kubikazari", --10/0 **Remove after getting some Ea
        ear1="Regal Earring",
        ear2="Malignance Earring",
        ring1="Freke Ring",
        ring2="Mujin Band", -- 0/5
        waist="Sacro Cord",
        }

    sets.Kiting = {legs="Carmine Cuisses +1"}
    sets.latent_refresh = {waist="Fucho-no-obi"}
    sets.latent_refresh70 = {legs={ name="Chironic Hose", augments={'Rng.Acc.+30','INT+7','"Refresh"+2','Mag. Acc.+2 "Mag.Atk.Bns."+2',}}}



    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
        --main="Crocea Mors",
        --sub="Daybreak",
        --main="Naegling",
        --sub="Genmei Shield",
        --main="Maxentius", --for aminon
        ammo="Aurgelmir Orb",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance boots",
        neck="Anu Torque",
        ear1="Sherida Earring",
        ear2="Telos Earring",
        ring1="Ilabrat Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        --back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10',}}, --For Crocea Mors DW
        back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},
        --waist="Windbuffet Belt +1",
        waist="Reiki Yotai", --7
        }

    sets.engaged.MidAcc = set_combine(sets.engaged, {
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        waist="Kentarch Belt +1",
        })

    sets.engaged.HighAcc = set_combine(sets.engaged, {
        ammo="Voluspa Tathlum",
        head="Carmine Mask +1",
        head="Malignance Chapeau",
        body="Carm. Sc. Mail +1",
        hands="Gazu Bracelets +1",
        legs="Carmine Cuisses +1",
        neck="Combatant's Torque",
        ear1="Telos Earring",
        ear2="Mache Earring +1",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        waist="Olseni Belt",
        waist="Kentarch Belt +1",
        })

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {
        ammo="Aurgelmir Orb",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Carmine Cuisses +1", --6
        feet=gear.Taeon_DW_feet, --9
        --feet="Malignance Boots",
        neck="Anu Torque",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Ilabrat Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},
        waist="Reiki Yotai", --7
        } --41

    sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW, {
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        })

    sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.MidAcc, {
        ammo="Voluspa Tathlum",
        head="Carmine Mask +1",
        body="Carm. Sc. Mail +1",
        hands="Gazu Bracelets +1",
        ear1="Cessance Earring",
        ear2="Mache Earring +1",
        })

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = set_combine(sets.engaged.DW, {
        ammo="Aurgelmir Orb",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Carmine Cuisses +1", --6
        --feet=gear.Taeon_DW_feet, --9
        feet="Malignance Boots",
        neck="Anu Torque",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Ilabrat Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},
        waist="Reiki Yotai", --7
        }) --41

    sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        })

    sets.engaged.DW.HighAcc.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, {
        ammo="Voluspa Tathlum",
        head="Carmine Mask +1",
        body="Carm. Sc. Mail +1",
        hands="Gazu Bracelets +1",
        ear1="Cessance Earring",
        ear2="Mache Earring +1",
        })

    -- 30% Magic Haste (56% DW to cap)
    -- /nin: 31 DW needed. /dnc: 35 needed with Haste Samba
    -- Currently: 22 DW, 31 with Taeon boots
    sets.engaged.DW.MidHaste = set_combine(sets.engaged.DW, {
        ammo="Aurgelmir Orb",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        --feet=gear.Taeon_DW_feet, --9
        feet="Malignance Boots",
        neck="Anu Torque",
        ear1="Sherida Earring",
        ear2="Suppanomimi", --5
        ring1="Ilabrat Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},
        waist="Reiki Yotai", --7
        })

    sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
        legs="Carmine Cuisses +1", --6
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ear2="Telos Earring",
        })

    sets.engaged.DW.HighAcc.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, {
        ammo="Voluspa Tathlum",
        head="Carmine Mask +1",
        body="Carm. Sc. Mail +1",
        hands="Gazu Bracelets +1",
        ear1="Cessance Earring",
        ear2="Mache Earring +1",
        })

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = set_combine(sets.engaged.DW, {
        ammo="Aurgelmir Orb",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        --feet=gear.Taeon_DW_feet, --9
        feet="Malignance Boots",
        neck="Anu Torque",
        ear1="Sherida Earring",
        ear2="Telos Earring",
        ring1="Ilabrat Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},
        waist="Reiki Yotai", --7
      }) --26

    sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
        legs="Carmine Cuisses +1", --6
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        })

    sets.engaged.DW.HighAcc.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, {
        ammo="Voluspa Tathlum",
        head="Carmine Mask +1",
        body="Carm. Sc. Mail +1",
        hands="Gazu Bracelets +1",
        ear1="Cessance Earring",
        ear2="Mache Earring +1",
        })

    -- 45% Magic Haste (36% DW to cap)
    -- /nin: 11 DW needed. /dnc: 9 needed with Haste Samba
    -- Currently: 10 DW 
    sets.engaged.DW.MaxHaste = set_combine(sets.engaged.DW, {
        ammo="Aurgelmir Orb",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Anu Torque",
        ear1="Sherida Earring",
        ear2="Telos Earring",
        ring1="Ilabrat Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},
        waist="Carrier's Sash",
        }) --10

    sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {
        ammo="Voluspa Tathlum",
        head="Carmine Mask +1",
        body="Carm. Sc. Mail +1",
        hands="Gazu Bracelets +1",
        legs="Carmine Cuisses +1",
        ear1="Cessance Earring",
        ear2="Mache Earring +1",
        waist="Olseni Belt",
        })


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
       neck="Loricate Torque +1", --6/6
       ring2="Defending Ring", --10/10
       }

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT = set_combine(sets.engaged.DW.MidAcc, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT = set_combine(sets.engaged.DW.HighAcc, sets.engaged.Hybrid)

    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.Hybrid)

    sets.engaged.Crocea = {
        ammo="Coiste Bodhar",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Ayanmo Manopolas +2",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Anu Torque",
        ear1="Sherida Earring",
        ear2="Eabani Earring", -- Eabani Earring 4 DW
        ring1={name="Chirich Ring +1", bag="wardrobe1"},
        ring2="Hetairoi Ring",
        back="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Damage taken-5%'}, -- Use Eabani Earring & Reiki Yotia if STP/DA augment to reach DW cap
        waist="Reiki Yotai",}
        
    sets.engaged.CroceaClubDW = {
        ammo="Coiste Bodhar",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Ayanmo Manopolas +2",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Anu Torque",
        ear1="Sherida Earring",
        ear2="Eabani Earring", -- Eabani Earring 4 DW
        ring1={name="Chirich Ring +1", bag="wardrobe1"},
        ring2="Hetairoi Ring",
        back="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Damage taken-5%'}, -- Use Eabani Earring & Reiki Yotia if STP/DA augment to reach DW cap
        waist="Reiki Yotai",}
        
    sets.engaged.EnspellOnly = {
        ammo="Hasty Pinion +1",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Ayanmo Manopolas +2",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Anu Torque",
        ear1="Telos Earring",
        ear2="Sherida Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe1"},
        ring2={name="Chirich Ring +1", bag="wardrobe2"},
        back="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Damage taken-5%'},
        waist="Reiki Yotai",
        }

    sets.engaged.Enspell = {
        ammo="Hasty Pinion",
        hands="Ayanmo Manopolas +2",
        neck="Sanctity Necklace",
        waist="Orpheus's Sash",
        }

    sets.engaged.Enspell.Fencer = {ring1="Fencer's Ring"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1={name="Eshmun's Ring", bag="wardrobe3"}, --20
        ring2={name="Eshmun's Ring", bag="wardrobe4"}, --20
        waist="Gishdubar Sash", --10
        }

    sets.Obi = {waist="Hachirin-no-Obi"}
    -- sets.CP = {back="Mecisto. Mantle"}

    sets.TreasureHunter = {
        head="Volte Cap",
        legs="Volte Hose",
        feet="Volte Boots",
        waist="Chaac Belt",
        }

    sets.TH = sets.TreasureHunter
    sets.th = sets.TreasureHunter

    sets.Naegling = {main="Naegling", sub="Genmei Shield", range=empty}
    sets.Daybreak = {main="Daybreak", sub="Genmei Shield", range=empty} -- Sacro Bulwark has minus 10% DT
    sets.Crocea = {main="Crocea Mors", sub="Ammurapi Shield", range=empty}
    sets.Maxentius = {main="Maxentius", sub="Genmei Shield", range=empty}
    sets.Tauret = {main="Tauret", sub="Genmei Shield", range=empty}
    sets.NaeglingDW = {main="Naegling", sub="Thibron", range=empty}
    sets.CroceaClubDW = {main="Crocea Mors", sub="Daybreak", range=empty}
    sets.MaxentiusDW = {main="Maxentius", sub="Thibron", range=empty}
    sets.AeolianDW = {main="Tauret", sub="Thibron", range=empty}
    sets.EvisDW = {main="Tauret", sub="Gleti's Knife", range=empty}
    sets.EnspellOnly = {main="Norgish Dagger", sub="Aern Dagger", range=empty, ammo="Hasty Pinion +1"}

    --sets.CroceaDark = {main="Crocea Mors", sub="Ternion Dagger +1"}
    --sets.CroceaLight = {main="Crocea Mors", sub="Daybreak"}
    --sets.Almace = {main="Almace", sub="Ternion Dagger +1"}
    --sets.Naegling = {main="Naegling", sub="Thibron"}
    --sets.Maxentius = {main="Maxentius", sub="Ternion Dagger +1"}
    --sets.Idle = {main="Bolelabunga", sub="Sacro Bulwark"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
        end
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
    if spell.english == "Phalanx II" and spell.target.type == 'SELF' then
        cancel_spell()
        send_command('@input /ma "Phalanx" <me>')
    end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Enhancing Magic' then
        if classes.NoSkillSpells:contains(spell.english) then
            equip(sets.midcast.EnhancingDuration)
        if spellMap == "Regen" and state.RegenMode.value == 'Duration' then
            equip(sets.midcast.Regen)
        end
        if spellMap == "Regen" and state.RegenMode.value == 'Potency' then
            equip(sets.midcast.RegenPotency)
        end
            if spellMap == 'Refresh' then
                equip(sets.midcast.Refresh)
                if spell.target.type == 'SELF' then
                    equip (sets.midcast.RefreshSelf)
              end
            end
        elseif skill_spells:contains(spell.english) then
            equip(sets.midcast.EnhancingSkill)
        elseif duration_spells:contains(spell.english) then
            equip(sets.midcast.EnhancingDuration)
        elseif spell.english:startswith('Gain') then
            equip(sets.midcast.GainSpell)
        elseif spell.english:contains('Spikes') then
            equip(sets.midcast.SpikesSpell)
        end
        if (spell.target.type == 'PLAYER' or spell.target.type == 'NPC') and buffactive.Composure then
            equip(sets.buff.ComposureOther)
			send_command('@input /echo ** Using Composureother set **')
        end
    end
    if spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
    end
        if spellMap == "Phalanx" and state.PhalanxMode.value == 'Duration' then
            equip(sets.midcast.EnhancingDuration)
            send_command('@input /echo **Phalanx Duration**')
        end
        if spellMap == "Phalanx" and state.PhalanxMode.value == 'Potency' then
            equip(sets.midcast.PhalanxPotency)
            send_command('@input /echo *** Did this set equip the Pemphredo Tathlum for testing purposes? ***')
            send_command('@input /echo **Phalanx Potency**')
        end

    if spell.skill == 'Elemental Magic' then
        if state.MagicBurst.value and spell.english ~= 'Death' then
            equip(sets.magic_burst)
            if spell.english == "Impact" then
                equip(sets.midcast.Impact)
            end
        end
        if spell.skill == 'Elemental Magic' or spell.english == "Kaustra" then
            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
                equip(sets.Obi)
            -- Target distance under 1.7 yalms.
            elseif spell.target.distance < (1.7 + spell.target.model_size) then
                equip({waist="Orpheus's Sash"})
            -- Matching day and weather.
            elseif spell.element == world.day_element and spell.element == world.weather_element then
                equip(sets.Obi)
            -- Target distance under 8 yalms.
            elseif spell.target.distance < (8 + spell.target.model_size) then
                equip({waist="Orpheus's Sash"})
            -- Match day or weather.
            elseif spell.element == world.day_element or spell.element == world.weather_element then
                equip(sets.Obi)
            end
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.english:contains('Sleep') and not spell.interrupted then
        set_sleep_timer(spell)
    end
    if player.status ~= 'Engaged' and state.WeaponLock.value == false then
        check_weaponset()
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

function job_buff_change(buff,gain)
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
        disable('main','sub','range')
    else
        enable('main','sub','range')
    end

    check_weaponset()
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    update_combat_form()
    determine_haste_group()
    check_moving()
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
            if (world.weather_element == 'Light' or world.day_element == 'Light') then
                return 'CureWeather'
            end
        end
        if spell.skill == 'Enfeebling Magic' then
            if enfeebling_magic_skill:contains(spell.english) then
                return "SkillEnfeebles"
            elseif spell.type == "WhiteMagic" then
                if enfeebling_magic_acc:contains(spell.english) and not buffactive.Stymie then
                    return "MndEnfeeblesAcc"
                elseif enfeebling_magic_effect:contains(spell.english) then
                    return "MndEnfeeblesEffect"
                else
                    return "MndEnfeebles"
              end
            elseif spell.type == "BlackMagic" then
                if enfeebling_magic_acc:contains(spell.english) and not buffactive.Stymie then
                    return "IntEnfeeblesAcc"
                elseif enfeebling_magic_effect:contains(spell.english) then
                    return "IntEnfeeblesEffect"
                elseif enfeebling_magic_sleep:contains(spell.english) and ((buffactive.Stymie and buffactive.Composure) or state.SleepMode.value == 'MaxDuration') then
                    return "SleepMaxDuration"
                elseif enfeebling_magic_sleep:contains(spell.english) then
                    return "Sleep"
                else
                    return "IntEnfeebles"
                end
            else
                return "MndEnfeebles"
            end
        end
    end
end

function get_custom_wsmode(spell, action, spellMap)
    local wsmode
    if state.OffenseMode.value == 'MidAcc' or state.OffenseMode.value == 'HighAcc' then
        wsmode = 'Acc'
    end

    return wsmode
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if player.mpp < 71 then
        idleSet = set_combine(idleSet, sets.latent_refresh70)
    end

    -- if state.CP.current == 'on' then
    --     equip(sets.CP)
    --     disable('back')
    -- else
    --     enable('back')
    -- end

    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end

    return idleSet
end

function customize_melee_set(meleeSet)
    if state.EnspellMode.value == true then
        meleeSet = set_combine(meleeSet, sets.engaged.Enspell)
    end
    if state.EnspellMode.value == true and player.hpp <= 75 and player.tp < 1000 then
        meleeSet = set_combine(meleeSet, sets.engaged.Enspell.Fencer)
    end
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    check_weaponset()

    return meleeSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)


    return meleeSet
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local cf_msg = ''
    if state.CombatForm.has_value then
        cf_msg = ' (' ..state.CombatForm.value.. ')'
    end

    local m_msg = state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        m_msg = m_msg .. '/' ..state.HybridMode.value
    end

    local ws_msg = state.WeaponskillMode.value

    local c_msg = state.CastingMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.MagicBurst.value then
        msg = ' Burst: On |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060).. ' Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 14 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 15 and DW_needed <= 26 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 26 and DW_needed <= 32 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 32 and DW_needed <= 43 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 43 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
        if type(tonumber(cmdParams[2])) == 'number' then
            if tonumber(cmdParams[2]) ~= DW_needed then
            DW_needed = tonumber(cmdParams[2])
            DW = true
            end
        elseif type(cmdParams[2]) == 'string' then
            if cmdParams[2] == 'false' then
                DW_needed = 0
                DW = false
            end
        end
        if type(tonumber(cmdParams[3])) == 'number' then
            if tonumber(cmdParams[3]) ~= Haste then
                Haste = tonumber(cmdParams[3])
            end
        end
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

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'scholar' then
        handle_strategems(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'nuke' then
        handle_nuking(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'enspell' then
        send_command('@input /ma '..state.EnSpell.value..' <me>')
    elseif cmdParams[1]:lower() == 'barelement' then
        send_command('@input /ma '..state.BarElement.value..' <me>')
    elseif cmdParams[1]:lower() == 'barstatus' then
        send_command('@input /ma '..state.BarStatus.value..' <me>')
    elseif cmdParams[1]:lower() == 'gainspell' then
        send_command('@input /ma '..state.GainSpell.value..' <me>')
    end

    gearinfo(cmdParams, eventArgs)
end

-- General handling of strategems in an Arts-agnostic way.
-- Format: gs c scholar <strategem>

function handle_strategems(cmdParams)
    -- cmdParams[1] == 'scholar'
    -- cmdParams[2] == strategem to use

    if not cmdParams[2] then
        add_to_chat(123,'Error: No strategem command given.')
        return
    end
    local strategem = cmdParams[2]:lower()

    if strategem == 'light' then
        if buffactive['light arts'] then
            send_command('input /ja "Addendum: White" <me>')
        elseif buffactive['addendum: white'] then
            add_to_chat(122,'Error: Addendum: White is already active.')
        else
            send_command('input /ja "Light Arts" <me>')
        end
    elseif strategem == 'dark' then
        if buffactive['dark arts'] then
            send_command('input /ja "Addendum: Black" <me>')
        elseif buffactive['addendum: black'] then
            add_to_chat(122,'Error: Addendum: Black is already active.')
        else
            send_command('input /ja "Dark Arts" <me>')
        end
    elseif buffactive['light arts'] or buffactive['addendum: white'] then
        if strategem == 'cost' then
            send_command('input /ja Penury <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Celerity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Accession <me>')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: White" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    elseif buffactive['dark arts']  or buffactive['addendum: black'] then
        if strategem == 'cost' then
            send_command('input /ja Parsimony <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Alacrity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Manifestation <me>')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: Black" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    else
        add_to_chat(123,'No arts has been activated yet.')
    end
end

function set_sleep_timer(spell)
    local self = windower.ffxi.get_player()

    if spell.en == "Sleep II" then
        base = 90
    elseif spell.en == "Sleep" or spell.en == "Sleepga" then
        base = 60
    end

    if state.Buff.Saboteur then
        if state.NM.value then
            base = base * 1.25
        else
            base = base * 2
        end
    end

    -- Merit Points Duration Bonus
    base = base + self.merits.enfeebling_magic_duration*6

    -- Relic Head Duration Bonus
    if not ((buffactive.Stymie and buffactive.Composure) or state.SleepMode.value == 'MaxDuration') then
        base = base + self.merits.enfeebling_magic_duration*3
    end

    -- Job Points Duration Bonus
    base = base + self.job_points.rdm.enfeebling_magic_duration

    --Enfeebling duration non-augmented gear total
    gear_mult = 1.40
    --Enfeebling duration augmented gear total
    aug_mult = 1.25
    --Estoquer/Lethargy Composure set bonus
    --2pc = 1.1 / 3pc = 1.2 / 4pc = 1.35 / 5pc = 1.5
    empy_mult = 1 --from sets.midcast.Sleep

    if ((buffactive.Stymie and buffactive.Composure) or state.SleepMode.value == 'MaxDuration') then
        if buffactive.Stymie then
            base = base + self.job_points.rdm.stymie_effect
        end
        empy_mult = 1.35 --from sets.midcast.SleepMaxDuration
    end

    totalDuration = math.floor(base * gear_mult * aug_mult * empy_mult)

    -- Create the custom timer
    if spell.english == "Sleep II" then
        send_command('@timers c "Sleep II ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00259.png')
    elseif spell.english == "Sleep" or spell.english == "Sleepga" then
        send_command('@timers c "Sleep ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00253.png')
    end
    add_to_chat(1, 'Base: ' ..base.. ' Merits: ' ..self.merits.enfeebling_magic_duration.. ' Job Points: ' ..self.job_points.rdm.stymie_effect.. ' Set Bonus: ' ..empy_mult)

end

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
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

function check_weaponset()
    equip(sets[state.WeaponSet.current])
    if player.sub_job ~= 'NIN' and player.sub_job ~= 'DNC' then
       equip(sets.DefaultShield)
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
    -- Default macro set/book
    set_macro_page(6, 7)
end

function set_lockstyle()
    send_command('wait 5; input /lockstyleset ' .. lockstyleset)
end

