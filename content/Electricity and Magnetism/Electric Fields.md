## Introduction to Electrostatics
To begin our discussion of electric fields, we should first consider the study of **electrostatics**.

Electrostatics is the study of charges that are not moving (the opposite of that is *electrodynamics*, but we'll get to that later).

One law upholds the entirety of electrostatics, and that law is known as Coulomb's Law.
### Charges
Charges are the gateway to electricity and magnetism. To be able to play this game, you must have charge. In a way, charge can be seen as a physical property.

Negative charge is carried by electrons. Interestingly, this is the most basic unit of charge: this negative charge carried by electrons exactly equals the positive charge carried by protons. Neutrons do not carry charge — they are neutral. This also means that charge is *quantized*, as only basic units of charge can be added up.

This quantized charge is the charge in an electron, which is $-e=1.602\times 10^{-19} \text{ C}$.

Charge is also conserved locally.  Charge cannot be universally conserved, as this would violate special relativity.
### Coulomb's Law
Now onto this great law known as Coulomb's Law. It basically states that the force experienced by a charged particle due to another charged particle is directly proportional to their charges and inversely proportional to their squared distance:

$$
F_C=\frac{1}{4\pi\epsilon_0}\frac{q_1q_2}{r^2}\hat{r}
$$
Notice its similarities with the Universal Law of Gravitation.
## Electric Fields
Electric fields are basically just a generalization of Coulomb's Law. We remove the actual physical charge from the law, and consider only a "test charge" — theorizing "what would happen" if a charge was actually there.

You can also think of it as putting a charge of 1 there to just test the "electric field". Thus, the electric field given by a charge $q$  is just:

$$
E = \frac{1}{4\pi\epsilon_0} \frac{q}{r^2} \hat{r}
$$
Notice that the second charge is nowhere to be seen. This is because we can now rewrite Coulomb's Law as:
$$
F_C = qE
$$
Very convenient!
### Electric Field Lines
Now, some genius thought of a method to visualize electric fields by drawing lines to represent the force vectors.

This is particularly ingenious because the density of the lines directly correlate to the relative intensity of the force. If we draw a sphere around the charge, the surface area of that sphere is $4\pi r^2$. If we have $n$ number of lines going through an area of $4\pi r^2$, notice that as $r$ increases the density falls off by $\frac{1}{r^2}$, consistent with Coulomb's Law. 
### Electric Field Due to an Infinite Line of Charge
Now we will attempt to calculate the electric field due to an infinite wire containing charge of density $\lambda$ Coulombs per meter:

![[Pasted image 20241204204127.png]]

We shall take a tiny length of the wire, $dx$, and consider the small difference of electric field $d\vec{E}$ that it imparts on a charge above it. 

Firstly, note that all the horizontal components will cancel due to symmetry. Another symmetry argument for this could be that for any argument you give me that it should tilt to the left, that same argument can be applied to say that it should tilt to the right — because on an infinite line of charge, the side to the left and the side to the right of the charge look exactly identical.

Thus, we need only to calculate the vertical component of this electric field. To do so, we can simply take the cosine of the angle it makes with the vertical and multiply.

Therefore, we have:
$$
dE = \frac{1}{4\pi \epsilon_0} \cdot \frac{\lambda dx}{a^2+x^2} \cdot \frac{a}{\sqrt{a^2+x^2}}
$$
To find the total electric field, we can integrate this:
$$
E=\frac{\lambda a}{4\pi \epsilon_0}\int_{-\infty}^{\infty}{\frac{1}{(a^2+x^2)^\frac{3}{2}}dx}
$$
We can now proceed by trig substitution. We substitute $x=a\tan{\theta}$,
$$
E=\frac{\lambda a}{4\pi \epsilon_0} \int_{-\frac{\pi}{2}}^{\frac{\pi}{2}}{\frac{a\sec^2{\theta}d\theta}{a^3\sec^3{\theta}}}
$$
Simplifying,
$$
E=\frac{\lambda}{4\pi \epsilon_0 a} \int_{-\frac{\pi}{2}}^{\frac{\pi}{2}}\frac{1}{\sec{\theta}}d\theta
$$
Finally, we evaluate the integral from $-\frac{\pi}{2}$ to $\frac{\pi}{2}$,
$$
E=\frac{\lambda}{4\pi \epsilon_0 a} (1+1) = \frac{\lambda}{2\pi \epsilon_0 a}
$$
And there we go.

There is something interesting about this. How does this field get weaker as distance, $a$, increases? It falls over like $\frac{1}{a}$, not like $\frac{1}{a^2}$ as we would expect. This is because we are considering an infinite line of charge, so all of the forces that a charge would experience adds up to a field that falls like $\frac{1}{a}$.
