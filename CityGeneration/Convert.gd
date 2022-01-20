extends Node

class_name Convert

# feet * 0.3048 = meter
# meter * 3.28084 = foot
# inch * 0.0254 = meter
# meter * 39.3701 = inch

static func ft_to_m(value) -> float:
	return value / 3.28084

static func m_to_ft(value) -> float:
	return value * 3.28084

static func in_to_m(value) -> float:
	return value / 39.3701

static func m_to_in(value) -> float:
	return value * 39.3701
