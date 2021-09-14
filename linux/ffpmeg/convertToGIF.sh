#!/bin/bash
VIDEO_FILE=~/Desktop/videoplayback.mp4
START_TIME=0
END_TIME=10

ffmpeg -ss ${START_TIME} -t ${END_TIME} -i ${VIDEO_FILE} -vf "fps=10,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 output10.gif

ffmpeg -ss ${START_TIME} -t ${END_TIME} -i ${VIDEO_FILE} -vf "fps=15,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 output15.gif

ffmpeg -ss ${START_TIME} -t ${END_TIME} -i ${VIDEO_FILE} -vf "fps=24,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 output24.gif
