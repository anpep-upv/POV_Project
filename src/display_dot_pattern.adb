-- display_dot_pattern.adb
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
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Text_IO;   use Ada.Text_IO;

procedure Display_Dot_Pattern is
   type Dot_Array is array (1 .. 120) of POV_Sim.Byte;

   Bitmap : Dot_Array;
   T      : Time;

   procedure Init_Bitmap (Bitmap : out Dot_Array) is
   begin
      for Column in 1 .. 120 loop
         declare
            Upper_Half_L : Integer := 2**((Column - 1) mod 4);
            Lower_Half_L : Integer := 2**(7 - (Column - 1) mod 4);
            Upper_Half_R : Integer := 2**(3 - (Column - 1) mod 4);
            Lower_Half_R : Integer := 2**(4 + (Column - 1) mod 4);
         begin
            if ((Column - 1) / 4) mod 2 = 0 then
               Bitmap (Column) := POV_Sim.Byte (Upper_Half_L + Lower_Half_L);
            else
               Bitmap (Column) := POV_Sim.Byte (Upper_Half_R + Lower_Half_R);
            end if;
         end;
      end loop;
   end Init_Bitmap;
begin
   Put_Line ("Starting simulation");
   POV_Sim.Start_Simulation;

   Init_Bitmap (Bitmap);

   for Iteration in 1 .. 10 loop
      -- Wait for the LED strip to arrive at 0 deg
      POV_Sim.Wait_Zero_Crossing (T);

      for Column in Bitmap'Range loop
         declare
            Theta : Integer := 119 + Column;
         begin
            delay until T + Milliseconds (4 * Theta);
            POV_Sim.Drive_LEDs (Bitmap (Column));
         end;
      end loop;
   end loop;

   POV_Sim.Wait_Zero_Crossing (T);

   Put_Line ("Ending simulation");
   POV_Sim.End_Simulation;
end Display_Dot_Pattern;
