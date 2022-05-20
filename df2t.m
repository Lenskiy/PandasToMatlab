function tab = df2t(df)
    tab = table;
    records = cell(df.values.tolist);


    if(py.isinstance(df, py.type(py.pandas.DataFrame)))
        for k = 1:length(records)
            row = recordDecoding(records{k});
            tab = [tab; row];
        end

        headerCells = df.columns.to_list;
        for k = 1:length(headerCells)
            header(k) = headerCells(k).string;
        end
        

        % Check if there are columns with the same name
        if(length(unique(header)) == length(header))
            tab.Properties.VariableNames = header;
        else
            for name = unique(header)
                sameNameCol = find(name == header);
                if(length(sameNameCol) == 1)
                    continue;
                end
                tab = [tab(:,1:sameNameCol(1)-1), table(tab(:, sameNameCol).Variables, 'VariableName', name), tab(:,sameNameCol(1):end)];
                tab(:, sameNameCol+1) = [];
                header(sameNameCol(2:end)) = [];
            end
            tab.Properties.VariableNames = header;
        end

    elseif(py.isinstance(df, py.type(py.pandas.Series)))
        for l = 1:length(records)
            [value, valType] = fieldDecoding(records{l});
            row = table(value, 'VariableNames', string(df.name.char));
            tab = [tab; row];
        end
        tab.Properties.RowNames = string(df.index.values.tolist);
    end
end

function row = recordDecoding(record)
    fields = cell(record);
    row = table;  
    for l = 1:length(fields)
        [value, valType] = fieldDecoding(fields{l});
        tableCell = table(value, 'VariableNames', ["Var" + l]);
        row = [row, tableCell];
    end
end

function [value, type] = fieldDecoding(field)
    if(py.isinstance(field, py.type(py.bool)))
        value = logical(field);
        type = 'logical';
    elseif(py.isinstance(field, py.type(py.int)))
        value = field.int64;
        type = 'int64';
    elseif(py.isinstance(field, py.type(py.str)))
        value = string(field);
        type = 'string';
    elseif(py.isinstance(field, py.type(py.float)))
        value = double(field);
        type = 'double';
    elseif(py.isinstance(field, py.type(py.complex)))
        value = complex(field);
        type = 'complex';
    elseif(py.isinstance(field, py.type(py.list)))
        value = cell(field);
        type = 'cell';
    else
        value = field;
    end
end