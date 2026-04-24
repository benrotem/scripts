#!/usr/bin/env bash

WALL_PATH="$HOME/doc/nebula-1920x1200.jpg"
OUT_PATH="$HOME/tmp/wall.jpg"
LOG_PATH="$HOME/tmp/today.txt"

WALL_W=1920
WALL_H=1200
LEN=240    # Must be a factor of both WALL_W and WALL_H!

SQUARES_X=$(($WALL_W/$LEN))
SQUARES_Y=$(($WALL_H/$LEN))

# At the start of a new day, clear all previous commits
log_date=$(/usr/bin/date -I -r $LOG_PATH)
today=$(/usr/bin/date -I)

if [ $log_date != $today ]; then
	> $LOG_PATH
fi

# Count number of commits today
n_max=$(/usr/bin/wc -l < $LOG_PATH)
n_max=$n_max*8

# Reset
/usr/bin/magick $WALL_PATH $OUT_PATH
n=0

# Draw squares over wallpaper
for (( j=0; j<$SQUARES_Y; j++ )); do
	for (( i=0; i<$SQUARES_X; i++, ((n++)) )); do
		if [[ $n -lt $n_max ]]; then
			# Each commit frees a square off the wallpaper
			continue
		fi
		
		x0=$((i*$LEN))
		y0=$((j*$LEN))
		x1=$(($x0+$LEN))
		y1=$(($y0+$LEN))
		/usr/bin/magick $OUT_PATH -fill red -draw "rectangle $x0,$y0 $x1,$y1" $OUT_PATH
	done
done

# Set wallpaper
DISPLAY=:0 /usr/bin/feh --bg-scale $OUT_PATH
