# 1.Вибрати усіх клієнтів, чиє ім`я має менше ніж 6 символів.

select * from client where length(FirstName) <6;

# 2.Вибрати львівські відділення банку.

select * from department where DepartmentCity = 'Lviv';

# 3.Вибрати клієнтів з вищою освітою та посортувати по прізвищу.

select * from client where Education = 'high' order by LastName;

# 4.Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.

select * from application order by idApplication desc limit 5;

# 5.Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.

select * from client where LastName like '%ov' or LastName like '%ova';

# 6.Вивести клієнтів банку, які обслуговуються київськими відділеннями.

select * from client join department d on client.Department_idDepartment = d.idDepartment where DepartmentCity = 'Kyiv';

# 7.Знайти унікальні імена клієнтів.

select distinct FirstName from client;

# 8.Вивести дані про клієнтів, які мають кредит більше ніж на 5000 гривень.

select * from client join application a on client.idClient = a.Client_idClient where sum > 5000;

# 9.Порахувати кількість клієнтів усіх відділень та лише львівських відділень.

select(select count(*) from client
            join department d on d.idDepartment = client.Department_idDepartment
                       where DepartmentCity ='Lviv') as lviv_client,
      (select count(*) from client
            join department d on client.Department_idDepartment = d.idDepartment) as client_count;

# 10.Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.

select max(Sum) as max_credit, client.* from client
    join application a on client.idClient = a.Client_idClient group by idClient;

# 11. Визначити кількість заявок на крдеит для кожного клієнта.

select count(Client_idClient) as count, client.* from client
    join application a on client.idClient = a.Client_idClient group by idClient;

# 12. Визначити найбільший та найменший кредити.

select max(sum) as maxCredit, min(Sum) as minCredit from application;

# 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.

select count(*) as count, idClient,FirstName,LastName,Education from client
    join application a on client.idClient = a.Client_idClient where Education='high' group by idClient;

# 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.

select avg(SUM) as count, client.* from client
    join application a on client.idClient = a.Client_idClient group by idClient order by count desc limit 1;

# 15. Вивести відділення, яке видало в кредити найбільше грошей

select sum(SUM) as sum, department.* from department
    join client c on department.idDepartment = c.Department_idDepartment
    join application a on c.idClient = a.Client_idClient
group by idDepartment order by sum desc limit 1;

# 16. Вивести відділення, яке видало найбільший кредит.

select max(Sum) as max_sum, department.* from department
    join client c on department.idDepartment = c.Department_idDepartment
    join application a on c.idClient = a.Client_idClient
group by idDepartment order by max_sum desc limit 1;

# 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.

update client join application a on client.idClient = a.Client_idClient set Sum=6000 where Education='high';
select Education, Sum from client join application a on client.idClient = a.Client_idClient;

# 18. Усіх клієнтів київських відділень пересилити до Києва.

update client join department d on client.Department_idDepartment = d.idDepartment set City='Kyiv' where DepartmentCity='Kyiv';
select City, DepartmentCity from client join department d on client.Department_idDepartment = d.idDepartment;

# 19. Видалити усі кредити, які є повернені.

delete application from application where CreditState='Returned';
select * from application;

# 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.

delete application from application
    join client c on application.Client_idClient = c.idClient where LastName  regexp '^.[eyuoa].*';
select * from application join client c on application.Client_idClient = c.idClient;

# 21.Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000

select sum(Sum) as sum, department.* from department
    join client c on department.idDepartment = c.Department_idDepartment
    join application a on c.idClient = a.Client_idClient
where DepartmentCity ='lviv' group by idDepartment having sum(sum)>5000;

# 22.Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000

select client.* from client join application a on client.idClient = a.Client_idClient where CreditState ='Returned' and sum >5000;

# 23.Знайти максимальний неповернений кредит.

select max(Sum) as sum from application  where CreditState ='Not returned';

# 24.Знайти клієнта, сума кредиту якого найменша

select client.*, Sum from client join application a on client.idClient = a.Client_idClient order by Sum  limit 1;

# 25.Знайти кредити, сума яких більша за середнє значення усіх кредитів

select * from application where (select avg(Sum) as avg from application)< Sum;

# 26. Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів

select * from client where City = (select client.city from client
    join application a on client.idClient = a.Client_idClient
        group by idClient order by count(*) desc limit 1);

# 27. Місто клієнта з найбільшою кількістю кредитів

select city from client
    join application a on client.idClient = a.Client_idClient
            group by idClient order by count(*) desc limit 1;