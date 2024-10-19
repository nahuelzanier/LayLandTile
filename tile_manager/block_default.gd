extends TileBehaviour

func entity_walk(): return true

func obstacle(): return true

func hole(): return false

func steps(): return 1

#####################################

func render(layer, iso_pos):
	Game.map.set_tile(layer, iso_pos, 1)
