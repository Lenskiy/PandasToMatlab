function df = t2df(tab) % currently a trivial implementation
    tmpName = [tempname, '.csv'];
    writetable(tab, tmpName);
    df = py.pandas.read_csv(tmpName);
end