# Jansen Linkage
"jansen-linkage" is a simulator of a linkage mechanism  with gnuplot.

## Demo
<p align="center">
    <img src="/doc/trajectory.gif" height="350" alt="trajectory.gif" title="trajectory.gif">
</p>

<p align="center">
    <img src="/doc/jansen_6legs.gif" height="350" alt="jansen_6legs.gif" title="jansen_6legs.gif">
</p>

## Modeling

### Coordinate of the joints $\overrightarrow{\mathrm{A}}$, $\overrightarrow{\mathrm{B}}$ and $\overrightarrow{\mathrm{C}}$

<p align="center">
    <img src="\doc\fig_OABC.png"height="300" alt="fig_OABC.png" title="fig_OABC.png">
</p>

Let

$$
\begin{array}{lll}
  a=38.0 & b=41.5 & c=39.3 & d=40.1 & e=55.8\\
  f=39.4 & g=36.7 & h=65.7 & i=49.0 & j=50.0\\
  k=61.9 & l=7.8 & m=15.0 & & \\
\end{array}
$$

These numbers are called "Holy Numbers". Then

$$
\begin{eqnarray*}
    \overrightarrow{\mathrm{OA}} &=& \begin{bmatrix}m
        \cos\theta\\
        m\sin\theta
    \end{bmatrix}\\
    \overrightarrow{\mathrm{OB}} &=& \begin{bmatrix}
        -a\\
        -l
    \end{bmatrix}\\
    \overrightarrow{\mathrm{OC}} &=& \overrightarrow{\mathrm{OB}} +\overrightarrow{\mathrm{BC}} &=& \left[
    \begin{array}{c}
        -a + b\cos(\alpha+\beta)\\
        -l + b\sin(\alpha+\beta)
        \end{array}
    \right]
\end{eqnarray*}
$$

where

$$
\begin{eqnarray*}
    \alpha &=& \arctan2\left(\mathrm{A}_y-\mathrm{B}_y, \mathrm{A}_x-\mathrm{B}_x\right)\\
    \beta &=& \arccos\left(\frac{\mathrm{AB}^{2}+b^{2}-j^{2}}{2\cdot \mathrm{AB}\cdot b}\right)
\end{eqnarray*}
$$

### Coordinates of the joints $\overrightarrow{\mathrm{D}}$ and $\overrightarrow{\mathrm{E}}$

<p align="center">
    <img src="\doc\fig_DE.png" height="300" alt="fig_DE.png" title="fig_DE.png">
</p>

$$
\begin{eqnarray*}
    \overrightarrow{\mathrm{OD}} &=& \overrightarrow{\mathrm{OB}}+\overrightarrow{\mathrm{BD}}&=&\left[
    \begin{array}{c}
        -a + b\cos(\alpha+\beta+\gamma)\\
        -l + b\sin(\alpha+\beta+\gamma)
        \end{array}
    \right]\\
    \overrightarrow{\mathrm{OE}} &=& \overrightarrow{\mathrm{OB}}+\overrightarrow{\mathrm{BE}}&=&\left[
    \begin{array}{c}
        -a + c\cos(\alpha-\delta)\\
        -l + c\sin(\alpha-\delta)
        \end{array}
    \right]
\end{eqnarray*}
$$
where
$$
\begin{eqnarray*}
    \gamma &=& \arccos\left(\frac{b^{2}+d^{2}-e^{2}}{2bd}\right)\\
    \delta &=& \arccos\left(\frac{\mathrm{AB}^{2}+c^{2}-k^{2}}{2 \cdot \mathrm{AB} \cdot c}\right)
\end{eqnarray*}
$$

### Coordinates of the joints $\overrightarrow{\mathrm{F}}$ and $\overrightarrow{\mathrm{G}}$

<p align="center">
    <img src="\doc\fig_FG.png" height="300" alt="fig_FG.png" title="fig_FG.png">
</p>

$$
\begin{eqnarray*}
    \overrightarrow{\mathrm{OF}} &=& \overrightarrow{\mathrm{OE}}+\overrightarrow{\mathrm{EF}}\nonumber\\
    &=&\left[\begin{array}{c}
        -a + c\cos(\alpha-\delta)+g\cos(\varepsilon+\zeta)\\
        -l + c\sin(\alpha-\delta)+g\sin(\varepsilon+\zeta)
        \end{array}
    \right]\\
    \overrightarrow{\mathrm{OG}} &=&\overrightarrow{\mathrm{OE}}+\overrightarrow{\mathrm{EG}}\nonumber\\
    &=&\left[
    \begin{array}{c}
        -a + c\cos(\alpha-\delta)+i\cos(\varepsilon+\zeta+\eta)\\
        -l + c\sin(\alpha-\delta)+i\sin(\varepsilon+\zeta+\eta)
        \end{array}
    \right]
\end{eqnarray*}
$$
where
$$
\begin{eqnarray*}
    \varepsilon &=& \arctan2\left(\mathrm{D}_y-\mathrm{E}_y, \mathrm{D}_x-\mathrm{E}_x\right)\\
    \zeta &=& \arccos\left(\frac{\mathrm{DE}^{2}+g^{2}-f^{2}}{2\cdot \mathrm{DE} \cdot g}\right)\\
    \eta &=& \arccos\left(\frac{g^{2}+i^{2}-h^{2}}{2gi}\right)
\end{eqnarray*}
$$

## Appendix
### Animation of 12 legs (=Strandbeest)
Changing the number of legs, you can increase the number of robot legs.

```
LEG_SET_NUM = 6
```

<p align="center">
    <img src="/doc/jansen_12legs.gif" height="350" alt="jansen_12legs.gif" title="jansen_12legs.gif">
</p>

### Only 6 legs (not display coordinate plane)
Altering the setting of plot area and disappearing coordinate plane, 6-legged robot appears to walk.

```
unset xlabel # or set xlabel "..." tc(=textcolor) rub 'white' 
unset ylabel # or set ylabel "..." tc rub 'white'
unset tics # or set tics tc rub 'white'
unset grid # or set grid lc rub 'white'
unset border # or set border lc rub 'white'
```

<p align="center">
    <img src="/doc/jansen_6legs_noborder.gif" height="350" alt="jansen_6legs_noborder.gif" title="jansen_6legs_noborder.gif">
</p>

### Color setting for each leg
If you make gradual color change, you use the following code.
```
WHITEN_VAL = int(180./LEG_SET_NUM) # If numerator is not 180 but 255, the last pair of legs turns too white.
color = 0x000000 + (WHITEN_VAL*k << 16)+(WHITEN_VAL*k << 8)+(WHITEN_VAL*k << 0) # If base color is black
color = 0xff0000 + (WHITEN_VAL*k << 8)+(WHITEN_VAL*k << 0) # If base color is red
```

On the other hand, if you specify the color used for each leg, you use the following code.
(k=0 : Red, k=1 : Green, k=2 : Blue)
```
color = (k==0 ? 0xff0000 : (k==1 ? 0x00ff00 : 0x0000ff))
```

### Transparency in png terminal
When transparency is used in png terminal, the "truecolor" option must be selected [3]. Then you use transparent color if you represent color by 32 bits AARRGGBB [4]. So, I modified the code as follows.

```
set term png truecolor enhanced size 960, 720 # truecolor is important!
CIRC_R = 4 # Largen radius
color = (j==0 ? 0x80ff3434 : (j==1 ? 0x80759dff : 0x8056bf56)) # 0x80RRGGBB = 50% transparency, rgb RRGGBB
plot_command = plot_command.sprintf(", outputfile u %d:%d every ::%d::%d w l lw LW*0.7 lc rgb 'gray30'", 16+2*k, 17+2*k, start, end) # Change color
```
Thanks to truecolor, all of the circles representing joint $\mathrm{A}$ are transparent as shown in the below figure. However, arrows drawn without a head are not transparent. So, if you want to draw transparent not only circles but also lines, I suggest you to set the **qt terminal**. Please note that you can't save image by using command 'set output' in qt terminal.


| <img src="/doc/terminal_png.png" height="200" alt="terminal_png.png" title="terminal_png.png">| <img src="/doc/terminal_qt.png" height="200" alt="terminal_qt.png" title="terminal_qt.png">|
|:---:|:---:|
|Terminal type : 'png'|Terminal type : 'qt' (in MacOS)|

## Author
* Hiro Shigeyoshi
* Twitter: https://twitter.com/hiroloquy

### YouTube
http://www.youtube.com/watch?v=rSbgDpycorc  
[![Jansen Linkage [gnuplot]](http://img.youtube.com/vi/n-8I00R3i1U/maxresdefault.jpg)](https://www.youtube.com/watch?v=n-8I00R3i1U "Jansen Linkage [gnuplot]")

## License
"jansen-linkage" is under [MIT license](https://github.com/hiroloquy/water-drop-linkage/blob/master/LICENSE).
