## Geometric Interpretation
>[!definition]
>$f'(x_0)$, the **derivative of $f$ at $x_0$**, is the slope of the tangent line to $y=f(x)$ at point $(x_0, f(x_0))$

However, how do we construct a tangent line, say at a certain point $P$? Well, we can define a **secant line** that goes through two points, $P$ and $Q$. Then, we realize that as we move $Q$ closer and closer to $P$ on the graph, the secant line tends towards the tangent line.

![[Pasted image 20250423182745.png|300]]

This image shows us how we can mathematically calculate this value. The slope of the secant line is:
$$
m_\text{secant} = \frac{\Delta f}{\Delta x}
$$
Thus, the slope of the tangent line is simply:
$$
m_\text{tangent} = \lim_{\Delta x \to 0} {\frac{\Delta f}{\Delta x}}
$$
We can also write this purely in terms of our function $f(x)$, which gives us:
>[!Definition]
>$$
>f'(x_0) = \lim_{\Delta x \to 0} {\frac{f(x_0 + \Delta x) - f(x_0)}{\Delta x}}
>$$

## Physical Interpretation
The derivative can also be thought of as a **rate of change**. As an example, consider a position function $y(t)$, where $t$, time is the input, and the function returns a position. In order to obtain speed using algebra, one generally does:
$$
v = \frac{y(t_0 + \Delta t) - y(t_0)}{\Delta t}
$$
Now this works very well if this function is linear. However, using only algebra, realize that we can only find the speed *between two points in time*. With calculus, however, we can find the *instantaneous* speed, when we find the limit as the change in time goes to zero. Realize that this is simply the derivative of $y$.