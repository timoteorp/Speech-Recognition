function j=contadata(data);
k = height(data);
j=0;
for i=1:k
    if length(data.Data{i,1})~=16000
        j=j+1;
    end 
end 