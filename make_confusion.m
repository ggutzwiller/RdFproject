function confusion = make_confusion( results )
%make_confusion Make confusion matrix from results
%   From the resuts in one row create the confusion matrix

lo = sqrt(size(results,2));

confusion = zeros(lo,lo);

for i=1:lo
    for j=1:lo
        confusion(i,(results((i-1)*lo+j))+1) = confusion(i,(results((i-1)*lo+j))+1) + 1;
    end
end

confusion = confusion / lo;


end

