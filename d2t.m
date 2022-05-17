function tab = d2t(dic)
    tab = table;
    for raw_key = py.list(keys(dic))
       key = raw_key{1};
       value = dic{key};
       tempTable = table(string(value), 'VariableNames', [string(key)]);
       tab = [tab tempTable];
    end
end