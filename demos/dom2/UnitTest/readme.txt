ToDo (dom2 implementations for delphi):

a) add dummy routine to msxml_impl.pas (importNode)
   OK/FE

b) add test routine, that is doing the following:
   10 000 times document.createElement
   OK/JK

c) add test routine, that is doing the following:
   10 000 times node:=document.createElement
                documentElement.appendChild(node)
   OK/JK

d) add test routne:
   1 * attr:=document.createAttribute
       documentElement.appendChild(attr)
   OK/JK

e) add test routine for getElementsByID
   OK/JK
   

f) check for correct exception, if invalid parameters a
   are passed (like nil or invalid characters) to all
   methods

   1. appendChild - OK/JK
   ...

Fe, 08.01.2001