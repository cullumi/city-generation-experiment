extends Node

# Named "Count" in Autoload

var counters = {}
func make_counters(keys):
	for key in keys:
		counters[key] = 0
func make_counter(key):
	counters[key] = 0
func increment(key, amount=1):
	counters[key] += int(amount)
func decrement(key, amount=1):
	counters[key] -= int(amount)
func peek(key):
	print(key, ": ", counters[key])
func peek_all():
	for key in counters.keys():
		peek(key)
func pop(key):
	print(key, ": ", counters[key])
	counters[key] = 0
func pop_all():
	for key in counters.keys():
		pop(key)
