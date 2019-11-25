with BinarySearchTree;
with Ada.Strings;
use Ada.Strings;
with Ada.Strings.Fixed;
use Ada.Strings.Fixed;
with Ada.Text_IO;
use ada.Text_IO;
procedure Main is
   subtype String10 is String(1..10);
   type Customer is
      record
         Name:  String10;
         PhoneNumber: String10;
      end record;
   HeadKey : String10 := "zzzzzzzzzz";-- 'z' is the highest value ASCII character, so a String10 with all z's guarantees insertion to the left of Head node
   HeadCustomer : Customer := Customer'(HeadKey,"867-5309  ");

   function "<" (TheKey: in String10;  ARecord: in Customer) return Boolean is
   begin
      -- Is TheKey less than the key of ARecord?
      return (TheKey < ARecord.Name);
   end "<";

   function ">" (TheKey: in String10;  ARecord: in Customer) return Boolean is
   begin
      --Is TheKey greater than the key of ARecord?
      return (TheKey > ARecord.Name);
   end ">";

   function "=" (TheKey: in String10;  ARecord: in Customer) return Boolean is
   begin
      --Is TheKey equal to the key of ARecord?
      return (TheKey = ARecord.Name);
   end "=";
   function "<=" (TheKey: in String10; ARecord: in Customer) return Boolean is
   begin
      return (TheKey <= ARecord.Name);
   end "<=";

   function ToString10(str: in String) return String10 is
      str10: String10;
   begin
      Move(str,str10);
      return str10;
   end ToString10;

   procedure CustomerFromString(Str1: in String; ARecord: in out Customer) is
      i: Integer := 1;
      custName : String10;
      custPhone: String10;
   begin
      --Take in a String and output a record.
      MLoop :
      loop
         i := i + 1;
         if Str1(i..i) = "," then
            exit MLoop;
         end if;
      end loop MLoop;
      custName := ToString10(Str1(Str1'First..(i-1)));
      custPhone := ToString10(Trim(Str1((i+1)..Str1'Last), Left));
      ARecord := Customer'(custName,custPhone);
      return;
   end CustomerFromString;

   procedure PrintFullCustomer(ARecord: in Customer) is
   begin
      Put(Trim(ARecord.Name, Right));
      Put(", ");
      Put(Trim(ARecord.PhoneNumber, Right));
   end PrintFullCustomer;

   procedure PrintCustomerName(ARecord: in Customer) is
   begin
      Put(Trim(ARecord.Name, Right));
   end PrintCustomerName;

   function GetName(ARecord: in Customer) return String10 is
   begin
      return ARecord.Name;
   end GetName;

   procedure PrintKey(Name: in String10) is
   begin
      Put(Trim(Name, Right));
   end PrintKey;

   package MySearchTree is new BinarySearchTree(String10, Customer, "<", ">", "=","<=", PrintFullCustomer, PrintCustomerName, HeadKey, HeadCustomer, GetName, CustomerFromString, PrintKey);
   use MySearchTree;
   Root: BinarySearchTreePoint;
   FoundCustomer: BinarySearchTreePoint;
   f : Ada.Text_IO.File_Type;
begin
   Ada.Text_IO.Create(f, Ada.Text_IO.Out_File, "output.txt");
   Ada.Text_IO.Put_Line("Redirecting all output to output.txt");
   Ada.Text_IO.Set_Output(f);

   --C OPTION TRANSACTIONS
   New_Line;
   Put_Line("C Option");
   TreeFromFile("inputC1.txt", Root); --1
   FindCustomerIterative(Root, ToString10("Ortiz"), FoundCustomer); --2
   FindCustomerRecursive(Root, ToString10("Ortiz"), FoundCustomer); --3
   FindCustomerIterative(Root, ToString10("Penton"), FoundCustomer); --4
   FindCustomerRecursive(Root, ToString10("Penton"), FoundCustomer); --5
   FindCustomerIterative(Root, ToString10("Ikerd"), FoundCustomer); --6.1
   InOrderTraversal(FoundCustomer); --6.2
   TreeFromFile("inputC2.txt", Root); --7
   InOrderTraversal(Root); --8
   PreOrderTraversalIterative(Root); --9
   PostOrderTraversalIterative(Root); --10

   --B OPTION TRANSACTIONS
   New_Line;
   Put_Line("B Option");
   GetHead(Root);
   FindCustomerIterative(Root, ToString10("Robson"), FoundCustomer); --7.1
   DeleteRandomNode(FoundCustomer, Root); --7.2
   InOrderTraversal(Root);
   FindCustomerIterative(Root, ToString10("Moutafis"), FoundCustomer); --7.3
   DeleteRandomNode(FoundCustomer, Root); --7.4
   InOrderTraversal(Root);
   FindCustomerIterative(Root, ToString10("Ikerd"), FoundCustomer); --7.5
   DeleteRandomNode(FoundCustomer, Root); --7.6
   TreeFromFile("inputB1.txt", Root); --8
   InOrderTraversal(Root); --9
   ReverseInOrderCaller(Root); --10
   PreOrderTraversalIterative(Root); --11

   --A
   New_Line;
   Put_Line("A Option");
   PostOrderTraversalIterative(Root);--12
   PostOrderTraversalRecursiveCaller(Root); --13

   New_Line(2);
   Put_Line("The lab steps do not ask for this, but there is a grading check for a recursive preorder traversal.");
   Put_Line("All preorder traversals before this one use the iterative version.");
   Put_Line("This is just a demonstration that I created a working recursive preorder as well.");
   PreOrderTraversalRecursiveCaller(Root);

   Ada.Text_IO.Close(f);
end Main;
