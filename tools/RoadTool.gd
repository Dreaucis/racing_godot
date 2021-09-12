tool
extends Path2D

export var properly_close = false setget properly_close

func _on_RoadToolPath2D_draw():
    print('drawing')
    $TextureLine2D.points = curve.get_baked_points()

func properly_close(_x):
    """ Attemps to close the curve such that the textures transitions smoothly"""
    var last_point_idx = curve.get_point_count() -1
    
    var start_position = curve.get_point_position(0)
    var end_position = curve.get_point_position(last_point_idx)
    
    var out_vector = curve.get_point_out(0)
    
    var diff_vect = (end_position - start_position)
    
    var in_vect = diff_vect.project(out_vector.normalized())#.rotated(PI)
    
    curve.add_point(start_position, in_vect)
