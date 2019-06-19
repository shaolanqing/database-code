drop database TSGL
CREATE DATABASE TSGL
ON PRIMARY
( NAME=books_data,
  filename='d:\sql\books_data.mdf',
  size=5,
  maxsize=20,
  filegrowth=5%
 )
 LOG ON
 ( name=books_log,
   filename='d:\sql\books_log.ldf',
   size=2,
   maxsize=10,
   filegrowth=1
 )
  