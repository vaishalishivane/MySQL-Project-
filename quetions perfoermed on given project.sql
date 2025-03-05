#### Library Mangement System ###########
use college ;
#  quetions performed on project 


##CRUD OPERATION FOR BOOK TABLE
#Add a New Book
insert into Books (BookID, Title, Author, CategoryID, Stock) 
values (21, 'The Power of Habit', 'Charles Duhigg', 17, 10);

#View All Books
SELECT * FROM Books;

#Update Book Details
update Books 
set Title = 'The Power of Habit - Revised', Stock = 12 
where BookID = 21;

#Delete a Book
delete from Books where BookID = 21;


##CRUD Operations for the Members Table
#add new member 
insert into  Members (MemberID, Name, Email, MemberType, Phone) 
values  (21, 'Krishna Sharma', 'krishna.sharma@example.com', 'Student', '9876543250');

#View All Members
SELECT * FROM Members;

#Update Member Details
Update Members 
set Name = 'Krishna S. Sharma', Phone = '9876543251' 
where MemberID = 21;

#Delete a Member
delete from  Members where MemberID = 21;


##CRUD Operations for the BorrowingRecords Table
#Add a New Borrowing Record
 
insert into BorrowingRecords (BookID, MemberID, BorrowDate, ReturnDate) 
values (6, 15, '2025-02-25', NULL);


#View All Borrowing Records

#Update Borrowing Record (Return Book)
Update BorrowingRecords SET ReturnDate = NULL WHERE RecordID = 13; -- Use the correct RecordID

#Delete a Borrowing Record
Delete from  BorrowingRecords where RecordID = 16;





# inner join 
select title,author ,stock,borrowdate,name ,email  
from books inner join borrowingrecords on books.bookid= borrowingrecords.RecordID
 inner join members on
 books.BookID=members.MemberID;




#view
#Create a view named BorrowingDetailsView that joins the Books, Members, and BorrowingRecords tables.The view should show the book title, member name, borrow date, and return date for each borrowing record.

create view v1 as
select title ,name, borrowdate,returndate from books inner join members on books.bookid =members.memberid inner join BorrowingRecords on books.bookid=BorrowingRecords.recordid;
select * from  v1;




#store procedure 
# new book to the library,which accepts the book title, author, category, and stock as parameters.

delimiter $$ 
create procedure insert_ne_data( in id int  ,in ti varchar(255) ,in a varchar(255),in cd int ,in st  int) 
begin
insert into books (bookid ,title ,author ,categoryid ,stock) values (id,ti,a,cd,st);
 
end $$ 
delimiter ;
call insert_ne_data (21 ,"the god of small things ", "arundhati roy",17,10);
call insert_ne_data (22 ,"a suitable boy  ", "vikram seth ",21,100);
call insert_ne_data (23 ,"the end of imagination", "arundhati roy",17,50);

 
 insert into categories values ( 21,"novel");
 select * from categories;
 select author , Title,count(title) from books group by author ,title ;
 
 # Write a stored procedure to update a member's phone number based on the MemberID and the new phone number.
  
 delimiter  $$
 create procedure update_phone (in id  int ,phone bigint )
 begin
 update members set phone=phone  where id=id;
 end $$ 
 delimiter ;
 set sql_safe_updates=0;
 call  update_phone(5,9890459945);


#transation 
 
#Write an SQL transaction that borrows a book: decrement the stock in the Books table, add a new record in the BorrowingRecords table, and ensure the transaction is atomic (i.e., rollback if any part of the operation fails).

start transaction;
update books set stock =stock-1  where bookid=5;
insert into  borrowingrecords (bookid,memberid,borrowdate,returndate) values (5,5,curdate(),"2025-03-15");
rollback;
commit;

start transaction;
update books set stock=stock-1 where bookid=1;
insert into  borrowingrecords (bookid,memberid,borrowdate,returndate) values (1,1,now(),"2025-03-15");
savepoint t1;

rollback to t1;
update books set stock=stock+1 where bookid=1;
insert into  borrowingrecords (bookid,memberid,borrowdate,returndate) values (1,1,"2025-03-15",now());
savepoint s1;


start transaction;
update books set stock=stock-1 where bookid=8;
insert into  borrowingrecords (bookid,memberid,borrowdate,returndate) values (8,8,now(),"2025-03-20");
savepoint v1;


update books set stock=stock+1 where bookid=8;
insert into  borrowingrecords (bookid,memberid,borrowdate,returndate) values (8,8,"2025-02-28",now());
savepoint y1;



#store procedure for decrement stock in books table 
delimiter $$
create procedure dec_stock_by_one(bd int )
begin 
update books set stock=stock-1 where bookid=bd;
end $$
delimiter ;

call dec_stock_by_one(6);
call dec_stock_by_one(6);
call dec_stock_by_one(5);




#store procedure for insert the borrowed time in borrowing record table 
delimiter $$ 
create procedure insert_borro_record  (in bd int ,md int ,bodate datetime  ,ret_date date   )
begin 
insert into borrowingrecords (bookid ,memberid,borrowdate,returndate) values (bd,md,bodate,ret_date) ;
end $$
delimiter ;


 
 call insert_borro_record(6,6,now(),"2025-04-03");
 call insert_borro_record(6,3,now(),"2025-03-13");
 call insert_borro_record(5,2,now(),"2025-03-15");


#store procedure for increment stock in books table 

delimiter $$
create procedure inc_stock_by_one(bd int )
begin 
update books set stock=stock+1 where bookid=bd;
end $$
delimiter ;

call inc_stock_by_one(6);
call inc_stock_by_one(6);
call inc_stock_by_one(5);


#store procedure for insert the returntime in borrowing record table 

delimiter $$ 
create procedure insert_return_record(in bd int ,md int ,bodate date ,ret_date datetime)
begin 
insert into borrowingrecords (bookid ,memberid,borrowdate,returndate) values (bd,md,bodate,ret_date) ;
end $$
delimiter ;
call insert_return_record(6,6,"2025-02-28",now());
call insert_return_record(6,3,"2025-02-28",now());
call insert_return_record(5,2,"2025-02-28",now());

  
# 1. Create a Stored Procedure to Add a New Book
delimiter $$
create procedure add_new_book (in id int ,in ti varchar(80), in au varchar(80) ,in ci int ,in stk int )
begin
insert into books (bookid,title,author,categoryid,stock)
values (id,ti,au,ci,stk); 
end $$
delimiter ;
call add_new_book (24,"harry potter ","j.k. crawling ", 21,100);


#2. Create a Stored Procedure to Update Member Information
#This stored procedure will update a member's information (e.g., name or contact) in the Members table.
desc members;
delimiter $$ 
create procedure update_member_info (in id int  ,in ph bigint,in na varchar(80),in ema varchar(80))
begin 
update members set phone=ph ,name =na,email=ema  where memberid=id;
end $$
delimiter ;
call  update_member_info(1,789451689,"arav gupta","aravgupta18@gmaill.com ");
call  update_member_info(4,249461649,"achary chanakya ","achary chanakya 78@gmaill.com ");
call  update_member_info(12,189451689,"vaishali shivane ","vaishalishivane 18@gmaill.com ");
set sql_safe_updates =0;



#create store procedure for delete a book 
delimiter $$
create procedure dlt(in book_id int )
begin
delete from books where bookid=book_id ; 
end $$
delimiter ;
call dlt(22);
select * from books ;


#Create a stored procedure to update the stock of a book in the Books table.
#Parameters: BookID, StockChange (positive or negative value).
#Ensure that the stock doesn’t go below zero after the update.

delimiter %%
create procedure update_book ( in book_id int ,stk int )
begin
update books set stock=stk  where bookid=book_id ;
end %%
delimiter ;
call update_book  (1,70);
call update_book  (6,700);
call update_book  (8,7000);



#. Stored Procedure to Add a New Category
select * from categories;
delimiter %%
create procedure add_category (in ci int ,cn varchar(30))
begin
insert into categories  values (ci,cn);
SELECT 'Category added successfully' AS message;
end %%
delimiter ;
insert into categories  values (22 ,"storytales");


#. Stored Procedure to Update a Category Name
delimiter $$ 
create procedure  update_category_name ( cid int ,in cat_name varchar (255))
begin
update categories set categoryname =cat_name where categoryid=cid ;
SELECT 'Category added successfully' AS message;
end $$
delimiter ;
call   update_category_name(22 ,"fairytales");


# . Stored Procedure to Delete a Category
delimiter $$
create procedure dlt_category (in id int ) 
begin 
delete from categories where categoryid=id;
select "category deleted succesfully" as message ;
end $$
delimiter ;
call dlt_category (18);
select * from categories ;

#. Stored Procedure to View All Categories

delimiter $$
create procedure show_all_categories()
begin
select * from categories;
end $$
delimiter ;



 

#Write a SQL query to generate a report of the most borrowed books. Include the book title and the number of times it has been borrowed, sorted by the highest number of borrowings.
select books.title, count(borrowingrecords.bookid) as borrowcount  
from borrowingrecords  
join books on borrowingrecords.bookid = books.bookid  
group by books.title  
order by borrowcount desc  
limit 5;  












#Write a SQL query to generate a report of overdue books, calculating the fine based on a daily rate of 2 units of currency per day overdue. Use DATEDIFF() to calculate the overdue days.
#Category-wise Report
SELECT Members.Name, Books.Title, 
DATEDIFF(CURDATE(), ReturnDate) AS OverdueDays, 
(DATEDIFF(CURDATE(), ReturnDate) * 5) AS FineAmount
FROM BorrowingRecords
JOIN Members ON BorrowingRecords.MemberID = Members.MemberID
JOIN Books ON BorrowingRecords.BookID = Books.BookID
WHERE ReturnDate < CURDATE();





#. Stored Procedure to Return a Book
DELIMITER //
CREATE PROCEDURE ReturnBook(
    IN p_RecordID INT
)
BEGIN
    DECLARE v_BookID INT;

    -- Get BookID from the borrowing record
    SELECT BookID INTO v_BookID FROM BorrowingRecords WHERE RecordID = p_RecordID;

    -- Update stock
    UPDATE Books SET Stock = Stock + 1 WHERE BookID = v_BookID;

    -- Remove borrowing record (optional: keep history instead)
    DELETE FROM BorrowingRecords WHERE RecordID = p_RecordID;
END //

DELIMITER ;
#CALL ReturnBook(2);




#. Stored Procedure to Issue a Book (Borrowing a Book)
delimiter //
create procedure issuebookwithmsg(
    in p_bookid int,
    in p_memberid int,
    in p_borrowdate date,
    in p_returndate date,
    out p_message varchar(255)
)
begin
    declare v_stock int;

    -- check if book is available
    select stock into v_stock from books where bookid = p_bookid;

    if v_stock > 0 then
        -- insert into borrowingrecords
        insert into borrowingrecords (bookid, memberid, borrowdate, returndate) 
        values (p_bookid, p_memberid, p_borrowdate, p_returndate);
        
        -- decrease stock
        update books set stock = stock - 1 where bookid = p_bookid;

        -- success message
        set p_message = 'book issued successfully';
    else
        -- message instead of an error
        set p_message = 'book is out of stock';
    end if;
end //
delimiter ;

call issuebookwithmsg(1, 5, '2025-03-01', '2025-03-15', @message);
select @message;


