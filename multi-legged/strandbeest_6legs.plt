reset
set angle degrees
 
#=================== Parameters ====================
# Length of each link
link_a = 38.0 ; link_b = 41.5 ; link_c = 39.3
link_d = 40.1 ; link_e = 55.8 ; link_f = 39.4
link_g = 36.7 ; link_h = 65.7 ; link_i = 49.0
link_j = 50.0 ; link_k = 61.9 ; link_l = 7.8 ; link_m = 15.0
 
LINK_NUM = 11
LEG_SET_NUM = 3 # Number of pair of legs
PLOT_RANGE = (360/LEG_SET_NUM)/2 # Length of plotted trajectory [deg]
 
# Angle (time invariant)
gamma = acos((link_b**2+link_d**2-link_e**2) / (2*link_b*link_d))
eta = acos((link_g**2+link_i**2-link_h**2) / (2*link_g*link_i))
# Fixed Joint O, B
Ox = 0 ; Oy = 0
Bx = -link_a ; By = -link_l
 
#=================== Functions ====================
# Joint A
Ax(t) = link_m*cos(t)
Ay(t) = link_m*sin(t)
# Joint C
AB(t) = sqrt((Ax(t)-Bx)**2 + (Ay(t)-By)**2)
alpha(t) = atan2(Ay(t)-By, Ax(t)-Bx)
beta(t) = acos((AB(t)**2+link_b**2-link_j**2) / (2*AB(t)*link_b))
Cx(t) = Bx + link_b*cos(alpha(t)+beta(t))
Cy(t) = By + link_b*sin(alpha(t)+beta(t))
# Joint D
Dx(t) = Bx + link_d*cos(alpha(t)+beta(t)+gamma)
Dy(t) = By + link_d*sin(alpha(t)+beta(t)+gamma)
# Joint E
delta(t) = acos((AB(t)**2+link_c**2-link_k**2) / (2*AB(t)*link_c))
Ex(t) = Bx + link_c*cos(alpha(t)-delta(t))
Ey(t) = By + link_c*sin(alpha(t)-delta(t))
# Joint F
DE(t) = sqrt((Ex(t)-Dx(t))**2 + (Ey(t)-Dy(t))**2)
epsilon(t) = atan2(Dy(t)-Ey(t), Dx(t)-Ex(t))
zeta(t) = acos((DE(t)**2+link_g**2-link_f**2) / (2*DE(t)*link_g))
Fx(t) = Ex(t) + link_g*cos(epsilon(t)+zeta(t))
Fy(t) = Ey(t) + link_g*sin(epsilon(t)+zeta(t))
# Joint G
Gx(t) = Ex(t) + link_i*cos(epsilon(t)+zeta(t)+eta)
Gy(t) = Ey(t) + link_i*sin(epsilon(t)+zeta(t)+eta)
 
# Round off to the i decimal place.
round(x, i) = 1 / (10.**(i+1)) * floor(x * (10.**(i+1)) + 0.5)
# x[deg], return[deg]: Convert x to make it easy to draw the trajectory
plot_angle(x) = (x>=0 && x<PLOT_RANGE) ? x+360: x
# x[deg], return[-]: Select the row when drawing the trajectory
plot_rownum(x) = int(plot_angle(x)*DEG_DIV) + 1
#　x[deg], return[deg]: Make negative value x positive by adding a full angle
NtoP(x) =  (x<0) ? NtoP(x+360) : x
 
#=================== Calculation ====================
# Prepare DAT file
outputfile = 'outputfile.dat'
set print outputfile
 
DEG_DIV = 5.0  # Resolution of degree, increase by 1/DEG_DIV
 
# Write items and parameters in outputfile
print '#deg / Ox Oy / Ax Ay / Bx By / Cx Cy / Dx Dy / Ex Ey / Fx Fy / Gx Gy'
print sprintf('# DEG_DIV=%d', DEG_DIV)
 
# Calculate and output position of joints in outputfile
do for[i=0:360*(1+1./(LEG_SET_NUM*2))*DEG_DIV:1]{
  deg = i/DEG_DIV
 
  # Output deg, position of joints, whether line is straight or curve
  print deg, Ox, Oy, round(Ax(deg), 2), round(Ay(deg), 2), Bx, By, \
    round(Cx(deg), 2), round(Cy(deg), 2), round(Dx(deg), 2), round(Dy(deg), 2), \
    round(Ex(deg), 2), round(Ey(deg), 2), round(Fx(deg), 2), round(Fy(deg), 2), \
    round(Gx(deg), 2), round(Gy(deg), 2), round(-Gx(180-deg), 2), round(Gy(180-deg), 2)
}
 
unset print
print "Finish calculation!" # Notice
 
#=================== Plot ====================
# Setting
set term png truecolor enhanced size 960, 720
system 'mkdir png'
set size ratio -1
unset key
set xr[-120:120]
set yr[-100:60]
set xl 'x' font 'TimesNewRoman:Italic, 20'
set yl 'y' font 'TimesNewRoman:Italic, 20'
set tics
set grid
set border
 
# Output PNG file
LOOP = 8                            # Number of animation loop
WHITEN_VAL = int(180./LEG_SET_NUM)  # Add this to color, turn whiter
LW = 4                              # Line width
CIRC_R = 2                          # Radius od joint
 
do for[i=0:360*DEG_DIV*LOOP:DEG_DIV]{
  deg = int(i/DEG_DIV)%360
  set title sprintf("{/:Italic θ} = %d°", deg) font 'TimesNewRoman, 20'
  set output sprintf("png/img_%04d.png", i/DEG_DIV)
 
  # Make a command for plotting trajectory of joint A
  plot_command = "plot outputfile u 4:5 w l lw LW*0.7 lc rgb 'red'"
 
  # Draw j th pair of legs
  do for[j=0:LEG_SET_NUM-1:1]{
    # Draw a left leg (k=0) and a right leg (k=1)
    do for[k=0:1:1]{
      sign = 1-2*k  # sign = 1 (positive) or -1 (negative)
      draw_deg = 180*k + sign*(deg-j*360./LEG_SET_NUM)
 
      # Draw unfixed joints
      posAx = sign*Ax(draw_deg) ; posAy = Ay(draw_deg)
      posBx = sign*Bx
      posCx = sign*Cx(draw_deg) ; posCy = Cy(draw_deg)
      posDx = sign*Dx(draw_deg) ; posDy = Dy(draw_deg)
      posEx = sign*Ex(draw_deg) ; posEy = Ey(draw_deg)
      posFx = sign*Fx(draw_deg) ; posFy = Fy(draw_deg)
      posGx = sign*Gx(draw_deg) ; posGy = Gy(draw_deg)
 
      # Draw links
      color = 0x000000 + (WHITEN_VAL*j << 16)+(WHITEN_VAL*j << 8)+(WHITEN_VAL*j << 0) # Base color: Black
 
      set arrow 1+(j+LEG_SET_NUM*k)*LINK_NUM from posBx, By to posCx, posCy nohead filled lc rgb color lw LW front # link b
      set arrow 2+(j+LEG_SET_NUM*k)*LINK_NUM from posBx, By to posEx, posEy nohead filled lc rgb color lw LW front # link c
      set arrow 3+(j+LEG_SET_NUM*k)*LINK_NUM from posBx, By to posDx, posDy nohead filled lc rgb color lw LW front # link d
      set arrow 4+(j+LEG_SET_NUM*k)*LINK_NUM from posCx, posCy to posDx, posDy nohead lc rgb color lw LW front # link e
      set arrow 5+(j+LEG_SET_NUM*k)*LINK_NUM from posDx, posDy to posFx, posFy nohead lc rgb color lw LW front # link f
      set arrow 6+(j+LEG_SET_NUM*k)*LINK_NUM from posEx, posEy to posFx, posFy nohead lc rgb color lw LW front # link g
      set arrow 7+(j+LEG_SET_NUM*k)*LINK_NUM from posFx, posFy to posGx, posGy nohead lc rgb color lw LW front # link h
      set arrow 8+(j+LEG_SET_NUM*k)*LINK_NUM from posEx, posEy to posGx, posGy nohead lc rgb color lw LW front # link i
      set arrow 9+(j+LEG_SET_NUM*k)*LINK_NUM from posAx, posAy to posCx, posCy nohead lc rgb color lw LW front # link j
      set arrow 10+(j+LEG_SET_NUM*k)*LINK_NUM from posAx, posAy to posEx, posEy nohead lc rgb color lw LW front # link k
      set arrow 11+(j+LEG_SET_NUM*k)*LINK_NUM from Ox, Oy to posAx, posAy nohead lc rgb color lw LW front # link m
 
      # Draw a big circle as joint A
      set obj 1+j circ at posAx, posAy size CIRC_R fc rgb color fs solid front
 
      # Draw trajectory of joint G
      plot_deg = deg-j*360./LEG_SET_NUM
      end = plot_rownum(NtoP(plot_deg)) # End point for plot
      start = end - PLOT_RANGE*DEG_DIV  # Start point for plot
      plot_command = plot_command.sprintf(", outputfile u %d:%d every ::%d::%d w l lw LW*0.7 lc rgb 'royalblue'", 16+2*k, 17+2*k, start, end)
    }
  }
 
  eval plot_command # Plot all of the trajectories
  set out
}
 
print "Finish plot!" # Notice