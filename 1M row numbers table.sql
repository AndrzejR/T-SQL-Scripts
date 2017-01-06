/* Create a 1M row Numbers table */

select n1.n + n2.n*10 + n3.n*100 + n4.n*1000 + n5.n*10000 + n6.n*100000 + 1
into dbo.Numbers (n)
from (values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) n1 (n)
cross join (values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) n2 (n)
cross join (values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) n3 (n)
cross join (values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) n4 (n)
cross join (values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) n5 (n)
cross join (values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) n6 (n);
