function result = accuracyPercent(obs, cbe, sme)
	% expected 698x398x25 on all args
	% testing: 698x398 (single hours) on all args
	disp('Starting accuracy algorithm')
	result = zeros(size(obs));
	for idx = 1:698
		for jdx = 1:398
			oP = obs(idx, jdx);
			cP = cbe(idx, jdx);
			sP = sme(idx, jdx);
            
			%if not(oP == 0)
			%	if cP > oP
			%		cP = 2 * oP - cP;
			%	end
			%	if sP > oP
			%		sP = 2 * oP - sP;
			%	end
			%	result(idx, jdx) = (cP - sP) / oP;
			%end
            
            % CBE bias calc
            biasCBE = abs(oP - cP);
            % SME bias calc
            biasSME = abs(oP - sP);
            % NOTE: it gives me a positive value if a CBE is a better prediction
            % than SME
            result(idx,jdx) = biasSME - biasCBE;
		end
	end

	disp('Accuracy algorithm finished')
end
