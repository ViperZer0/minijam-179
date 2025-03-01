extends Resource
class_name Harmonics

## The list of harmonics
@export var harmonics: Array[Harmonic]

func _init(h: Array[Harmonic] = []):
	harmonics = h

## Harmonics *should* always be in order, but sometimes they might not be!!
## If there is no matching harmonic with this index, we just return null
func find_harmonic_index(index: int) -> Harmonic:
	# We could just try the index first since that's O(1) probably?
	var harmonic: Harmonic
	# Though we should check for out of bounds teehee
	if index < harmonics.size():
		harmonic = harmonics[index]
	# If the index doesn't match we have to do a search
	if harmonic == null or harmonic.harmonic_number != index:
		# There should only be 1 or 0 in this filtered array
		var matching_harmonics = harmonics.filter(func (h: Harmonic): return h.harmonic_number == index)
		if matching_harmonics.is_empty():
			# Whoops, there are *no* harmonics with that index
			return null
		# Otherwise let's just return the first one
		harmonic = matching_harmonics[0]

	return harmonic

## Calculates the error difference between this harmonic and another harmonic
func error(other: Harmonics) -> float:
	var total_error: float = 0.0
	for i in range(0, max(harmonics.size(), other.harmonics.size())):
		# Default to a strength of 0.0 if an index isn't found
		var this_harmonic_strength: float = 0.0
		var other_harmonic_strength: float = 0.0
		var this_harmonic = find_harmonic_index(i)
		var other_harmonic = other.find_harmonic_index(i)

		if this_harmonic != null:
			this_harmonic_strength = this_harmonic.harmonic_strength
		if other_harmonic != null:
			other_harmonic_strength = other_harmonic.harmonic_strength

		# Error squared
		total_error += pow(this_harmonic_strength - other_harmonic_strength, 2)

	# Normalize/average error and return
	return total_error / max(harmonics.size(), other.harmonics.size())

## Returns the harmonic with the highest strength
## Returns a harmonic index of -1 if there are no active harmonics
func get_loudest_harmonic() -> Harmonic:
	var max_harmonic: Harmonic = Harmonic.new(-1, 0.0)
	for harmonic in harmonics:
		if harmonic.harmonic_strength > max_harmonic.harmonic_strength:
			max_harmonic = harmonic

	return max_harmonic

## Normalizes the harmonics, making the loudest one equal to 1 and all the others proportional to that.
func normalize() -> Harmonics:
	var max_harmonic = get_loudest_harmonic()
	# If there are literally no active harmonics, we just leave them all at 0
	if max_harmonic.harmonic_number == -1:
		return

	var scaling = 1.0 / max_harmonic.harmonic_strength
	for harmonic in harmonics:
		harmonic.harmonic_strength = harmonic.harmonic_strength * scaling

	return self

static func generate_random_harmonics(num_harmonics: int, num_include_harmonics: float) -> Harmonics:
	var new_harmonics = Harmonics.new()

	# generate all harmonics, then pick the ones to fill out
	for i in range(0, num_harmonics):
		new_harmonics.harmonics.push_back(Harmonic.new(i, 0.0))

	# Add x number of harmonics
	for i in range(0, num_include_harmonics):
		# pick one at random
		var candidate_harmonic: Harmonic = new_harmonics.harmonics[randi() % new_harmonics.size()]
		# Keep searching until we find one that isn't already chosen
		while candidate_harmonic.harmonic_strength > 0.0:
			candidate_harmonic = new_harmonics.harmonics[randi() % new_harmonics.size()]

		# Set the new harmonics strength
		candidate_harmonic.harmonic_strength = randf()

	return new_harmonics
