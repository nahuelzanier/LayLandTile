extends Node
class_name TileBehaviour

func entity_walk(): return false

func obstacle(): return false

func hole(): return true

func step_height(): return 0


###############################

func render(layer, iso_pos): pass
func render_adjacents(layer, iso_pos): pass
