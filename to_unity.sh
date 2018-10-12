#!/bin/bash

# ---- Close ---- #

# close focused
cfn='close-focused-normal.png'

# close focused:hover
cfh='close-focused-active.png'

# close focused:active
cfa='close-focused-pressed.png'

# close unfocused
cun='close-unfocused-normal.png'

# ---- Minimize ---- #

# minimize focused
mfn='minimize-focused-normal.png'

# minimize focused:hover
mfh='minimize-focused-active.png'

# minimize focused:active
mfa='minimize-focused-pressed.png'

# minimize unfocused
mun='minimize-unfocused-normal.png'

# ---- Maximize ---- #

# maximize focused
mxfn='maximize-focused-normal.png'

# maximize focused:hover
mxfh='maximize-focused-active.png'

# maximize focused:active
mxfa='maximize-focused-pressed.png'

# maximize unfocused
mxun='maximize-unfocused-normal.png'

# ---- Restore ---- #

# restore focused
rfn='restore-focused-normal.png'

# restore focused:hover
rfh='restore-focused-active.png'

# restore focused:active
rfa='restore-focused-pressed.png'

# restore unfocused
run='restore-unfocused-normal.png'

# ---- Execution ---- #

# make unity folder
mkdir unity

# copy & rename files (close)
cp $cfn unity/close.png
cp $cfn unity/close_focused_normal.png
cp $cfh unity/close_focused_prelight.png
cp $cfa unity/close_focused_pressed.png
cp $cun unity/close_unfocused.png
cp $cfh unity/close_unfocused_prelight.png
cp $cfa unity/close_unfocused_pressed.png

# copy & rename files (maximize)
cp $mxfn unity/maximize.png
cp $mxfn unity/maximize_focused_normal.png
cp $mxfh unity/maximize_focused_prelight.png
cp $mxfa unity/maximize_focused_pressed.png
cp $mxun unity/maximize_unfocused.png
cp $mxfh unity/maximize_unfocused_prelight.png
cp $mxfa unity/maximize_unfocused_pressed.png

# copy & rename files (minimize)
cp $mfn unity/minimize.png
cp $mfn unity/minimize_focused_normal.png
cp $mfh unity/minimize_focused_prelight.png
cp $mfa unity/minimize_focused_pressed.png
cp $mun unity/minimize_unfocused.png
cp $mfh unity/minimize_unfocused_prelight.png
cp $mfa unity/minimize_unfocused_pressed.png

# copy & rename files (restore)
cp $rfn unity/unmaximize.png
cp $rfn unity/unmaximize_focused_normal.png
cp $rfh unity/unmaximize_focused_prelight.png
cp $rfa unity/unmaximize_focused_pressed.png
cp $run unity/unmaximize_unfocused.png
cp $rfh unity/unmaximize_unfocused_prelight.png
cp $rfa unity/unmaximize_unfocused_pressed.png
