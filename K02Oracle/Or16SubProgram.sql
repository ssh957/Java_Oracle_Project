/**************
���ϸ� : Or16SubProgram.sql
�������α׷�
���� : �������ν���, �Լ� �׸��� ���ν����� ������ Ʈ���Ÿ� �н�
**************/


/*
�������α׷�(Sub Program)
-PL/SQL������ ���ν����� �Լ���� �ΰ��� ������ �������α׷����ִ�.
-Select�� �����ؼ� �ٸ� DML���� �̿��Ͽ� ���α׷������� ��Ҹ� ����
��밡���ϴ�.
-Ʈ���Ŵ� ���ν����� �������� Ư�� ���̺��� ���ڵ��� ��ȭ�� �������
�ڵ����� ����ȴ�.
*/

/*
�������ν���(Stored Procedure)
-���ν����� reture���� ���� ��� out�Ķ���͸� ���� ���� ��ȯ�Ѵ�.
-���ȼ��� ���� �� �ְ� ��Ʈ��ũ�� ���ϸ� ���� �� �ִ�.
����]
    Create [Or Replace] Procedure ���ν�����
    [(
        �Ű����� In �ڷ���, �Ű����� Out �ڷ���
    )]
    Is [��������]
    Begin
        ���๮��;
    End;
*/

set serveroutput on;
/*
�ó�����] ����� �޿��� select�Ͽ� ����ϴ� �������ν����� �����Ͻÿ�.
*/
--�Ķ���Ͱ� ���� ���ν��� ����
create procedure pcd_emp_salary
is  
    --������ ����. ������̺��� �޿� �÷��� �����ϴ� ��������.
    v_salary employees.salary%type;
begin
    --100�� ����� �޿��� ������ �Ҵ��Ѵ�. �̶� into���� ����Ѵ�.
    select salary into v_salary
    from employees
    where employee_id = 100;
    
    dbms_output.put_line('�����ȣ100�� �޿���:'|| v_salary ||'�Դϴ�');
end;
/
--������ �������� Ȯ��(����� �빮�ڷ� ��ȯ��)
select * from user_source where name like upper('%pcd_emp_salary%');
--ȣ��Ʈ ȯ�濡�� ���ν��� ������.
execute pcd_emp_salary;


/*
-IN�Ķ���� ����Ͽ� ���ν��� ����

�ó�����]����� �̸��� �Ű������� �޾Ƽ� ������̺����� ���ڵ带 ��ȸ�� ��
�ش����� �޿��� ����ϴ� ���ν����� ���� �� �����Ͻÿ�.
�ش� ������ in�Ķ���͸� ���� �� ó���Ѵ�.
����̸�(first_name) : Bruce, Neena
*/
--in�Ķ���͸� �����Ѵ�. ������̺��� ������� �����ϴ� ������������.
create or replace procedure pcd_in_param_salary
    (param_name in employees.first_name%type)
is
    /*
    ���ν��� ������ ������ �����ϴ� �κ�.
    PL/SQL���� declare�� �����ϰ�, �ʿ���� ���
    ������ �� ����.
    */
    valSalary number(10);
begin
    /*
    ���Ķ���ͷ� ���޵� ����̸��� �������� �޿��� ���ؼ�
    ������ �Ҵ��Ѵ�.
    */
    select salary into valSalary
    from employees where first_name = param_name;
    
    dbms_output.put_line(param_name||'�� �޿��� '|| valSalary ||' �Դϴ�');
end;
/
--����� �̸��� �Ķ���ͷ� �����Ͽ� ���ν��� ȣ��(����)
execute pcd_in_param_salary('Bruce');
execute pcd_in_param_salary('Neena');



/*
-OUT�Ķ���� ����Ͽ� ���ν��� ����

�ó�����] �� ������ �����ϰ� �̸��� �Ű������� ���޹޾Ƽ� �޿��� ��ȸ�ϴ�
���ν����� �����Ͻÿ�. ��, �޿��� out�Ķ���͸� ����Ͽ� ��ȯ�� ����Ͻÿ�.
*/
create or replace procedure pcd_out_param_salary
    (
        param_name in varchar2,
        param_salary out employees.salary%type
    )--�ΰ��� ������ �Ķ���͸� ������.
is
    --���������� �ʿ���� ��� ���� ����.
begin
    --����� ����� out�Ķ���Ϳ� �Ҵ���
    --out�Ķ���ʹ� ȣ��Ʈȯ�� Ȥ�� Java�������� ��ȯ�ȴ�.
    select salary into param_salary
    from employees where first_name = param_name;
end;
/
--out�Ķ���͸� Ȯ���ϱ� ���� ���ε庯���� �����Ѵ�.
var v_salary varchar2(30);
--���ν��� ����� ������ �Ķ���͸� �����Ѵ�. ���ε� ������ :�� �ٿ����Ѵ�.
execute pcd_out_param_salary('Matthew', :v_salary);
--������, ���ν����� ��ȯ�ϴ� out�Ķ���͸� ����Ѵ�.
print v_salary;

/*
�ó�����] �����ȣ�� �޿��� �Ű������� ���޹޾� �ش����� �޿���
    �����ϰ� ���� ������ ���� ������ ��ȯ�޾Ƽ� ����ϴ� ���ν�����
    �ۼ��Ͻÿ�
*/
--�ǽ��� ���� employees ���̺��� ���ڵ���� ��ü �����Ѵ�.
create table zcopy_employees
as
select * from employees where 1=1;

--in�Ķ���ʹ� �����ȣ��, �޿��� ������. out�Ķ���ʹ� ����� ���ǰ��� ��ȯ��.
create or replace procedure pcd_update_salary
    (
        p_empid in number,
        p_salary in number,
        rCount out number
    )
is
    --�߰����� ���� ������ �ʿ�����Ƿ� ����
begin
    --���� ������Ʈ�� ó���ϴ� ���������� in�Ķ���͸� ���� ���� ����
    update zcopy_employees
        set salary = p_salary
            where employee_id = p_empid;
    
    /*
    sql%notfound
        : ���������� ����� ���� ������� true�� ��ȯ�Ѵ�.
        found�� �ݴ��� ��츦 ��ȯ�Ѵ�.
    sql%rowcount
        : �������� �� ���� ����� ���� ������ ��ȯ�Ѵ�.
    */
    if SQL%notfound then
        dbms_output.put_line(p_empid ||'��(��) ���»���Ӵ�');
    else
        dbms_output.put_line(SQL%rowcount ||'���� �ڷᰡ �����Ǿ�');
        --���� ����� ���� ������ ��ȯ�Ͽ� out�Ķ���Ϳ� �����Ѵ�.
        rCount := sql%rowcount;
    end if;
    
    /*
    ���� ��ȭ�� �ִ� ������ ������ ��� �ݵ�� commit �ؾ� �������̺���
    ����Ǹ� oracle�ܺο��� Ȯ���� �� �ִ�.
    */
    commit;
end;
/

--���ν��� ������ ���� ���ε庯���� ����(var�� ������)
variable r_count number;
--���� ���ڵ� Ȯ��
select first_name, salary from zcopy_employees where employee_id=100;--Steven	24000
--���ν��� ����(���ε� �������� �ݵ�� :�� �ٿ��� ��)
execute pcd_update_salary(100, 30000, :r_count);
--���� �� ����� ���� ���� Ȯ��
print r_count;
select first_name, salary from zcopy_employees where employee_id=100;--Steven	30000


/*
2.�Լ�
-����ڰ� PL/SQL���� ����Ͽ� ����Ŭ���� �����ϴ� �����Լ��� ���� �����
������ ��
-�Լ��� In�Ķ��Ÿ�� ����� �� ������, �ݵ�� ��ȯ�� ���� ������Ÿ����
Return���� �����ؾ��Ѵ�.
-���ν����� �������� ������� ���� �� ������, �Լ��� �ݵ�� �ϳ��� ����
��ȯ�޴´�.

[�Լ��� ���ν��� ��]
���� ��ȯ�Ҷ��� Out�Ķ���͸� �̿�������, �Լ��� return���� ���� ��ȯ�Ѵ�.
������ �Ϻη� ���ǹǷ� �ݵ�� return���� �־���Ѵ�.
*/


/*
�ó�����] 
2���� ������ ���޹޾Ƽ� �� ���������� ������ ���ؼ� ����� ��ȯ�ϴ� �Լ��� �����Ͻÿ�.
���࿹) 2, 7 -> 2+3+4+5+6+7 = ??
*/
create or replace function calSumBetween (
    num1 in number,
    num2 number --�Լ��� in�Ķ���͸� ��밡���ϹǷ� ������ �� �ִ�.
)
return
    --�Լ��� �ݵ�� ��ȯ���� �����Ƿ� ��ȯŸ���� �����ؾ��Ѵ�.
    number
is
    --��ȯ������ ����� ����
    sumNum number;
begin
    sumNum := 0;
    for i in num1 .. num2 loop
        sumNum := sumNum + i;
    end loop;
    
    --������ ����� ��ȯ�Ѵ�.
    return sumNum;
end;
/
--������1 : �������� �Ϻη� ����Ѵ�.
select calSumBetween(1,10) from dual;
select calSumBetween(1,1000) from dual;

--������2 : ���ε庯���� ���� ����������� ����Ѵ�.
var hapText varchar2(30);
execute :hapText := calSumBetween(1,10);
print hapText;

--������ �������� Ȯ��
select * from user_source where name like upper('%calsum%');

/*
����] �ֹι�ȣ�� ���޹޾Ƽ� ������ �Ǵ��ϴ� �Լ��� �����Ͻÿ�.
999999-1000000 -> '����' ��ȯ
999999-2000000 -> '����' ��ȯ
��, 2000�� ���� ����ڴ� 3�� ����, 4�� ������.
*/
/*
--�ֹι�ȣ�� ���� �κ��� ���������� �߶������� Ȯ��
select subStr('999999-1000000', 8, 1) from dual;
select subStr('999999-2000000', 8, 1) from dual;
*/



--�ش� �Լ��� �ֹι�ȣ�� �������·� ���޹޾� ó����(in��������)
create or replace function findGender(juminNum in varchar2)
return varchar2 --���� or ���ڸ� ��ȯ�ϹǷ� ��ȯŸ���� ���ڷ� ����
is
    genderTxt varchar2(1);--������ �ش��ϴ� ���� �ϳ��� ����
    returnVal varchar2(10);--���� Ȯ���� ���� or ���ڸ� ����
begin
    --�ֹι�ȣ �ڸ���
    genderTxt := subStr(juminNum,8,1);
    if genderTxt='1' then
        returnVal := '����';
    elsif genderTxt='2' then
        returnVal := '����';
    elsif genderTxt='3' then
        returnVal := '����';
    elsif genderTxt='4' then
        returnVal := '����';
    end if;
    return returnVal;
end;
/
select findGender('999999-1000000') from dual;
select findGender('999999-4000000') from dual;

/*
--���� ������ �ڵ�
set serveroutput on;
create or replace function findGender (
    juminNum in varchar2
)
return
    varchar2
is
    jenderR varchar2;
    num3 number := subStr(juminNum, 8, 1);
begin
    loop
        if num3=1 then
            jenderR := '����';
        elsif num3=3 then
            jenderR := '����';
        elsif num3=2 then
            jenderR := '����';
        elsif num3=4 then
            jenderR := '����';
        end if;
    end loop;
    return jenderR;
end;
/

select findGender('999999-1000000') from dual; -- -> ���ڹ�ȯ��
select findGender('999999-4000000') from dual;
*/

/*
�ó�����] ������̸�(first_name)�� �Ű������� ���޹޾Ƽ�
�μ���(department_name)�� ��ȯ�ϴ� �Լ��� �ۼ��Ͻÿ�.
    �Լ��� : func_deptName
*/
--1�ܰ� : Nancy�� �μ����� ����ϱ� ���� join��
select 
    first_name, last_name, department_id, department_name
from employees inner join departments using(department_id)
where first_name = 'Nancy';

--2�ܰ� : �Լ��ۼ�
create or replace function func_deptName(
    param_name varchar2 --in�Ķ���� ����
)
return
    varchar2 --�μ����� ��ȯ�ϹǷ� ���������� ����
is
    --�μ����̺��� �μ����� �����ϴ� ����Ÿ������ ����
    return_deptname departments.department_name%type;
begin
    --������ ������ ����� ������ ����
    select 
        department_name into return_deptname
    from employees inner join departments using(department_id)
    where first_name = param_name;  
    --��� ��ȯ
    return return_deptname;
end; 
/
select func_deptname('Nancy') from dual;
select func_deptname('&name') from dual;

/*
3]Ʈ����(Trigger)
    : �ڵ����� ����Ǵ� ���ν����� ���� ������ �Ұ����ϴ�.
    �ַ� ���̺��� �Էµ� ���ڵ��� ��ȭ�� ������ ����ȴ�.
*/
--�ǽ��� ���� HR�������� �Ʒ� ���̺��� �����Ѵ�.
create table trigger_dept_original
as
select * from departments where 1=1;--�μ����̺��� ���ڵ���� ����

create table trigger_dept_backup
as
select * from departments where 1=0;--�μ����̺��� ������ ����


/*
�ó�����] ���̺��� ���ο� �����Ͱ� �ԷµǸ� �ش� �����͸� ������̺��� �����ϴ�
Ʈ���Ÿ� �ۼ��غ���.
*/

create trigger trig_dept_backup
    after /* Ÿ�̹� : after=>�̺�Ʈ �߻���, before=>�̺�Ʈ �߻��� */
    insert /* �̺�Ʈ : �Է�/����/������ ���� ���� ����� �߻��� */
    on trigger_dept_original /* Ʈ���Ÿ� ������ ���̺� */
    for each row /*
        �� ���� Ʈ���ŷ� ������. �� �ϳ��� ���� ��ȭ�Ҷ����� Ʈ���Ű�
        ����ȴ�. ���� ����(���̺�)���� Ʈ���ŷ� �����ϰ� �ʹٸ�
        �ش� ������ �����ϸ� �ȴ�. �̶����� ������ �ѹ� �����Ҷ�
        Ʈ���ŵ� �ѹ��� ����ȴ�.
    */
begin
    /* insert �̺�Ʈ�� �߻��Ǹ� true�� ��ȯ�Ͽ� if���� ����ȴ�. */
    if Inserting then
        dbms_output.put_line('insert Ʈ���� �߻���');
        /*
        ���ο� ���ڵ尡 �ԷµǾ����Ƿ� �ӽ����̺� :new�� ����ǰ�,
        �ش� ���ڵ带 ���� backup���̺��� �Է��� �� �ִ�.
        �̿� ���� �ӽ����̺��� ����� Ʈ���ſ����� ����� �� �ִ�.
        */
        insert into trigger_dept_backup
        values(
            :new.department_id,
            :new.department_name,
            :new.manager_id,
            :new.location_id
        );
    end if;
end;
/
insert into trigger_dept_original values (300, '�����ǹ�', 10, 101);
select * from trigger_dept_original where department_id>=250;
select * from trigger_dept_backup;

/*
����2] trig_dept_delete
�ó�����] �������̺����� ���ڵ尡 �����Ǹ� ������̺��� ���ڵ嵵 ����
�����Ǵ� Ʈ���Ÿ� �ۼ��غ���.
*/
create or replace trigger trig_dept_delete
    after
    delete
    on trigger_dept_original
    for each row/* original���̺��� ���ڵ尡 ������ �� �������
                    �߻��Ǵ� Ʈ���� ����*/
begin
    dbms_output.put_line('delete Ʈ���� �߻���');
    /*
    ���ڵ尡 ������ ���Ŀ� �̺�Ʈ�� �߻��Ǿ� Ʈ���Ű� ȣ��ǹǷ�
    :old �ӽ����̺��� ����ؾ��Ѵ�.
    */
    if deleting then
        delete from trigger_dept_backup
            where department_id = :old.department_id;
    end if;
end;
/
delete trigger_dept_original where department_id=300;
select * from trigger_dept_backup;

/*
For each row �ɼǿ� ���� Ʈ���� ����Ƚ�� �׽�Ʈ

����1 : �������� ���̺��� ������Ʈ ���� ������� �߻��Ǵ�
    Ʈ���� ����
*/
create or replace trigger trigger_update_test
    after update
    on trigger_dept_original
    for each row
begin
    if updating then
        insert into trigger_dept_backup
        values(
            :old.department_id,
            :old.department_name,
            :old.manager_id,
            :old.location_id
        );
    end if;
end;
/
--���� ���ڵ� Ȯ���ϱ�
select * from trigger_dept_original;

--�������� ���̺��� ���ڵ� 1�� ������Ʈ
update trigger_dept_original
    set department_name='�����ǹ�', manager_id=78
    where department_id=30;
select * from trigger_dept_original;
--��������� Ȯ��
select * from trigger_dept_backup;--1���� �߰��� ���ڵ� Ȯ��

--6���� ���ڵ带 �Ѳ����� ������Ʈ
update trigger_dept_original
    set department_name='�Ѳ������ѹ�', manager_id=99
    where department_id between 50 and 100;
select * from trigger_dept_backup;

--Ʈ���� �����ϱ�
drop trigger trigger_update_test;

/*
����2 : �������� ���̺��� ������Ʈ ���� ���̺�(����) ������
    �߻��Ǵ� Ʈ���� ����
*/
create or replace trigger trigger_update_test2
    after update
    on trigger_dept_original
    /*for each row --������� Ʈ���� �̹Ƿ� �ּ�ó���Ѵ�. */
begin
    if updating then
        insert into trigger_dept_backup
        values(
            999,
            to_char(sysdate, 'yy-mm-dd hh24:mi:ss')||'[update]',
            99,
            99
        );
    end if;
end;
/

--6���� ���ڵ带 �Ѳ����� ������Ʈ
update trigger_dept_original
    set department_name='�Ѳ�����10��', manager_id=99
    where department_id between 110 and 200;
select * from trigger_dept_backup;--������� Ʈ�����̹Ƿ� 1�� ���ڵ� �߰���



--Ʈ���� �����ϱ�
drop trigger trigger_update_test2;
drop table trigger_dept_original;
drop table trigger_dept_backup;

--������ Ʈ���� �����ͻ������� Ȯ���ϱ�
select * from user_triggers
    where trigger_name like upper('%update_test2%');
    
/*
    Ʈ���Ÿ� ������ ���̺��� �����ϸ� Ʈ���ŵ� ���� �����ȴ�.
*/





------------------------------------
--Java�� �Լ� �� ���ν��� �����ϱ�
--kosmo�������� �ǽ��մϴ�.

/*
�ó�����] �Ű������� ȸ�����̵�(���ڿ�)�� ������ ù���ڸ� ������
    �������κ��� *�� ��ȯ�Ͽ� ��ȯ�ϴ� �Լ��� �����Ͻÿ�.
    ���࿹) hongildong -> h*********
*/
--select�� ���� Ȯ��
select substr('hongildong',1,1) from dual; --���: h
select length('hongildong') from dual; --���: 10
select rpad(substr('hongildong',1,1), length('hongildong'), '*') from dual;

select rpad(substr('hongildong',1,1), length('hongildong'), '*') from dual;

create or replace function fillAsterik (idStr varchar2)
return varchar2 --��ȯŸ�� ����
is retStr varchar2(50); --��ȯ���� ������ ������ ����
begin
    --Or03�� ��뿹������. ���ڿ��� �������� Ư����ȣ�� ä���ش�.
    retStr := rpad(substr(idStr,1,1), length(idStr), '*');
    return retStr;
end;
/
select fillAsterik('kosmo') from dual;
select fillAsterik('nakjasabal') from dual;

/*
�ó�����] member ���̺��� ���ο� ȸ�������� �Է��ϴ� ���ν�����
    �����Ͻÿ�.
    �Է°� : ���̵�, �н�����, �̸�
*/

create or replace procedure KosmoMemberInsert(
        p_id in varchar2,
        p_pass in varchar2,
        p_name in varchar2, /* Java���� ������ ���ڸ� ���� in�Ķ���� */
        returnVal out number --�Է¼������� Ȯ��
    )
is
begin
    --���Ķ���͸� ���� insert���� �ۼ�
    insert into member (id, pass, name)
        values (p_id, p_pass, p_name);
    
    if sql%found then
        --�Է��� ����ó�� �Ǿ��ٸ�, ������ ���� ������ ���ͼ�
        --out �Ķ���Ϳ� �����Ѵ�.
        returnVal := sql%rowcount;
        commit;
    else
        --�Է¿� ������ ���
        returnVal := 0;
    end if;
end;
/
var i_result varchar2(10);
execute KosmoMemberInsert('pro01', '1234', '���ν���', :i_result);
print i_result;
select * from member;



select * from user_source where name like upper('%kosmomem%');

var insert_count number;
execute KosmoMemberInsert('pro1','1234','���ν���',:insert_count);
print insert_count;

select * from member;


/*
�ó�����] member���̺��������ڵ带�����ϴ� ���ν����������Ͻÿ�.
    �Ű����� : In -> member_id(���̵�)
                Out ->returnVal(����/���й�ȯ)
    Out�Ķ���� : ���������� =>'SUCCESS' ��ȯ
                    �������н� -> 'FAIL' ��ȯ
    ���ν����� : KosmoMemberDelete
*/
create or replace procedure KosmoMemberDelete(
        member_id in varchar2,
        returnVal out varchar2
    )
is --������ �ʿ���� ��� ��������
begin
    --���Ķ���͸� ���� delete���� �ۼ�
    delete from member where id=member_id;
    
    if SQL%Found then
        --���������� ������ �Ǿ��ٸ�...
        returnVal := 'SUCCESS';
        --������ ���� �����ϱ� ���� commit
        commit;
    else
        returnVal := 'FAIL';
    end if;
    --Out�Ķ���͸� ���� ��ȯ�ǹǷ� return���� ����
end;
/

var delete_var varchar2(10);
execute KosmoMemberDelete('test99',:delete_var);
print delete_var;


--------------------------
/*
�ó�����] ���̵�� �н����带 �Ű������� ���޹޾Ƽ� ȸ������ ���θ�
�Ǵ��ϴ� ���ν����� �ۼ��Ͻÿ�.

    �Ű����� :
        In -> user_id, user_pass
        Out -> returnVal
    ��ȯ�� :
        0 -> ȸ����������(�Ѵ�Ʋ��)
        1 -> ���̵�� ��ġ�ϳ� �н����尡 Ʋ�����
        2 -> ���̵�/�н����� ��� ��ġ�Ͽ� ȸ������ ����
    ���ν����� : KosmoMemberAuth
*/

create or replace procedure KosmoMemberAuth(
       user_id in varchar2,
       user_pass in varchar2,
       returnVal out number
)
is
    -- count(*)�� ���� ��ȯ�Ǵ� ���� ����
    member_count number(1) := 0;
    -- ��ȸ�� ȸ�������� �н����带 ������ ����
    member_pw varchar2(50);
begin
    --�ش� ���̵� �����ϴ��� �Ǵ�
    select count(*) into member_count
        from member where id=user_id;
        
    if member_count=1 then
        --ȸ�� ���̵� �����ϴ� ���
        
        --�н����� Ȯ���� ���� �ι�° ���� ����
        select pass into member_pw from member
            where id=user_id;
        
        --�н����� ��ġ���� �Ǵ�    
        if member_pw=user_pass then
            returnVal := 2;
        else 
            returnVal := 1;
        end if;
    else
        --ȸ�� ���̵� ���°��
        returnVal := 0;
    end if;
end;
/

--�Ѵ���ġ, ���̵� ��ġ, �Ѵ�Ʋ�� 3���� ���̽��� ��� �׽�Ʈ�غ���
variable member_auth number;
execute KosmoMemberAuth('test1234', '1234', :member_auth);
print member_auth;

execute KosmoMemberAuth('yugyeom', '1234�н�����Ʋ��', :member_auth);
print member_auth;

execute KosmoMemberAuth('yugyeom���̵�Ʋ��', '1234�н�����Ʋ��', :member_auth);
print member_auth;
        









