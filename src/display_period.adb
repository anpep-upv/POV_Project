-- display_period.adb
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

with Ada.Real_Time; use Ada.Real_Time;
with Ada.Text_IO;   use Ada.Text_IO;

procedure Display_Period is
   type Dot_Array is array (1 .. 120) of POV_Sim.Byte;

   Bitmap   : Dot_Array;
   T_0, T_1 : Time;
   T_Delta  : Time_Span;

   function Translate_String (Text : in String) return Dot_Array is
      Character_Stride  : constant Integer := 5;
      Max_String_Length : constant Integer :=
        Dot_Array'Last / (1 + Character_Stride);

      Bitmap : Dot_Array := (others => 0);
      Length : Integer   := Integer'Min (Max_String_Length, Text'Length);
   begin
      for Index in 1 .. Length loop
         declare
            Start_Column : Integer := 1 + (1 + Character_Stride) * (Index - 1);
         begin
            for Character_Column in 0 .. Character_Stride - 1 loop
               Bitmap (Start_Column + Character_Column) :=
                 Chars_8x5.Char_Map (Text (Index), Character_Column);
            end loop;
         end;
      end loop;

      return Bitmap;
   end Translate_String;
begin
   Put_Line ("Starting simulation");
   POV_Sim.Start_Simulation;

   -- Wait for the LED strip to arrive at 0 deg
   POV_Sim.Wait_Zero_Crossing (T_0);

   for Iteration in 1 .. 10 loop
      -- Wait for the LED strip to arrive at 0 deg again
      POV_Sim.Wait_Zero_Crossing (T_1);
      -- Compute period
      T_Delta := T_1 - T_0;
      -- Use current time as reference for next arrival
      T_0 := T_1;

      Bitmap :=
        Translate_String
          ("Period =" & To_Duration (T_Delta)'Image (1 .. 9) & " s.");

      for Column in Bitmap'Range loop
         declare
            Theta : Integer := 119 + Column;
         begin
            delay until T_1 + Milliseconds (4 * Theta);
            POV_Sim.Drive_LEDs (Bitmap (Column));
         end;
      end loop;
   end loop;

   POV_Sim.Wait_Zero_Crossing (T_0);

   Put_Line ("Ending simulation");
   POV_Sim.End_Simulation;
end Display_Period;
