function [a] = conta(A)
l = numel(A(:,1));
n = numel(A(1,:));
a = 0;
for i=1:l
    for j=1:n
        if A(i,j) == 1
            a = a+1;
        end 
    end 
end 
end 