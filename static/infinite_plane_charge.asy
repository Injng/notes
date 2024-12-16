import fontsize;
import three;

settings.outformat = "png";
settings.render = 8;
settings.prc = false;
size(1cm, 0);
defaultpen(fontsize(3pt) + linewidth(0.2));

// points
triple CIRCLE_CENTER = (0, 0, 0);
triple NORMAL_HEAD = (0, 0, 2);
triple CIRCLE_START = (1, 0, 0);
triple VECTOR = NORMAL_HEAD - CIRCLE_START;
triple VECTOR_HEAD = CIRCLE_START + 1.5 * VECTOR;

draw(circle(CIRCLE_CENTER, 1, normal=Z));
draw(CIRCLE_CENTER -- NORMAL_HEAD, dashed);
draw(CIRCLE_START -- VECTOR_HEAD, arrow=Arrow3(TeXHead3));
dot(NORMAL_HEAD);
draw(CIRCLE_CENTER -- CIRCLE_START);

// labels
label("$a$", midpoint(CIRCLE_CENTER -- NORMAL_HEAD), align=E);
label("$r$", midpoint(CIRCLE_CENTER -- CIRCLE_START), align=S);
label("$\theta$", (0.14, 0, 1.55), align=S);