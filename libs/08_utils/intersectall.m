function intersection = intersectall(A,B)

	if (length(A)>1 && length(A)>1)
		intersection = intersect(A,B);
	elseif length(A)==1 && length(B)>1
		intersection = B(B==A);
	elseif length(A)>1 && length(B)==1
		intersection = A(A==B);
    elseif length(A)==1 && length(B)==1
        intersection = A(A==B);
    elseif isempty(A) || isempty(B)
        intersection = [];
    else
		disp('Unknow condition found!');
        disp([num2str(length(A)) ' ' num2str(length(B))]);
        intersection = [];
end
