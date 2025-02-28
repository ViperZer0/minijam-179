extends Resource
class_name Harmonic

## Which harmonic this represents, from 0th (the base), to the Nth.
@export_range(0, 16, 1, "or_greater") var harmonic_number: int

## The strength of this harmonic.
@export_range(0, 1, 0.05) var harmonic_strength: float
