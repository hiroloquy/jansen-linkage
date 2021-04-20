reset
set angle degrees
 
#=================== Parameters ====================
# Length of each link
link_a = 38.0 ; link_b = 41.5 ; link_c = 39.3
link_d = 40.1 ; link_e = 55.8 ; link_f = 39.4
link_g = 36.7 ; link_h = 65.7 ; link_i = 49.0
link_j = 50.0 ; link_k = 61.9 ; link_l = 7.8 ; link_m = 15.0
 
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
 
#=================== Calculation ====================
# Prepare DAT file
outputfile = 'outputfile.dat'
set print outputfile
 
DEG_DIV = 5.0 # Resolution of degree, increase by 1/DEG_DIV
 
# Write items and parameters in outputfile
print '#deg / Ox Oy / Ax Ay / Bx By / Cx Cy / Dx Dy / Ex Ey / Fx Fy / Gx Gy / straight or curve'
print sprintf('# DEG_DIV=%d', DEG_DIV)
 
# Calculate and output position of joints in outputfile
do for[i=0:360*DEG_DIV:1]{
  deg = i/DEG_DIV
  line = ' c'  # default: curve
 
  # Whether D's motion is approximate straight-line or not at θ = deg
  if(deg < 150 || deg > 210){
    if((Gx(deg+1)>Gx(deg)) && (Gx(deg)>Gx(deg-1)) && \
    (abs(Gy(deg+1)-Gy(deg))<1.e-1) && (abs(Gy(deg)-Gy(deg-1))<1.e-1)){
      line = ' s'  # D's motion is approximate straight-line at θ = deg
    }
  }
 
  # Output deg, position of joints, whether line is straight or curve
  print deg, Ox, Oy, round(Ax(deg), 2), round(Ay(deg), 2), Bx, By, \
    round(Cx(deg), 2), round(Cy(deg), 2), round(Dx(deg), 2), round(Dy(deg), 2), \
    round(Ex(deg), 2), round(Ey(deg), 2), round(Fx(deg), 2), round(Fy(deg), 2), \
    round(Gx(deg), 2), round(Gy(deg), 2), line
}
 
unset print
print "Finish calculation!" # Notice
 
#=================== Plot ====================
# Setting
set term png enhanced size 720, 720
system 'mkdir png'
set size ratio -1
unset key
set xr[-120:40]
set yr[-100:60]
set xl 'x' font 'TimesNewRoman:Italic, 20'
set yl 'y' font 'TimesNewRoman:Italic, 20'
set tics
set grid
set border
 
# Draw fixed joints
CIRC_R = 1.5  # Radius of joints
set obj 1 circ at Ox, Oy size CIRC_R fc rgb 'black' fs solid front
set obj 2 circ at Bx, By size CIRC_R fc rgb 'black' fs solid front
set label 1 'O' center at Ox-8, Oy font 'TimesNewRoman:Italic, 20' front
set label 2 'B' center at Bx+8, By+3 font 'TimesNewRoman:Italic, 20' front
 
# Output png image
LOOP = 2  # Number of animation loop
 
do for[i=0:360*DEG_DIV*LOOP:DEG_DIV]{
  deg = int(i/DEG_DIV)%360
 
  set title sprintf("{/:Italic θ} = %d°", deg) font 'TimesNewRoman, 20'
  set output sprintf("png/img_%04d.png", i/DEG_DIV)
 
  # Draw unfixed joints
  posAx = Ax(deg) ; posAy = Ay(deg)
  posCx = Cx(deg) ; posCy = Cy(deg)
  posDx = Dx(deg) ; posDy = Dy(deg)
  posEx = Ex(deg) ; posEy = Ey(deg)
  posFx = Fx(deg) ; posFy = Fy(deg)
  posGx = Gx(deg) ; posGy = Gy(deg)
  set obj 3 circ at posAx, posAy size CIRC_R fc rgb 'black' fs solid front
  set obj 4 circ at posCx, posCy size CIRC_R fc rgb 'black' fs solid front
  set obj 5 circ at posDx, posDy size CIRC_R fc rgb 'black' fs solid front
  set obj 6 circ at posEx, posEy size CIRC_R fc rgb 'black' fs solid front
  set obj 7 circ at posFx, posFy size CIRC_R fc rgb 'black' fs solid front
  set obj 8 circ at posGx, posGy size CIRC_R fc rgb 'black' fs solid front
  set label 3 'A' center at posAx+8, posAy+3 font 'TimesNewRoman:Italic, 20' front
  set label 4 'C' center at posCx-8, posCy+3 font 'TimesNewRoman:Italic, 20' front
  set label 5 'D' center at posDx-8, posDy font 'TimesNewRoman:Italic, 20' front
  set label 6 'E' center at posEx+8, posEy-3 font 'TimesNewRoman:Italic, 20' front
  set label 7 'F' center at posFx-8, posFy-5 font 'TimesNewRoman:Italic, 20' front
  set label 8 'G' center at posGx+8, posGy+3 font 'TimesNewRoman:Italic, 20' front
 
  # Draw links
  set arrow 1 from Bx, By to posCx, posCy nohead lw 4 front # link b
  set arrow 2 from Bx, By to posEx, posEy nohead lw 4 front # link c
  set arrow 3 from Bx, By to posDx, posDy nohead lw 4 front # link d
  set arrow 4 from posCx, posCy to posDx, posDy nohead lw 4 front # link e
  set arrow 5 from posDx, posDy to posFx, posFy nohead lw 4 front # link f
  set arrow 6 from posEx, posEy to posFx, posFy nohead lw 4 front # link g
  set arrow 7 from posFx, posFy to posGx, posGy nohead lw 4 front # link h
  set arrow 8 from posEx, posEy to posGx, posGy nohead lw 4 front # link i
  set arrow 9 from posAx, posAy to posCx, posCy nohead lw 4 front # link j
  set arrow 10 from posAx, posAy to posEx, posEy nohead lw 4 front # link k
  set arrow 11 from Ox, Oy to posAx, posAy nohead lw 4 front # link m
 
  if(i < 360*DEG_DIV){
    end = i  # Show part of the trajectory
   } else {
    end = 360*DEG_DIV  # Show all the trajectory
   }
 
   # Draw tarjectory of joint G
   plot outputfile u 4:((stringcolumn(18) eq "c" ) ? $5 : 1/0) every ::::end w l lw 3 lc rgb 'royalblue', \
    outputfile u 4:((stringcolumn(18) eq "s" ) ? $5 : 1/0) every ::::end w l lw 3 lc rgb 'red', \
    outputfile u 16:((stringcolumn(18) eq "c" ) ? $17 : 1/0) every ::::end w l lw 3 lc rgb 'royalblue', \
    outputfile u 16:((stringcolumn(18) eq "s" ) ? $17 : 1/0) every ::::end w l lw 3 lc rgb 'red'
 
   set out
}
 
print "Finish plot!" # Notice