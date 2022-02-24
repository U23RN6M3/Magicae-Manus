extends Node
class_name NameGenerator

static func pick_random(array: Array):
	randomize()
	return array[randi() % array.size()]

static func new_name():
	var start = ["Ma", "Fo", "Pe", "Ka", "Li", "Cho", "Gu", "Qua", "La", "Ma", "Ki", "A", "De", "Me", "Pu", "Yu", "O", "Os", "Fi"]
	var middle = ["kite", "lo", "jef", "vi", "kes", "pre", "kaci", "doa", "nipu", "asa", "kyp", "ludo", "sepa", "we", "liz", "rano", "rema", "kote", "koma", "kopa", "pose", "reh", "beh", "seh", "hesti"]
	var end = ["r", "er", "fe", "po", "", "", "jin", "pun", "us", "al", "pre", "kaci", "doa", "nipu", "asa", "kyp", "land", "rik", "turi", "elle", "ele", "iper"]
	return pick_random(start) + pick_random(middle) + pick_random(end)
