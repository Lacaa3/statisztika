data = readtable("E0.csv"','VariableNamingRule','preserve');

%Tisztítás(Csak a használt oszlopok maradjanak meg(alap esetben:132
%oszlop))
stats = data(:,{'FTHG', 'FTAG', 'HS', 'AS', 'HST', 'AST', 'Referee'});

% Átlag, szórás, terjedelem számítása a fontosabb mutatókra
Mutatok = {'HomeGoals'; 'AwayGoals'; 'HomeShots'; 'AwayShots'};
Atlagok = [mean(data.FTHG); mean(data.FTAG); mean(data.HS); mean(data.AS)];
Szorasok = [std(data.FTHG); std(data.FTAG); std(data.HS); std(data.AS)];
Osszegzes = table(Mutatok, Atlagok, Szorasok);
disp('Alapvető statisztikai mutatók:');
disp(Osszegzes);

data.Referee = categorical(data.Referee);

% boxplot([data.FTHG, data.FTAG], 'Labels', {'Hazai gólok', 'Vendég gólok'});
% title('Gólok eloszlásának összehasonlítása');

% Gólok eloszlása
histogram(data.FTHG, 'Normalization', 'pdf');
title('Hazai gólok eloszlásának sűrűségfüggvénye');

d = data.FTHG - data.FTAG; % Különbségek
n = length(d);
atlag_d = mean(d);
s_d = std(d);

% t-statisztika kézzel
t_ertek = atlag_d / (s_d / sqrt(n));

% Kritikus érték meghatározása (alfa = 0.05 mellett)
t_kritikus = tinv(0.95, n-1);

fprintf('Számított t: %.4f, Kritikus t: %.4f\n', t_ertek, t_kritikus);
if t_ertek > t_kritikus
    disp('H0-t elvetjük: Van szignifikáns hazai pálya előny.');
else
    disp('H0-t elfogadjuk: Nincs szignifikáns különbség.');
end