-- pov_test.adb
-- Copyright (c) 2021 �ngel P�rez <aperpor@upv.edu.es>
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
use type POV_Sim.Byte;

with Ada.Real_Time; use Ada.Real_Time;
with Ada.Text_IO;   use Ada.Text_IO;

procedure Pov_Test is
   T : Time;
begin
   Put ("Starting simulation");
   POV_Sim.Start_Simulation;

   for Iteration in 0 .. 7 loop
      POV_Sim.Wait_Zero_Crossing (T);
      delay until T + Milliseconds (720);
      POV_Sim.Drive_LEDs (2**Iteration);
      Put (".");
   end loop;
   POV_Sim.Wait_Zero_Crossing (T);

   New_Line;
   Put_Line ("Ending simulation");
   POV_Sim.End_Simulation;
end Pov_Test;
