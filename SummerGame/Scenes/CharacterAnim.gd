extends Node2D

export var transitionSpeed = 100

var accelerate
var changeAnim = false

func _physics_process(_delta: float) -> void:
	
#	Om changeAnim är aktiv kommer transationen att försöka ske
	if changeAnim:
		
		var blender = $AnimationTree.get("parameters/Moving/blend_amount")
		
#		Ökar blend_amount vid acceleration
		if accelerate:
			blender += (transitionSpeed/1000.0)
			if blender >= 1:
				blender = 1
				changeAnim = false
#		Sänker blend_amount vid retardation
		else:
			blender -= (transitionSpeed/1000.0)
			if blender <= 0:
				blender = 0
				changeAnim = false
		
#		Applicerar frändringen till AnimationTree
		$AnimationTree.set("parameters/Moving/blend_amount", blender)


#	Kallas varje gång som karaktärens rörelse ändras 
func movementChanged( move: Vector2 ) -> void:

#	Sätter Accelerate till sant om karakätren rör sig, annars till falskt 
	accelerate = true if max( abs(move.x), abs(move.y) ) > 0 else false
#	ChangeAnim sätts till sant för att ändra animationerna om så behövs
	changeAnim = true
	
#	Kollar Karaktärens rörelse och ser om den behöver speglas eller inte
	if move.x != 0:
		var scale = self.get("scale")
		
#		Om riktning är tvärtom från karaktärens riktning så speglas den 
		if ( scale.x > 0 and move.x < 0 ) or ( scale.x < 0 and move.x > 0 ):
			self.set("scale", Vector2(-scale.x, scale.y) )
