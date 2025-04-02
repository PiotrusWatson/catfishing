extends VSlider

func init(max, step, value):
	min_value = value
	max_value = max
	self.step = step

func update(current):
	value = current
