# HLSL Glitch Shader

The following is a HLSL glith shader, intended for use in unity.

It was created by taking several random sine functions, adding them together and adding these values to the x coordinates of an object's vertices. Then the values given out were rounded to some given value to reduce the effect of massive peaks from the sine functions. This value was then determined by its own sine function so that it would fluctuate in an apparently random way. Finally, chromatic aberration was applied to cause an even further glitch effect. A textures RGB values were split into separate streams where their uv coordinates are offset by another sine function based on the game time to give a random appearance. The sine function values used, values for chromatic aberration and so on were changed depending on the object using the shader to give the desired effect.

The vertex shader performs the manipulation of the vertices in this shader. This is where everything besides the chromatic aberration happens. Along with this all of the manipulation occurs on the view matrix before conversion to the projection matrix. After this, within the fragment shader the chromatic aberration is performed.

<p align="center">
  <img src="README-Images/fig1.gif" width="600">
</p>
<div align="center">
  Figure 1: Glitch shader used on a roadblock
  <p></p>
</div>

<p align="center">
  <img src="README-Images/fig2.gif" width="600">
</p>
<div align="center">
  Figure 2: Glitch shader on a building
  <p></p>
</div>

<p align="center">
  <img src="README-Images/fig3.gif" width="600">
</p>
<div align="center">
  Figure 3: Glitch shader in game
  <p></p>
</div>
