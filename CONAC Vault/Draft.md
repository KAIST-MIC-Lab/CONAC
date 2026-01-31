## 1. System Description
We consider the following system 
$$
\ddtt \mv{x} = \mv{f}(\mv{x})+\mv{g}(\mv{x})\mysat(\mv{u})
,
$$
where $\mv{x}\in\mathbb{R}^n$ is the system state, $\mv{u}\in\mathbb{R}^m$ is the control input, and $\mv{f}:\mathbb{R}^n\to\mathbb{R}^n$ is a system function and $\mv{g}:\mathbb{R}^n\to\mathbb{R}^{n\times m}$ is a control effectiveness matrix. The system functions, $\mv{f}$ and $\mv{g}$, are unknown but are assumed to be Lipschitz continuous. Moreover the functions are locally bounded for a set $\mathcal{O}\in\R^n$, *i.e.* $\norm{\mv{f}(\mv{x})}\le \overline{f}$ and $\norm{\mv{g}(\mv{x})}\le \overline{g}$ for all $\mv{x}\in\mathcal{O}$, where $\overline{f},\overline{g}\in\mathbb{R}_{>0}$ are positive constants. In addition, without loss of generality, the control effectiveness matrix $\mv{g}(\mv{x})$ is assumed to be positive definite for all $\mv{x}\in\mathcal{O}$.

We assume that there exists $\beta(\mv{x})\in\R_{>0}$ such that $\tfrac{1}{2}\mv{v}^\top [\ddtt\mv{g(\mv{x})}^{\dagger}]\mv{v}\le \beta(\mv{x})\norm{\mv{v}}^2$ holds for all $\mv{v}\in\R^m$ and $\mv{x}\in\mathcal{O}$, where $\mv{g}(\mv{x})^{\dagger}$ is the Moore-Penrose pseudoinverse of $\mv{g}(\mv{x})$.

The saturation function is continously differentiable and convex on $\mathbb{R}^m$ including the origin. 

The control objective is to design a control law $\mv{u}$ such that the system state $\mv{x}$ tracks a desired trajectory $\mv{x}_d(t)$.

## 2. Neural Network Approximation
The dynamics of a tracking error $\mv{e}:=\mv{x}-\mv{x}_d$ is given by
$$
\ddtt\mv{e} = \mv{f} + \mv{g}\mv{u} - \ddtt\mv{x}_d
,
$$
with the augments of $\mv{f}$ and $\mv{g}$ omitted for brevity. The saturation function is neglected in this step, which will be ensured that the control input $\mv{u}$ remains in the unsaturated region later.

The desired control input $\mv{u}_d$ is designed using Lyapunov function given by $V:=\tfrac{1}{2}\mv{e}\mv{g}^{\dagger}\mv{e}$ whose time derivative is 
$$
\begin{aligned}
\ddtt V = &
\mv{e}^\top \mv{g}^{\dagger}(\mv{f}+\mv{g}\mv{u}-\ddtt\mv{x}_d) + \tfrac{1}{2}\mv{e}\ddtt{\mv{g}^{\dagger}}\mv{e}
\\
\le &
-k\norm{e}^2 
+ \mv{e}^\top\mv{g}^{\dagger}
\left( k\mv{g}\mv{e} + \mv{f}+\mv{g}\mv{u}-\ddtt\mv{x}_d \right)
+
\tfrac{1}{2}\beta(\mv{x})\norm{\mv{e}}^2
\\
= &
- k\norm{e}^2
+ \mv{e}^\top\mv{g}^{\dagger}
\left( k\mv{g}\mv{e}+\beta(\mv{x})\mv{g}\mv{e} + \mv{f}-\ddtt\mv{x}_d + \mv{g}\mv{u} \right)
.
\end{aligned}
$$
The desired control input $\mv{u}_d$ which cancel the terms in the parentheses of second term of the last line, is given by $\mv{u}_d := \mv{g}^{\dagger}(-k\mv{e}-\beta(\mv{x})\mv{e}+\ddtt\mv{x}_d - \mv{f})$, resulting in 
$$
\ddtt V 
\le - k\norm{e}^2+
\mv{e}^\top(\mv{u}-\mv{u}_d)
. 
$$
The desired control input cannot be realized, since the system information, $\mv{f}$ and $\mv{g}$, are unknown.

To approximate the unknown control input, a neural network (NN) $\NN(\mv{x}_n;\wth)$ is employed. The details of the definitions of the NN and the augments are omitted. Then we have
$$
\begin{aligned}
\ddtt V 
\le & - k\norm{e}^2+
\mv{e}^\top(\mv{u}-\mv{u}_d)
\le - k\norm{e}^2+
\mv{e}^\top(\estNN-\idealNN-\mv{\epsilon})
\\
\le& 
- k\norm{e}^2+ \overline{\epsilon}\norm{\mv{e}}
+
\underbrace{
\mv{e}^\top(\estNN-\idealNN)
}_{=:\mv{\delta}(\mv{x},\mv{x}_d,\estwth,\idealwth)}
,
\end{aligned}
$$

^f1ea43

which concludes that the error $\mv{e}$ is ultimately bounded by $\overline{\epsilon}/k$, if $\estwth \to \idealwth$ holds, *i.e.* $\mv{\delta}(\mv{x},\mv{x}_d,\estwth,\idealwth)\to0$. In the following section, we design an adaptation law of the NN weights $\estwth$ to minimize $\mv{\delta}(\mv{x},\mv{x}_d,\estwth,\idealwth)$ which is considered as the objective function.
> [!remark] Validity of the objective function
> Generally, the objective function is designed to be a quadratic function of the NN weights to ensure lower boundedness. However, in this case, the gradient of the objective function, *i.e.*, $\tfrac{1}{2}\mv{\delta}^\top\mv{\delta}$, with respect to the NN weights requires ideal weights $\idealwth$, which are unknown. Alternatively, we focus on $\mv\delta$ appearing in the time derivative of the Lyapunov function. Note that if $\mv\delta$ is negative, it simply reinforces the convergence rate and can be conservatively neglected in the worst-case stability analysis, satisfying $\ddtt V≤−k\norm{\mv{e}}^2+\overline{\epsilon}\norm{\mv{e}}$. Consequently, the primary objective is to minimize the magnitude of $\mv\delta$ when it acts as a destabilizing term (i.e., $\mv\delta$>0). Minimizing this positive component directly decreases the ultimate upper bound of $\norm{\mv{e}}$ to $\overline{\epsilon}/k$, whereas a negative $\mv{\delta}$ can be safely omitted from the analysis without any adverse effect on the stability guarantee.

### 2.1. Adaptation Law of NN Weights
Accordingly to the previous section, using $\mv{\delta}$ as the objective function, we consider the following optimization problem for the NN weights:
$$
\begin{matrix}
\arg\min_{\estwth\in\R^\Xi} \mv{\delta}(\mv{x},\mv{x}_d,\estwth,\idealwth)
\\ \ \\
\text{s.t. }
\begin{cases}
c_i(\estwth_i)=
\tfrac{1}{2}\estwth_i^\top\estwth_i - \overline{\theta}_i^2\le 0, \quad \forall i\in\{0,1,\ldots,k\}, \\
c(\mv{u}) \le 0.
\end{cases}
\end{matrix}
$$
The first constraint is a bounding constraint of the NN weights of each layer, which ensures the weights remain in a compact set whose radius is given by $\overline{\theta}_i\in\R_{>0}$. The second constraint is locally bounded and in $C^1$, which ensures that the control input $\mv{u}$. The constraint shall include the unsaturated region of the saturation function. Moreover, additional constraints motivated from barrier function approaches will be introduced.

The Lagrangian function associated with the optimization problem is given by
$$
L(\estwth,\lambda_i,\lambda)
=
\mv{\delta}+\textstyle\sum_{i=0}^k \lambda_i(1+\lambda) c_i(\estwth_i) + \lambda c(\mv{u})
,
$$
where $\lambda_i\in\R_{\ge0}$ and $\lambda\in\R_{\ge0}$ are the Lagrange multipliers associated with the constraints.
Then, the adaptation law of NN weight is given by
$$
\begin{aligned}
\ddtt\estwth
=&\pptfrac{L}{\estwth} 
= -\alpha 
\left(
\pptfrac{\estNN}{\estwth}^\top\mv{\mv{e}}
+
\textstyle\sum_{i=0}^k\lambda_i(1+\lambda)\estwth + \lambda\pptfrac{\estNN}{\estwth}^\top\pptfrac{c}{\mv{u}}
\right)
,
\\
\ddtt \lambda_i 
=&\beta_i c_i(\estwth_i), \quad \forall i\in\{0,1,\ldots,k\},
\\
\ddtt \lambda
= &\beta c(\mv{u}),
\\
\lambda_i\leftarrow &\max(0,\lambda_i), \quad \lambda\leftarrow \max(0,\lambda)
\end{aligned}
$$
where $\Lambda=\mydiag([\lambda_i]_{i\in\{0,1,\ldots,k\}})$ and the positive constants $\alpha,\beta_i,\beta\in\R_{>0}$ are adaptation gains.

## 3. Stability Analysis
We consider the following Lyapunov candidate function
$$
V
:= 
\tfrac{1}{2}\mv{e}^\top\mv{g}^{\dagger}\mv{e} + \tfrac{1}{2\alpha}\tilde{\wth}^\top\tilde{\wth}
,
$$
which is bounded by $\gamma_1\norm{\mv{z}}^2\le V \le \gamma_2\norm{\mv{z}}^2$ for some positive constants $\gamma_1,\gamma_2\in\R_{>0}$, where $\mv{z}:=(\mv{e}^\top,\tilde{\wth}^\top)^\top$ and $\tilde{\wth}:=\estwth-\idealwth$ is the weight estimation error.
Taking the time derivative of $V$ results in
$$
\begin{aligned}
\ddtt V
\le &
-k \norm{e}^2 + \overline{\epsilon}\norm{\mv{e}}
+\mv{e}^\top
\underbrace{(\estNN-\idealNN)}_{=\pptfrac{\estNN}{\estwth}\tilde{\wth}+\mv{\Delta}}
- \tilde{\wth}^\top \left( \pptfrac{\estNN}{\estwth}^\top\mv{e}
+ \textstyle\sum_{i=0}^k\lambda_i(1+\lambda)\estwth_i + \lambda\pptfrac{\estNN}{\estwth}^\top\pptfrac{c}{\mv{u}}\right)
\\
= &
-k \norm{e}^2 + \overline{\epsilon}\norm{\mv{e}}
+\mv{e}^\top\mv{\Delta}
- \tilde{\wth}^\top \left( \textstyle\sum_{i=0}^k\lambda_i(1+\lambda)(\tilde{\wth}_i-\estwth_i^*) + \lambda\pptfrac{\estNN}{\estwth}^\top\pptfrac{c}{\mv{u}}\right)
\\
\le &
-k \norm{e}^2 + (\overline{\epsilon}+\overline{\Delta})\norm{\mv{e}} 
+
\textstyle\sum_{i=0}^k (-\lambda_i(1+\lambda)\norm{\tilde{\wth}_i}^2 + \lambda_i(1+\lambda)\overline{\theta}_i \norm{\tilde{\wth}_i})
- \tilde{\wth}^\top \lambda\pptfrac{\estNN}{\estwth}^\top\pptfrac{c}{\mv{u}}
,
\end{aligned}
$$
where $\mv{\Delta}$ denotes higher order terms of the Taylor expansion of $\estNN$ around $\idealwth$, and $\overline{\Delta}\in\R_{>0}$ is a positive constant such that $\norm{\mv{\Delta}}\le \overline{\Delta}$ for all $\mv{x}\in\mathcal{O}$ and $\mv{x}_d$ in a compact set. Since $c$ is locally bounded, there exists a positive constant $\overline{\nabla c}\in\R_{>0}$ such that $\norm{\pptfrac{c}{\estwth}}\le \overline{\nabla c}$ for all $\estwth$  in a compact set. Then, we have
$$
\begin{aligned}
\ddtt V 
\le & 
-k\norm{\mv{e}}^2 + 
\underbrace{
(\overline{\epsilon}+\overline{\Delta})
}_{=: C_{\theta}}
\norm{\mv{e}}
-
(1+\lambda) \max(\lambda_0, \cdots, \lambda_k)\norm{\tilde{\wth}}^2
\\
&
\underbrace{
\left(
(1+\lambda)
\max\left(
\left[\lambda_i\overline{\theta}_i\right]_{i\in\{0,1,\ldots,k\}}
\right) 
+
\lambda \overline{\nabla c}
\right)
}_{=: C_\wth}
\norm{\tilde{\wth}}
\\
= &
-k\norm{\mv{e}}^2 + C_{\theta}\norm{\mv{e}} - 
(1+\lambda) \max(\lambda_0, \cdots, \lambda_k)\norm{\tilde{\wth}}^2
+ C_\wth\norm{\tilde{\wth}}
\\
= &

,
\end{aligned}
$$
where $\gamma_3\in\R_{>0}$ is a positive constant and $C\in\R_{\ge0}$ is given by $C:=\max\{\}$.
which concludes that the error $\mv{e}$ and the weight error $\tilde{\wth}$ are bounded in the following compact sets given by
$$
\norm{\mv{e}}
\in
\left\{ 
\mv{e}\mid 
\norm{\mv{e}}\le \tfrac{\overline{\epsilon}+\overline{\Delta}}{2k}
\right\}
,
\quad
\norm{\tilde{\wth}}
\in
\left\{
\tilde{\wth}\mid
\norm{\tilde{\wth}}\le \tfrac{
(1+\lambda)
\max\left(\left[\lambda_i\overline{\theta}_i\right]_{i\in\{0,1,\ldots,k\}}\right)
+ \lambda \overline{\nabla c}
}{
2(1+\lambda)\max(\lambda_0, \cdots, \lambda_k)
}
\right\}
.
$$
However, since Lagrange multipliers $\lambda_i$ and $\lambda$ are time-varying, the ultimate bounds are also time-varying. To handle this, we consider three cases depending on the value of $\lambda$, 1) zero Lagrange multipliers, 2) bounded Lagrange multipliers, and 3) unbounded Lagrange multipliers.
First, if all Lagrange multipliers are zero, *i.e.* $\lambda_i=0$ for all $i\in\{0,1,\ldots,k\}$ and $\lambda=0$, the ultimate bounds are reduced to zero. 


## 4. New trial
$$
\begin{aligend}

\end{aligned}
$$