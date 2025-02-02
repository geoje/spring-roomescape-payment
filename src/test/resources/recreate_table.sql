drop table if exists member cascade;
drop table if exists member_reservation cascade;
drop table if exists payment cascade;
drop table if exists reservation cascade;
drop table if exists reservation_time cascade;
drop table if exists theme cascade;
create table member
(
    id       bigint generated by default as identity,
    email    varchar(255),
    name     varchar(255),
    password varchar(255),
    role     varchar(255) default 'USER' check (role in ('ADMIN', 'USER')),
    primary key (id)
);
create table member_reservation
(
    created_at     timestamp(6),
    id             bigint generated by default as identity,
    member_id      bigint,
    reservation_id bigint,
    status         varchar(255) default 'CONFIRMED' check (status in ('CONFIRMED', 'CANCELLATION_WAITING', 'PAYMENT_REQUIRED')),
    primary key (id)
);
create table reservation
(
    date     date,
    id       bigint generated by default as identity,
    theme_id bigint,
    time_id  bigint,
    primary key (id)
);
create table reservation_time
(
    start_at time(6),
    id       bigint generated by default as identity,
    primary key (id)
);
create table theme
(
    id          bigint generated by default as identity,
    description varchar(255),
    name        varchar(255),
    thumbnail   varchar(255),
    primary key (id)
);
create table payment
(
    amount                numeric(38, 2),
    created_at            timestamp(6),
    id                    bigint generated by default as identity,
    member_reservation_id bigint unique,
    order_id              varchar(255),
    payment_key           varchar(255),
    primary key (id)
);
alter table if exists member_reservation
    add constraint FK3tx7yq7tw0xo0rhvt5sesw9s5
    foreign key (member_id)
    references member;
alter table if exists member_reservation
    add constraint FK4e01kps1ha814vtuwja2swih9
    foreign key (reservation_id)
    references reservation;
alter table if exists reservation
    add constraint FKlthp3qwugirblkd0anlpuu9gh
    foreign key (theme_id)
    references theme;
alter table if exists reservation
    add constraint FKnp181b4qd37y68p57h9nhosqo
    foreign key (time_id)
    references reservation_time;
alter table if exists payment
    add constraint FKjvgu5md0ffa5evlolks0ixrmi
    foreign key (member_reservation_id)
    references member_reservation;

INSERT INTO member(name, email, password)
VALUES ('클로버', 'test@gmail.com', 'password');
INSERT INTO member(name, email, password)
VALUES ('페드로', 'test2@gmail.com', 'password');
INSERT INTO member(name, email, password)
VALUES ('클로버2', 'test3@gmail.com', 'password');
INSERT INTO member(name, email, password)
VALUES ('클로버3', 'test4@gmail.com', 'password');
INSERT INTO member(name, email, password)
VALUES ('클로버4', 'test5@gmail.com', 'password');
INSERT INTO member(name, email, password)
VALUES ('클로버5', 'test6@gmail.com', 'password');
INSERT INTO member(name, email, password, role)
VALUES ('관리자', 'admin@gmail.com', 'password', 'ADMIN');

INSERT INTO reservation_time (start_at)
VALUES ('10:00:00');
INSERT INTO reservation_time (start_at)
VALUES ('12:00:00');
INSERT INTO reservation_time (start_at)
VALUES ('14:00:00');
INSERT INTO reservation_time (start_at)
VALUES ('15:00:00');

INSERT INTO theme (name, description, thumbnail)
VALUES ('공포', '완전 무서운 테마', 'https://example.org');
INSERT INTO theme (name, description, thumbnail)
VALUES ('힐링', '완전 힐링되는 테마', 'https://example.org');
INSERT INTO theme (name, description, thumbnail)
VALUES ('힐링2', '완전 힐링되는 테마2', 'https://example.org');
INSERT INTO theme (name, description, thumbnail)
VALUES ('몽환', '안전 몽환적인 테마', 'https://example.org');

INSERT INTO reservation (date, time_id, theme_id)
VALUES ('2099-12-31', 1, 1);
INSERT INTO reservation (date, time_id, theme_id)
VALUES ('2099-12-31', 1, 2);
INSERT INTO reservation (date, time_id, theme_id)
VALUES ('2024-12-01', 1, 2);
INSERT INTO reservation (date, time_id, theme_id)
VALUES ('2024-12-02', 1, 2);
INSERT INTO reservation (date, time_id, theme_id)
VALUES ('2024-12-02', 2, 2);
INSERT INTO reservation (date, time_id, theme_id)
VALUES ('2024-12-03', 1, 2);
INSERT INTO reservation (date, time_id, theme_id)
VALUES ('2024-12-04', 1, 2);

INSERT INTO reservation (date, time_id, theme_id)
VALUES (FORMATDATETIME(DATEADD('DAY', -3, NOW()), 'yyyy-MM-dd'), 2, 2);
INSERT INTO reservation (date, time_id, theme_id)
VALUES (FORMATDATETIME(DATEADD('DAY', -4, NOW()), 'yyyy-MM-dd'), 1, 2);
INSERT INTO reservation (date, time_id, theme_id)
VALUES (FORMATDATETIME(DATEADD('DAY', -5, NOW()), 'yyyy-MM-dd'), 1, 1);

INSERT INTO reservation (date, time_id, theme_id)
VALUES ('2024-12-31', 4, 4);
INSERT INTO reservation (date, time_id, theme_id)
VALUES ('2025-12-31', 4, 4);

INSERT INTO member_reservation (member_id, reservation_id) -- pk: 1
VALUES (1, 2);
INSERT INTO member_reservation (member_id, reservation_id) -- 2
VALUES (2, 1);
INSERT INTO member_reservation (member_id, reservation_id) -- 3
VALUES (1, 3);
INSERT INTO member_reservation (member_id, reservation_id) -- 4
VALUES (3, 4);
INSERT INTO member_reservation (member_id, reservation_id) -- 5
VALUES (4, 5);
INSERT INTO member_reservation (member_id, reservation_id) -- 6
VALUES (5, 6);
INSERT INTO member_reservation (member_id, reservation_id) -- 7
VALUES (6, 7);
INSERT INTO member_reservation (member_id, reservation_id) -- 8
VALUES (4, 8);
INSERT INTO member_reservation (member_id, reservation_id) -- 9
VALUES (5, 9);
INSERT INTO member_reservation (member_id, reservation_id) -- 10
VALUES (6, 10);

INSERT INTO member_reservation (member_id, reservation_id, status, created_at) -- 11
VALUES (4, 11, 'CANCELLATION_WAITING', CURRENT_TIMESTAMP());
INSERT INTO member_reservation (member_id, reservation_id, status, created_at) -- 12
VALUES (3, 11, 'CANCELLATION_WAITING', DATEADD(DAY, 1, CURRENT_TIMESTAMP()));

INSERT INTO member_reservation(member_id, reservation_id) -- 13
VALUES (3, 12);
INSERT INTO member_reservation(member_id, reservation_id, status) -- 14
VALUES (3, 12, 'CANCELLATION_WAITING');

INSERT INTO payment (amount, created_at, member_reservation_id, order_id, payment_key)
VALUES (21000, '2024-06-03T10:02:37.465', 1, 'testOrderId1', 'testPaymentKey1');
