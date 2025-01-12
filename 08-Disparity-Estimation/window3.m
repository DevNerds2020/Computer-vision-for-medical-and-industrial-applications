function Wind = window3(I,x,y)
%WINDOW Summary of this function goes here

    Wind = zeros(3);
    
    if x - 1  < 1 || x + 1 > size(I,2) || y - 1  < 1 || y + 1 > size(I,1)
        return
    else

        Wind(1,1) = I(y-1,x-1);
        Wind(1,2) = I(y-1,x);
        Wind(1,3) = I(y-1,x+1);
        Wind(2,1) = I(y,x-1);
        Wind(2,2) = I(y,x);
        Wind(2,3) = I(y,x+1);
        Wind(3,1) = I(y+1,x-1);
        Wind(3,2) = I(y+1,x);
        Wind(3,3) = I(y+1,x+1);
    
    end
end

