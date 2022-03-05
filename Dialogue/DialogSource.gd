extends Node

onready var test = [
	{"Text":"I have not played in a long time.", "Pitch":1},
	{"Text":"Forgive me for my lack of knowledge on magic.", "Pitch":1},
]

onready var wrig = [
	{"Text":"What?", "Pitch":0.5},
	{"Text":"How didya get here???", "Pitch":0.5},
	{"Text":"Oh well", "Pitch":0.5},
	{"Text":"Since ye're here now", "Pitch":0.5},
	{"Text":"Might as well do somethin' about it!", "Pitch":0.5},
	{"Text":"Let's battle kid!", "Pitch":0.5}
]

onready var wrigfight = [
	{"Text":"Let's just get this overwith, wrig.", "Pitch":1}
]

onready var npc_default = [
	{"Text":"Hello Lion", "Pitch":1.5},
	{"Text":"I haven't seen a lion here in a while", "Pitch":1.5},
	{"Text":"[shake rate=20 level=1]Have a... great time[/shake]", "Pitch":1.5},
	{"Text":"[shake rate=20 level=2]Lion...[/shake]", "Pitch":1.5},
	{"Text":"[shake rate=30 level=3]...[/shake]", "Pitch":1.5},
]

onready var fred_dungeon_1 = [
	{"Text":"You've played well.", "Pitch":1},
	{"Text":"This, would be enough.", "Pitch":1},
	{"Text":"We should prepare for tomorrow.", "Pitch":1},
	{"Text":"Also,", "Pitch":1},
	{"Text":"Brother Yamiel is asking permission to, restore the hybrid card project.", "Pitch":1},
	{"Text":"I told him to pospone the project as of, tomorrow's event.", "Pitch":1},
	{"Text":"With enough practice, we can get you to master this game.", "Pitch":1},
	{"Text":"and Faction Father will not be disappointed.", "Pitch":1},
	{"Text":"I[shake rate=30 level=3]...[/shake] Hope.", "Pitch":1},
]

onready var fred_dungeon_2 = [
	{"Text":"Perhaps, check on the lads who are in charge of the supplies", "Pitch":1},
	{"Text":"we need to be prepared. I heard Faction Igor have, noticed our defenses are down.", "Pitch":1},
]

onready var tutorial1 = [
	{"Text":"Great, you're here. I'l show you around.", "Pitch":1},
	{"Text":"Every time you start a battle, you always draw a charge card.", "Pitch":1},
	{"Text":"Charge cards have the [+] symbol on them.", "Pitch":1},
	{"Text":"Once you've done the first move, you have a selection of cards to pick from. The basic cards are:", "Pitch":1},
	{"Text":"Block, a Defend Card[#], cost 0 charges. And will defend you by the enemy's attack card by your defend card's defense points.", "Pitch":1},
	{"Text":"Abra, an Attack Card[-], cost 1 charge. Therefore taking a charge from your available charges", "Pitch":1},
	{"Text":"you can view how many charges you and your enemy have by the blue bar beside your card play areas.", "Pitch":1},
	{"Text":"If the enemy did not perform an attack card that equals your attack card's damage,", "Pitch":1},
	{"Text":"or if they did not play a defend card with equal or more defense points to the your attack card,", "Pitch":1},
	{"Text":"the enemy will loose a heart.", "Pitch":1},
	{"Text":"You have 3 hearts, If you loose a heart, you're one step closer to loosing against the enemy.", "Pitch":1},
	{"Text":"Loose all hearts, its game over for you.", "Pitch":1},
	{"Text":"Try playing this match,", "Pitch":1},
	{"Text":"The rules are set to 'Simple'.", "Pitch":1},
	{"Text":"Which means that the only cards available are Charge, Abra, and Block cards.", "Pitch":1},
	{"Text":"Be prepared with a strategy for every game you play", "Pitch":1},
	{"Text":"And study your opponent's strategies too.", "Pitch":1},
	{"Text":"Good Luck on this game.", "Pitch":1},
	{"Text":"Hopefully I've explained enough.", "Pitch":1},
	{"Text":"Charge!", "Pitch":1},
]

onready var npc_dialogue_list = [npc_default, fred_dungeon_1, wrig, wrigfight, fred_dungeon_2]
