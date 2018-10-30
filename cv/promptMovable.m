function [Objects] = promptMovable(Objects)

prompting = 1;
firstTimeAround = 1;
while (prompting)
    if (firstTimeAround) % Changes input slightly
        x = input('Are there objects which can move? [y/n]\n>>>', 's');
    else
        x = input('Are there more objects which can move? [y/n] default = [n]\n>>>', 's');
    end
    
    % if there was no input or n
    if (strcmp(x, 'n'))
        prompting = 0;
        
    elseif (strcmp(x, 'y'))
        realShape = 0; realHeight = 0; realColor = 0;
        % Read the shape from input
        while (~realShape)
            shape = input('Which shape? choose from: [circle, triangle, square]\n>>>', 's');
            if (strcmp(shape, 'circle') || strcmp(shape, 'triangle') || strcmp(shape, 'square'))
                realShape = 1;
            else
                fprintf(" -> This is an invalid shape, please choose from the list\n");
            end
        end
        
        % Read the s
        while (~realHeight)
            height = input('Object height: [35, 70]\n>>>');
            if (height == 35 || height == 70)
                realHeight = 1;
            else
                fprintf(" -> This is an invalid height, please choose from the list\n");
            end
        end
        while (~realColor)
            color = input('Object color: [red, green, blue, yellow]\n>>>', 's');
            if (strcmp(color, 'red') || strcmp(color, 'green') || strcmp(color, 'blue') || strcmp(color, 'yellow'))
                realColor = 1;
            else
                fprintf(" -> This is an invalid color, please choose from the list\n");
            end
        end
        
        % Now able to set the 'Movable parameter to 1 for the object of
        % color, shape and height.
        [Objects, retVal] = setMovable(Objects, shape, height, color);
        str = sprintf('Object: [%s %2.0fmm %s]', color, height, shape);
        firstTimeAround = 0;
        
        if (retVal == 1)
            fprintf([str, ' was set movable\n\n']);
        else
            fprintf([str, ' wasnt found\n\n']);
        end
        
    end
    
end

end