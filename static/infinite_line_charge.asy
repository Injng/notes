settings.outformat = "png";
settings.render = 20;
unitsize(0.75cm);
defaultpen(fontsize(10pt));

// points
pair A = (-4, 0);
pair B = (0, 0);
pair C = (4, 0);
pair D = (0, 4);
pair E = (0, 2);
pair F = (3, 0);

// vector from F to E
pair direction = E - F;
pair G = F + direction * 1.2;

// draw the lines
draw(A -- C);
draw(B -- D, dashed);
dot(E);
dot(F);
draw(F -- G, arrow=Arrow(TeXHead));

// labels
label("$a$", midpoint(B -- E), align=W);
label("$x$", midpoint(B -- F), align=S);
label("d$x$", F, align=S);
label("d$\vec{E}$", G, align=N);

// shipout
shipout(scale(0.2)*currentpicture.fit());
