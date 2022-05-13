extends CanvasLayer

func show_title(high_score):
	$ColorRect.show()
	$Title.show()
	$Level.hide()
	$Score.hide()
	if high_score:
		update_high_score(high_score)
		$HighScore.show()
	
func show_game(lvl):
	$ColorRect.hide()
	$Title.hide()
	$HighScore.hide()
	$Level.show()
	$Score.show()
	$Level.text = "Level: " + str(lvl)


func update_score(score):
	$Score.text = "Score: " + str(score)


func update_high_score(score):
	$HighScore.text = "High Score: " + str(score)
