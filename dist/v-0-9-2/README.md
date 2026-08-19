# Constrained Optimization-Based Neuro-Adaptive Control (CONAC)

- Paper Name: Constrained Optimization-Based Neuro-Adaptive Control (CONAC) for Unknown Systems Under Multiple Convex Input Constraints
- State: Draft
- Template Version: TBD

> [!Note]
> This paper will be submitted to [IEEE Transactions on Systems, Man, and Cybernetics: Systems](https://ieeexplore.ieee.org/xpl/RecentIssue.jsp?punumber=6221021).

You can find papers here:

- First submission: 
<!-- - Final submission: [still working](./manuscript.pdf) -->

## Research Abstract

This study presents a constrained optimization-based neuro-adaptive control (CONAC) for a class of unknown multi-input-multi-output (MIMO) systems subject to multiple convex input constraints. 
A deep neural network (DNN) is employed to approximate the ideal control law while handling multiple convex input constraints within a unified constrained optimization framework.
The adaptive variables, including the DNN weights and Lagrange multipliers are updated through adaptation laws derived from the formulated constrained optimization problem, yielding Karush-Kuhn-Tucker (KKT)-like first-order optimality conditions at equilibrium.
The controller's stability is rigorously analyzed using Lyapunov theory, establishing the uniform ultimate boundedness (UUB) of the tracking errors and adaptive variables.
The proposed controller is compared with existing methods through real-time experiments on a 2-degree-of-freedom (DOF) robotic manipulator, highlighting its superior capability to handle input saturation and its feasibility in real-time implementation.

## Authors

- [Myeongseok Ryu](https://github.com/DDingR)
- Donghwa Hong
- Kyunghwan Choi
