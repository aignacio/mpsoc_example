all:
	fusesoc run --target=stl example:mpsoc:1.0.0

program:
	fusesoc run --target=stl --run example:mpsoc:1.0.0

#	fusesoc run --target=deca demo:examples:deca:1.0.0
