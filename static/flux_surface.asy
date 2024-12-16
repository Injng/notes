import fontsize;
import three;

settings.outformat = "png";
settings.render = 8;
settings.prc = false;
size(2cm);
defaultpen(fontsize(2pt) + linewidth(0.1));

triple START = (0, 0, 1);

// Vectors for the perpendicular plane
triple A = (1, 0, 0);
triple B = (0, 0, -1);

// Vectors for the tilted plane
triple C = (1, 0, 0);
triple D = (0, 2, -1);

// Draw planes
draw(plane(A, B, START));
draw(plane(C, D, START));

// Define flux lines
triple p1 = (0.2, -1, 0.8);
triple p2 = (0.2, 1.4, 0.8);

triple p3 = (0.4, -1, 0.6);
triple p4 = (0.4, 1.6, 0.6);

triple p5 = (0.6, -1, 0.4);
triple p6 = (0.6, 1.8, 0.4);

// Draw flux lines
draw(p1 -- p2, red, arrow=Arrow3(TeXHead3));
draw(p3 -- p4, red, arrow=Arrow3(TeXHead3));
draw(p5 -- p6, red, arrow=Arrow3(TeXHead3));

label("$\theta$", (1,0.05,0.9), SE);