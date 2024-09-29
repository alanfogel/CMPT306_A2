extends Label

var score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_score_label()

# Function to update the score and refresh the label text.
func update_score_label() -> void:
	text = "Score: " + str(score)

# Function to increment the score by 1.
func increment_score() -> void:
	score += 1
	update_score_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
