function df = t2df(tab)

    types = varfun(@class, tab, 'OutputFormat','cell');
    names = tab.Properties.VariableNames;
    
    df = py.pandas.DataFrame();
    for k = 1:size(types,2)
        if(iscell(tab(:,k).Variables))
            column = cell2table(tab(:,k).Variables);
            column = column(:,1).Variables;
        else
            column = tab(:,k).Variables;
        end
        % Tables are allowed to have a few columns with the same name.
        % Hence, iterate over subcolumns and split them into different
        % columns so Dataframe can be created
        for l = 1:size(column, 2) 
            if matches(types{k}, 'cell')
                if(size(column(:,l), 1) ~= 1)
                    pandasColumn = py.pandas.DataFrame(column(:,l).cellstr', columns = {names{k}}, dtype="string");
                else
                    pandasColumn = py.pandas.DataFrame(column(:,l).cellstr, columns = {names{k}}, dtype="string");
                end
            elseif matches(types{k}, 'logical')
                    pandasColumn = py.pandas.DataFrame(arrayfun(@(x) py.bool(x), column(:,l), 'UniformOutput', false)', columns = {names{k}}, dtype="bool");
            elseif contains(types{k}, 'int')
                pandasColumn = py.pandas.DataFrame(arrayfun(@(x) py.int(x), column(:,l), 'UniformOutput', false)', columns = {names{k}}, dtype=types{k});
            elseif matches(types{k}, 'char') || matches(types{k}, 'string')
                pandasColumn = py.pandas.DataFrame(arrayfun(@(x) py.str(x), column(:,l), 'UniformOutput', false)', columns = {names{k}}, dtype="string");
            elseif matches(types{k}, 'double') || matches(types{k}, 'float')
                  pandasColumn = py.pandas.DataFrame(arrayfun(@(x) py.float(x), column(:,l), 'UniformOutput', false)', columns = {names{k}}, dtype="float");
                
            else
                error("unknown type: " + string(types{k}));
            end
            df = py.pandas.concat({df, pandasColumn}, axis = 1);
        end
    end  
end
