classdef CtrlBSC < ParamSM_Linear
    properties (Access = private)
        k1 (1,1) double {mustBeNumeric}
        K2 (2,2) double {mustBeNumeric}

        ctrl_dt (1,1) double {mustBeNumeric} 

        pre_r (:,1) double {mustBeNumeric}

        r2 (:,1) double {mustBeNumeric}
        rd2 (:,1) double {mustBeNumeric}

        f1 (1,2) double {mustBeNumeric}
        f2 (2,1) double {mustBeNumeric}
        g (2,2) double {mustBeNumeric}

    end

    methods
        function obj = CtrlBSC(k1, k2, r, ctrl_dt)
            obj = obj@ParamSM_Linear();
            obj.k1 = k1;
            obj.K2 = k2 * eye(2);
            obj.pre_r = r;
            obj.ctrl_dt = ctrl_dt;
        end

        function disp(obj)
            fprintf('*** BSC Controller Parameters ***\n')
            fprintf('k1: %.2f\n', obj.k1)
            fprintf('K2: [%.2f, %.2f; %.2f, %.2f]\n', obj.K2(1,1), obj.K2(1,2), obj.K2(2,1), obj.K2(2,2))
            fprintf('Control dt: %.2f\n', obj.ctrl_dt)
        end

        %% SYSTEM METHODS
        function psi = getPsi(obj, y)
            psi = getPsi@ParamSM_Linear(obj, y(2:3));
        end

        function inv_L = getInvL(obj)
            inv_L = getInvL@ParamSM_Linear(obj);
        end

        function obj = getSys(obj, y)
            psi = obj.getPsi(y);
            inv_L = obj.getInvL();

            obj.f1 = (2*obj.np)/(3*obj.kappa^2*obj.Theta)*psi'*obj.J';
            obj.f2 = inv_L * (-obj.R * y(2:3) - y(1)/obj.np*obj.J*psi);
            obj.g = inv_L;
        end

        %% CONTROL METHODS
        function obj = preControl(obj, y, r)
            e = y(1) - r;

            obj = obj.getSys(y);
            rd1 = (r-obj.pre_r) / obj.ctrl_dt;
            d = 0;
            
            obj.r2 = (1/(obj.f1*obj.f1'))*obj.f1'*(-obj.k1*e - d + rd1);
            % obj.r2 = obj.f1'*(-obj.k1*e - d + rd1);
            obj.rd2 = [0;0]; % not implemented
        end

        function obj = postControl(obj, r)
            obj.pre_r = r;
        end

        function [obj, u] = getControl(obj, y, r)
            obj = obj.preControl(y, r);
            e = y - [r; obj.r2];

            u = obj.L * ( ...
                -obj.K2 * e(2:3) - obj.f2 - e(1)*obj.f1' + obj.rd2 ... 
            );
            
            assert(~isnan(norm(u)), 'Control signal is NaN')

            obj = obj.postControl(r);
        end

    end
end