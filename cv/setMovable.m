function [Objects, retVal] = setMovable(Objects, shape, height, color)

% retVal is 1 if object combination exists, 0 otherwise.
retVal = 0; 

for i = 1:length(Objects)
    
    if (strcmp(Objects(i).Name, color))
        
        for j = 1:length(Objects(i).Shape)
            
            if (strcmp(Objects(i).Shape(j).Type, shape) && (Objects(i).Shape(j).Height == height))
                Objects(i).Shape(j).Movable = 1;
                retVal = 1;
            end
        end
    end
end 

end

