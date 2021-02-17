#!/usr/bin/bash

# Small script that provides the same information
# I usually want to get from upower, in pretty colours.

# TODO: Replace python calls with something more efficient

# Directory holding battery info (can change)
# This may be BAT0 on your system.

BATTERY_DIR="/sys/class/power_supply/BAT1"

# Individual filenames (shouldn't need to change)

CHARGE_FILE="capacity"
ENERGY_FULL_DES_FILE="energy_full_design"
ENERGY_FULL_FILE="energy_full"
ENERGY_NOW_FILE="energy_now"
POWER_NOW_FILE="power_now"

# Default variables (can change)

SHOW_REMAINING=0
PRETTY=1
SHOW_CAP=0

# Cycle through every passed argument

for arg in "$@"
do
	case "$arg" in
		-d=* | --directory=*)
			BATTERY_DIR="${arg#*=}"
			shift ;;
		--disable-pretty-print)
			PRETTY=0
			shift ;;
		-c | --capacity)
			SHOW_CAP=1
			shift ;;
		-r | --remaining)
			SHOW_REMAINING=1
			shift ;;
	esac
done

if [ ! -d $BATTERY_DIR ]; then
	echo "Battery info not found at $BATTERY_DIR"
	exit 1
fi

CHARGE=$(<$BATTERY_DIR/$CHARGE_FILE)

# Control codes for coloured output on terminal

if [ $PRETTY -eq 1 ]; then
	PREFORMAT="\e[1m"
	POSTFORMAT="\e[0m"
	GOOD_CHARGE="\e[32m"
	BAD_CHARGE="\e[31m"
	TERRIBLE_CHARGE="\e[5;31m"
fi

if [ $SHOW_CAP -eq 1 ]; then
	ENERGY_FULL_DESIGN=$(<$BATTERY_DIR/$ENERGY_FULL_DES_FILE)
	ENERGY_FULL=$(<$BATTERY_DIR/$ENERGY_FULL_FILE)

	# You can do bash arithmetic directly in shell, but
	# it doesn't handle floats, so offload to python.
	#PYTHON_CMD="print(round(($ENERGY_FULL/$ENERGY_FULL_DESIGN)*100))"
	#CMD_RESULT=$(python -c ${PYTHON_CMD})

	FLOAT_RESULT="$(echo "scale=2;$ENERGY_FULL/$ENERGY_FULL_DESIGN*100" | bc -l)"
	RESULT=$(printf "%.0f\n" $FLOAT_RESULT)

	if [ $RESULT -gt 80 ]; then
		CAP_FORMAT="${GOOD_CHARGE}${RESULT}%${POSTFORMAT}"
	elif [ $RESULT -gt 60 ]; then
		CAP_FORMAT="${BAD_CHARGE}${RESULT}%${POSTFORMAT}"
	else
		CAP_FORMAT="${TERRIBLE_CHARGE}${RESULT}%${POSTFORMAT}"
	fi
	CAPACITY="(${CAP_FORMAT} Capacity)"
fi

if [ $CHARGE -gt 40 ]; then
	CHARGE_COLOUR=$GOOD_CHARGE
elif [ $CHARGE -gt 20 ]; then
	CHARGE_COLOUR=$BAD_CHARGE
else
	CHARGE_COLOUR=$TERRIBLE_CHARGE
fi

if [ $SHOW_REMAINING -eq 1 ]; then
	POWER_NOW=$(<$BATTERY_DIR/$POWER_NOW_FILE)
	ENERGY_NOW=$(<$BATTERY_DIR/$ENERGY_NOW_FILE)

	#PYTHON_CMD="print(round(($ENERGY_NOW/$POWER_NOW),2))"
	#CMD_RESULT=$(python -c ${PYTHON_CMD})

	RESULT="$(echo "scale=2;$ENERGY_NOW/$POWER_NOW" | bc -l)"

	EST_TIME="${PREFORMAT}Remaining Time: ${POSTFORMAT}${RESULT}h\n"
fi

echo -e ${PREFORMAT}Battery:${POSTFORMAT}\
	${CHARGE_COLOUR}${CHARGE}%${POSTFORMAT} ${CAPACITY}
echo -ne $EST_TIME
