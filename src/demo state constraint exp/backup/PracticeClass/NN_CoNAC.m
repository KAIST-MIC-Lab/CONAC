classdef NN_CoNAC < NN & ParamSM_Lookup
    properties
        A
        B

        Lambda      % Lagrange multiplier
        beta        % update rate of multipliers

        V_max
        u_ball

        u_prev = [0;0];

        eta 
    end

    methods
        function obj = NN_CoNAC(dt)
            NN_size = [3, 16, 16,2];   
    
            alpha = 10e+3;
            rho = alpha*1e-2;

            obj = obj@NN(NN_size, alpha, rho, dt);

            obj.eta = zeros(3, obj.v_size);

            obj.V_max = [1; 1; 1] * 1e0;
            obj.u_ball = 1;

            % for each later + u_ball
            obj.Lambda = zeros(size(obj.V_max,1) + 1, 1); 
            obj.beta = [5,5,5,5] * 1e2;
        end

        function disp(obj)
            disp@NN(obj);
        end

        %% GET METHODS
        function info = getInfo(obj)
            info = getInfo@NN(obj);
        end

        %% SYSTEM METHODS
        function psi = getPsi(obj, y)
            psi = getPsi@ParamSM_Lookup(obj, y(2:3));
            psi = psi + ones(size(psi)) * 1e-3;
        end

        function L = getL(obj, y)
            L = getL@ParamSM_Lookup(obj, y(2:3));
            L = L + ones(size(L)) * 1e-3;
        end
        
        function obj = getSys(obj, y)
            psi = obj.getPsi(y);
            L = obj.getL(y);

            inv_L = matInv22(L);

            obj.f1 = (2*obj.np)/(3*obj.kappa^2*obj.Theta)*psi'*obj.J';
            obj.f2 = inv_L * (-obj.R * y(2:3) - y(1)/obj.np*obj.J*psi);
            obj.g = inv_L;
        end

        %%
        function obj = stepEta(obj, nnGrad)
            % obj.A = [-obj.k1 obj.f1; -obj.f1' -obj.K2];
            % obj.B = [0 0; obj.g];
            obj.A = diag([-30,-30,-30]);
            obj.B = [0 0; eye(2)];

            eta_grad = (obj.A*obj.eta + obj.B*-nnGrad);
            obj.eta = obj.eta + eta_grad * obj.dt;
        end

        %% CONSTRAINT METHODS
        function [c, cd] = cstr(obj, nnGrad)
            c = zeros(length(obj.Lambda), 1);
            cd = zeros(length(obj.Lambda), obj.v_size);

            % weight norm constraint
            cumsum_V = [0;cumsum(obj.v_size_list)];
            for l_idx = 1:1:obj.l_size-1
                start_pt = cumsum_V(l_idx)+1;
                end_pt = cumsum_V(l_idx+1);   
        
                c(l_idx) = norm(obj.V(start_pt: end_pt))^2 ...
                    - obj.V_max(l_idx)^2;
                cd(l_idx, start_pt:end_pt) = 2 * obj.V(start_pt:end_pt,1);
            end
            c_idx = l_idx;

            % control input norm constraint
            c(c_idx+1) = norm(obj.u_prev)^2 - obj.u_ball^2;          
            cd(c_idx+1, :) = 2*obj.u_prev(1)*-nnGrad(1,:) + 2*obj.u_prev(2)*-nnGrad(2,:);
        end

        %% NEURAL NETWORK METHODS
        function [obj, out, info] = forward(obj, in)
            [obj, out, info] = forward@NN(obj, in);
        end

        function [obj, info] = backward(obj, y, e)
            obj = obj.getSys(y);
            nnGrad = obj.getGrad();
            
            obj = obj.stepEta(nnGrad);
            [c, cd] = obj.cstr(nnGrad);

            V_grad = - obj.alpha * (obj.eta'*e + cd' * obj.Lambda);
            L_grad = diag(obj.beta) * c;

            obj.V = obj.V + V_grad * obj.dt;
            obj.Lambda = obj.Lambda + L_grad * obj.dt;
            obj.Lambda = max(obj.Lambda, 0);

            info = NaN;
        end

        %% CONTROL METHODS
        function out = getControl(obj, in)
            [~, out, ~] = obj.forward(in);
        end

        function obj = postControl(obj, y, e, u)
            [obj, ~] = obj.backward(y, e);
            obj.u_prev = u;
        end

        %% ETC
        function grad = getGrad(obj)
            grad = getGrad@NN(obj);
        end

    end
end