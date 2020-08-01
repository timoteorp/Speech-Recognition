function [X] = table_to_array(teste)
X = zeros(40,98,3,length(teste));
for i=1:(length(teste))
    X(:,:,:,i) = teste{i};
end 
end 