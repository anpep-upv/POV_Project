-- display_with_scroll.adb
-- Copyright (c) 2021 Ángel Pérez <aperpor@upv.edu.es>
--
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; either version 2
-- of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

with POV_Sim;
with Chars_8x5;

with Ada.Real_Time;       use Ada.Real_Time;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Fixed;   use Ada.Strings.Fixed;

procedure Display_With_Scroll is
   T : Time;
begin
   Put_Line ("Starting simulation");
   POV_Sim.Start_Simulation;

   for Iteration in 1 .. 5 loop
      -- Declarative block for holding the input file handle.
      declare
         File_Name  : constant String := "text";
         Input_File : File_Type;
      begin
         Open (File => Input_File, Mode => In_File, Name => File_Name);

         declare
            Prefix : constant String := 20 * " ";
            Text   : String          := Prefix & Get_Line (Input_File);

            Character_Stride : constant Integer := 5;
            Columns : constant Integer := Text'Length * (1 + Character_Stride);

            type Dot_Array is array (1 .. Columns) of POV_Sim.Byte;
            subtype Display_Range is Integer range 1 .. 120;

            function Translate_String return Dot_Array is
               Bitmap : Dot_Array := (others => 0);
            begin
               for Index in Text'Range loop
                  declare
                     -- The index of the first column where this character will
                     -- be written
                     Start_Column : Integer :=
                       1 + (1 + Character_Stride) * (Index - 1);
                  begin
                     for Character_Column in 0 .. Character_Stride - 1 loop
                        Bitmap (Start_Column + Character_Column) :=
                          Chars_8x5.Char_Map (Text (Index), Character_Column);
                     end loop;
                  end;
               end loop;

               return Bitmap;
            end Translate_String;

            Bitmap : Dot_Array := Translate_String;
         begin
            for Left_Shift in Bitmap'First .. Bitmap'Last - Display_Range'Last
            loop
               -- Wait for the LED strip to arrive at 0 deg
               POV_Sim.Wait_Zero_Crossing (T);

               for Column in Display_Range loop
                  declare
                     Theta : Integer := Display_Range'Last + Column - 1;
                  begin
                     delay until T + Milliseconds (4 * Theta);
                     POV_Sim.Drive_LEDs (Bitmap (Column + Left_Shift));
                  end;
               end loop;
            end loop;
         end;

         Close (File => Input_File);
      end;
   end loop;

   POV_Sim.Wait_Zero_Crossing (T);

   Put_Line ("Ending simulation");
   POV_Sim.End_Simulation;
end Display_With_Scroll;
